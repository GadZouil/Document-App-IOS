//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Ethan LEGROS on 11/18/24.
//

import UIKit
import Foundation
import QuickLook

extension Int {
    func formattedSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB] // Définit les unités
        formatter.countStyle = .file // Style adapté aux fichiers
        return formatter.string(fromByteCount: Int64(self)) // Convertit en format lisible
    }
}

extension DocumentTableViewController: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1 // Un seul fichier à prévisualiser
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        // Retourne l'URL du fichier sélectionné
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        let selectedDocument = documents[selectedIndexPath.row]
        return selectedDocument.url as QLPreviewItem
    }
}

extension DocumentTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileUrl = urls.first else { return }
        copyFileToDocumentsDirectory(fromUrl: selectedFileUrl)
        reloadDocumentsList() // Fonction pour recharger la liste des documents
    }
}


class DocumentTableViewController: UITableViewController {

    var documents: [DocumentFile] = []
    var bundleFiles: [DocumentFile] = []  // Fichiers dans le bundle
    var importedFiles: [DocumentFile] = []  // Fichiers importés

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Liste de Documents"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
//        documents = listFileInBundle() + listFilesInDocumentsDirectory()
        
        // Récupérer les fichiers dans le bundle
        bundleFiles = listFileInBundle()
        
        // Récupérer les fichiers dans le dossier Documents
        importedFiles = listFilesInDocumentsDirectory()
        
        // Charge les fichiers du bundle
        documents = listFileInBundle()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2 // Deux sections : Importés et Bundle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return importedFiles.count // Section Importés
        } else {
            return bundleFiles.count // Section Bundle
        }    }
    
    @objc func addDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        
        do {
            try FileManager.default.copyItem(at: url, to: destinationUrl)
        } catch {
            print("Erreur lors de la copie : \(error)")
        }
    }
    
    func listFilesInDocumentsDirectory() -> [DocumentFile] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrls = try! FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        
        var documentList = [DocumentFile]()
        for fileUrl in fileUrls {
            let resourcesValues = try! fileUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
            documentList.append(DocumentFile(
                title: resourcesValues.name!,
                size: resourcesValues.fileSize ?? 0,
                imageName: nil, // Pas forcément une image
                url: fileUrl,
                type: resourcesValues.contentType?.description ?? "unknown"
            ))
        }
        return documentList
    }

//    func reloadDocumentsList() {
//        documents = listFileInBundle() + listFilesInDocumentsDirectory()
//        tableView.reloadData()
//    }
    
    func reloadDocumentsList() {
        importedFiles = listFilesInDocumentsDirectory()
        tableView.reloadData()
    }


//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Défile une cellule réutilisable
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
//        let document = documents[indexPath.row]
//        
//        // Récupère le document correspondant
////        let document = DocumentFile.testDocumentFiles[indexPath.row]
//        
//        // Configure la cellule
//        cell.textLabel?.text = document.title
//        cell.detailTextLabel?.text = "Taille : \(document.size.formattedSize()) - Type : \(document.type)"
//        
//        return cell
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
//        let document = documents[indexPath.row]
//        cell.textLabel?.text = document.title
//        cell.detailTextLabel?.text = "Taille : \(document.size.formattedSize()) - Type : \(document.type)"
//        
//        // Ajoute un accessory type de disclosure
//        cell.accessoryType = .disclosureIndicator
//        
//        return cell
//    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        
        // Choisissez la liste en fonction de la section
        let document = indexPath.section == 0 ? importedFiles[indexPath.row] : bundleFiles[indexPath.row]
        
        // Configurez la cellule
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "Taille : \(document.size.formattedSize()) - Type : \(document.type)"
        cell.imageView?.image = UIImage(systemName: "doc") // Icône générique
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // Dans DocumentTableViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // 1. Récuperer l'index de la ligne sélectionnée
//        if let indexPath = tableView.indexPathForSelectedRow {
//            
//            // 2. Récuperer le document correspondant à l'index
//            let selectedDocument = documents[indexPath.row]
//            
//            // 3. Cibler l'instance de DocumentViewController via le segue.destination
//            if segue.identifier == "ShowDocumentSegue" { // Vérifier l'identifiant du segue
//                let destinationVC = segue.destination
//                
//                // 4. Caster le segue.destination en DocumentViewController
//                if let documentVC = destinationVC as? DocumentViewController {
//                    
//                    // 5. Remplir la variable imageName de l'instance de DocumentViewController avec le nom de l'image du document
//                    documentVC.imageName = selectedDocument.imageName
//                }
//            }
//        }
//    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Importés"
        } else {
            return "Bundle"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Récupère le document sélectionné
        let file = documents[indexPath.row]
        
        // Instancie et configure le QLPreviewController
        instantiateQLPreviewController(withUrl: file.url)
    }

    func instantiateQLPreviewController(withUrl url: URL) {
        // Crée une instance de QLPreviewController
        let previewController = QLPreviewController()
        
        // Définit le dataSource pour fournir le fichier à afficher
        previewController.dataSource = self
        
        // Présente le QLPreviewController
        navigationController?.pushViewController(previewController, animated: true)
    }

    
    
    struct DocumentFile {
        var title: String
        var size: Int
        var imageName: String? = nil
        var url: URL
        var type: String

        // Liste de test statique
        static let testDocumentFiles: [DocumentFile] = [
            DocumentFile(title: "Document 1", size: 100000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 2", size: 200000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 3", size: 300000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 4", size: 400000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 5", size: 500000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 6", size: 600000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 7", size: 700000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 8", size: 800000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 9", size: 900000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain"),
            DocumentFile(title: "Document 10", size: 1000000, imageName: nil, url: URL(string: "https://www.apple.com")!, type: "text/plain")
        ]
    }

    // Fonction pour lister les fichiers dans le bundle principal
    func listFileInBundle() -> [DocumentFile] {
        
        // Récupère une instance de FileManager pour interagir avec le système de fichiers
        let fm = FileManager.default
        
        // Récupère le chemin vers le dossier principal des ressources du bundle
        let path = Bundle.main.resourcePath!
        
        // Liste tous les fichiers et dossiers présents dans le chemin spécifié
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // Initialise un tableau vide pour stocker les fichiers sous forme de DocumentFile
        var documentListBundle = [DocumentFile]()
        
        // Parcourt tous les éléments trouvés dans le chemin
        for item in items {
            // Exclut les fichiers inutiles (.DS_Store) et sélectionne uniquement les fichiers ayant l'extension .jpg
            if !item.hasSuffix("DS_Store") {
//                && item.hasSuffix(".jpg")
                
                // Crée une URL pour accéder au fichier actuel
                let currentUrl = URL(fileURLWithPath: path + "/" + item)
                
                // Récupère des informations sur le fichier, comme son nom, sa taille et son type
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                
                // Ajoute le fichier à la liste en créant un objet DocumentFile
                documentListBundle.append(DocumentFile(
                    title: resourcesValues.name!,                    // Nom du fichier
                    size: resourcesValues.fileSize ?? 0,            // Taille en octets (par défaut 0 si introuvable)
                    imageName: item,                                // Nom de l'image
                    url: currentUrl,                                // URL complète du fichier
                    type: resourcesValues.contentType!.description  // Type du fichier (ex. : "image/jpeg")
                ))
            }
        }
        
        // Retourne la liste de fichiers sous forme de tableau de DocumentFile
        return documentListBundle
    }



    
}
