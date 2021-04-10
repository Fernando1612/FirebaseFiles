//
//  ViewController.swift
//  FirebaseFiles
//
//

import UIKit
import Firebase
import CoreServices
import FirebaseUI

class ViewController: UIViewController{

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var coleccion: UICollectionView!
    @IBOutlet var button: UIButton!
    @IBOutlet weak var UserImageContainer: UIView!
    
    var images: [StorageReference] = []
    
    let placeholderImage = UIImage(named:"placeholder")
    
    let storage = Storage.storage()
    
    let keyOne = "firstStringKey"
    
    var idImage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewDidLoad")
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.view.addBackground()
        
        imagenes()
        
        idImage = UserDefaults.standard.integer(forKey: keyOne)
        if idImage == 0{
            idImage = 1
        }
        
        let nib = UINib.init(nibName: "ImageCollectionViewCell", bundle: nil)
        coleccion.register(nib, forCellWithReuseIdentifier: "imageCellXIB")
        coleccion.backgroundColor = nil
        
        userImageView.applyshadowWithCorner(containerView: UserImageContainer)
        
        let isButtonEnabled = RemoteConfig.remoteConfig().configValue(forKey: "isButtonEnabled").boolValue
        
        if !isButtonEnabled{
            button.isEnabled = isButtonEnabled
            button.backgroundColor = .red
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear")
    }
    
    @IBAction func uploadImage(_ sender: UIButton){
        let userImagePicker = UIImagePickerController()
        userImagePicker.delegate = self
        
        userImagePicker.sourceType = .photoLibrary
        userImagePicker.mediaTypes = ["public.image"]
        present(userImagePicker, animated: true, completion: nil)
    }
    
    func uploadImage(imageData: Data){
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images").child("profile").child("\(idImage).jpg")
        idImage += 1
        
        UserDefaults.standard.set(idImage, forKey: keyOne)
        UserDefaults.standard.synchronize()
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: uploadMetaData) { [self] (metadata, error) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("Image metadata: \(String(describing: metadata))")
                self.downloadImage(imagen: imageRef)
            }
        }
    }
    

    
    
    func imagenes(){
        let storageRef = storage.reference()
        let ref = storageRef.child("images/profile/")
        ref.listAll { [self] (result, error) in
            if let error = error {
               print(error.localizedDescription)
             }
             for item in result.items {
                downloadImage(imagen: item)
            }
        }
    }
    
    func downloadImage(imagen: StorageReference){
        images.append(imagen)
        
        userImageView.sd_setImage(with: imagen)
        
        DispatchQueue.main.async {
            self.coleccion.reloadData()
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageData = userImage.jpegData(compressionQuality: 0.6){
            uploadImage(imageData: optimizedImageData)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate{
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellScale: CGFloat = 0.5
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScale)
        let insetX = (collectionView.bounds.width - cellWidth) / 2.0
        return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellXIB", for: indexPath) as! ImageCollectionViewCell
        
        let ref = images[indexPath.item]
        cell.imageViewCell.sd_setImage(with: ref, placeholderImage: placeholderImage)
        
        cell.imageViewCell.roundedImage()
        
        cell.contentView.clipsToBounds = false
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOpacity = 1
        cell.contentView.layer.shadowOffset = CGSize.zero
        cell.contentView.layer.shadowRadius = 10
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        
        let ref = images[indexPath.item]
        
        viewController?.imageRef = ref
        
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}


