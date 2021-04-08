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
    @IBOutlet weak var labelSize: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var imageRef: StorageReference
    var name = ""
    var img = UIImage()
    
    required init?(coder aDecoder: NSCoder) {
        let storageRef = Storage.storage().reference()
            self.imageRef = storageRef.child("images/profile/userProfile.png")
            super.init(coder: aDecoder)
    }
    
    func metadata(){
        let ref = imageRef
        ref.getMetadata { metadata, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let size = metadata?.size
                let tamaño = (Double(size!) / 1048576)
                self.label.text = ("Nombre:  \(metadata?.name ?? "")")
                self.labelSize.text = ("Tamaño: \(tamaño.redondear(numeroDeDecimales: 1)) Mb")
                self.labelDate.text = ("Fecha:  \(metadata?.timeCreated ?? Date())")
            }
          }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.sd_setImage(with: imageRef)
        metadata()
        // Do any additional setup after loading the view.
    }
}

extension Double {
    func redondear(numeroDeDecimales: Int) -> String {
        let formateador = NumberFormatter()
        formateador.maximumFractionDigits = numeroDeDecimales
        formateador.roundingMode = .down
        return formateador.string(from: NSNumber(value: self)) ?? ""
    }
}
