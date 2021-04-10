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
    @IBOutlet weak var imageContainer: UIView!
    
    var imageRef: StorageReference
    var name = ""
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        image.sd_setImage(with: imageRef)
        metadata()
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        image.applyshadowWithCorner(containerView: imageContainer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        
        tapGesture.numberOfTapsRequired = 2
        image.addGestureRecognizer(tapGesture)
    }
    
    
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
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer){
        guard let gestureView  = gesture.view else{
            return
        }
        let size = gestureView.frame.size.width / 4
        
        let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
        heart.frame = CGRect(x: (gestureView.frame.size.width - size) / 2, y: (gestureView.frame.size.height - size) / 2, width: size, height: size)
        heart.tintColor = .white
        heart.alpha = 0
        gestureView.addSubview(heart)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            UIView.animate(withDuration: 0.5) {
                heart.alpha = 1
            } completion: { done in
                if done {
                    UIView.animate(withDuration: 1) {
                        heart.alpha = 0
                    } completion: { done in
                        if done {
                            heart.removeFromSuperview()
                        }
                    }
                }
            }

        }
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
