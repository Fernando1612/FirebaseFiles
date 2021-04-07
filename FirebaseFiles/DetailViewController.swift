//
//  DetailViewController.swift
//  FirebaseFiles
//
//  Created by Proteco on 06/04/21.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var name = ""
    var img = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(name)
        label.text = name
        image.image = img
        //image.image = UIImage(named: name)

        // Do any additional setup after loading the view.
    }
    


}
