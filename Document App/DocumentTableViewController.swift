//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Ethan LEGROS on 11/18/24.
//

import UIKit
import Foundation

extension Int {
    func formattedSize() -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB] // Définit les unités
        formatter.countStyle = .file // Style adapté aux fichiers
        return formatter.string(fromByteCount: Int64(self)) // Convertit en format lisible
    }
}

class DocumentTableViewController: UITableViewController {

    var documents: [DocumentFile] = []
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        
        super.viewDidLoad()
        self.title = "Documents"
        
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return documents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Défile une cellule réutilisable
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        let document = documents[indexPath.row]
        
        // Récupère le document correspondant
//        let document = DocumentFile.testDocumentFiles[indexPath.row]
        
        // Configure la cellule
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = "Taille : \(document.size.formattedSize()) - Type : \(document.type)"
        
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
            if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {
                
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
