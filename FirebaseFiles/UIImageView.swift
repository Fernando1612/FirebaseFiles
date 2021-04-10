//
//  UIImageView.swift
//  FirebaseFiles
//
//  Created by Proteco on 08/04/21.
//

import UIKit

extension UIImageView{
    
    func roundedImage(){
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

extension UIView{
    func addBackground(){
        let width = UIScreen.main.bounds.size.width
        let heigh = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0,y: 0,width: width,height: heigh))
        imageViewBackground.image = UIImage(named: "background")
        
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }
}

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = self.frame.size.width / 4
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: self.frame.size.width / 4).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 4
    }
}
