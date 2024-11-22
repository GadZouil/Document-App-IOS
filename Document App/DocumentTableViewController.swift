import UIKit
import Foundation
import QuickLook

extension Int {
    func formattedSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(self))
    }
}

extension DocumentTableViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        let selectedDocument = documents[selectedIndexPath.row]
        return selectedDocument.url as QLPreviewItem
    }
}

extension DocumentTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileUrl = urls.first else { return }
        copyFileToDocumentsDirectory(fromUrl: selectedFileUrl)
        reloadDocumentsList()
    }
}

class DocumentTableViewController: UITableViewController {
    var documents: [DocumentFile] = []
    var bundleFiles: [DocumentFile] = []
    var importedFiles: [DocumentFile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Liste de Documents"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
        bundleFiles = listFileInBundle()
        importedFiles = listFilesInDocumentsDirectory()
        documents = listFileInBundle()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? importedFiles.count : bundleFiles.count
    }

    @objc func addDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

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

    func reloadDocumentsList() {
        bundleFiles = listFileInBundle()
        importedFiles = listFilesInDocumentsDirectory()
        documents = importedFiles + bundleFiles
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        let document = indexPath.section == 0 ? importedFiles[indexPath.row] : bundleFiles[indexPath.row]
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "Taille : \(document.size.formattedSize()) - Type : \(document.type)"
        cell.imageView?.image = UIImage(systemName: "doc")
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Importés" : "Bundle"
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDocument = indexPath.section == 0 ? importedFiles[indexPath.row] : bundleFiles[indexPath.row]
        instantiateQLPreviewController(withUrl: selectedDocument.url)
    }

    func instantiateQLPreviewController(withUrl url: URL) {
        let previewController = QLPreviewController()
        previewController.dataSource = self
        navigationController?.pushViewController(previewController, animated: true)
    }

    struct DocumentFile {
        var title: String
        var size: Int
        var imageName: String? = nil
        var url: URL
        var type: String
    }

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
