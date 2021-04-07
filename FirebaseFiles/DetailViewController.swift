//
//  DetailViewController.swift
//  FirebaseFiles
//
//  Created by Proteco on 06/04/21.
//

import UIKit
import Firebase
import CoreServices
import FirebaseUI

class DetailViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var imageRef: StorageReference
    var name = ""
    var img = UIImage()
    
    required init?(coder aDecoder: NSCoder) {
        let storageRef = Storage.storage().reference()
            self.imageRef = storageRef.child("images/profile/userProfile.png")
            super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        label.text = name
        image.sd_setImage(with: imageRef)
        
        // Do any additional setup after loading the view.
    }
    


}
