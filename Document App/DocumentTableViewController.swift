import UIKit
import QuickLook

// Extension pour formater la taille des fichiers
extension Int {
    func formattedSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(self))
    }
}

class DocumentTableViewController: UITableViewController, QLPreviewControllerDataSource, UIDocumentPickerDelegate, UISearchResultsUpdating {
    
    var bundleFiles: [DocumentFile] = [] // Fichiers du bundle
    var importedFiles: [DocumentFile] = [] // Fichiers importés
    var filteredBundleFiles: [DocumentFile] = [] // Fichiers filtrés dans le bundle
    var filteredImportedFiles: [DocumentFile] = [] // Fichiers filtrés importés
    var searchController: UISearchController! // Instance de UISearchController

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Liste de Documents"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))

        // Récupérer les fichiers depuis le bundle et le dossier Documents
        bundleFiles = listFileInBundle()
        importedFiles = listFilesInDocumentsDirectory()

        setupSearchController() // Configure la recherche
    }

    // Configuration du UISearchController
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Rechercher un document"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // Mise à jour des résultats de recherche
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            filteredBundleFiles = []
            filteredImportedFiles = []
        } else {
            filteredBundleFiles = bundleFiles.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            filteredImportedFiles = importedFiles.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }

    // Nombre de sections : une pour "Importés", une pour "Bundle"
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    // Titre des sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Importés" : "Bundle"
    }

    // Nombre de lignes dans chaque section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return section == 0 ? filteredImportedFiles.count : filteredBundleFiles.count
        } else {
            return section == 0 ? importedFiles.count : bundleFiles.count
        }
    }

    // Configuration des cellules
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        let document: DocumentFile

        if searchController.isActive {
            document = indexPath.section == 0 ? filteredImportedFiles[indexPath.row] : filteredBundleFiles[indexPath.row]
        } else {
            document = indexPath.section == 0 ? importedFiles[indexPath.row] : bundleFiles[indexPath.row]
        }

        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "Taille : \(document.size.formattedSize()) - Type : \(document.type)"
        cell.imageView?.image = UIImage(systemName: "doc")
        return cell
    }

    // Action lors de la sélection d'une cellule
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let document: DocumentFile

        if searchController.isActive {
            document = indexPath.section == 0 ? filteredImportedFiles[indexPath.row] : filteredBundleFiles[indexPath.row]
        } else {
            document = indexPath.section == 0 ? importedFiles[indexPath.row] : bundleFiles[indexPath.row]
        }

        instantiateQLPreviewController(withUrl: document.url)
    }

    // Ajout d'un document via le Document Picker
    @objc func addDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    // Gestion du résultat du Document Picker
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileUrl = urls.first else { return }
        copyFileToDocumentsDirectory(fromUrl: selectedFileUrl)
        reloadDocumentsList()
    }

    // Copie le fichier importé dans le dossier Documents
    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)

        if FileManager.default.fileExists(atPath: destinationUrl.path) { return }

        do {
            try FileManager.default.copyItem(at: url, to: destinationUrl)
        } catch {
            print("Erreur lors de la copie : \(error)")
        }
    }

    // Récupère les fichiers dans le dossier Documents
    func listFilesInDocumentsDirectory() -> [DocumentFile] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrls = try! FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        return fileUrls.compactMap { url in
            guard let resourcesValues = try? url.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey]),
                  let name = resourcesValues.name,
                  let contentType = resourcesValues.contentType else { return nil }
            return DocumentFile(
                title: name,
                size: resourcesValues.fileSize ?? 0,
                url: url,
                type: contentType.description
            )
        }
    }

    // Recharge la liste des documents
    func reloadDocumentsList() {
        bundleFiles = listFileInBundle()
        importedFiles = listFilesInDocumentsDirectory()
        tableView.reloadData()
    }

    // Prévisualise un fichier avec QLPreviewController
    func instantiateQLPreviewController(withUrl url: URL) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        navigationController?.pushViewController(previewController, animated: true)
    }

    // QLPreviewControllerDataSource : Nombre d'éléments à prévisualiser
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    // QLPreviewControllerDataSource : Fichier à prévisualiser
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        let document = selectedIndexPath.section == 0 ? importedFiles[selectedIndexPath.row] : bundleFiles[selectedIndexPath.row]
        return document.url as QLPreviewItem
    }

    // Récupère les fichiers dans le bundle principal
    func listFileInBundle() -> [DocumentFile] {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        return items.compactMap { item in
            guard !item.hasSuffix("DS_Store") else { return nil }
            let currentUrl = URL(fileURLWithPath: path + "/" + item)
            guard let resourcesValues = try? currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey]),
                  let name = resourcesValues.name,
                  let contentType = resourcesValues.contentType else { return nil }
            return DocumentFile(
                title: name,
                size: resourcesValues.fileSize ?? 0,
                url: currentUrl,
                type: contentType.description
            )
        }
    }
}

// Modèle de données pour représenter un fichier
struct DocumentFile {
    var title: String
    var size: Int
    var imageName: String? = nil
    var url: URL
    var type: String
}
