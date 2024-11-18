//
//  DocumentViewController.swift
//  Document App
//
//  Created by Ethan LEGROS on 11/18/24.
//

import Foundation
import UIKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Vérifier que imageName n'est pas nil
        if let imageName = imageName {
            
            // 2. Afficher l'image dans l'ImageView
            imageView.image = UIImage(named: imageName)
        }
    }


}
