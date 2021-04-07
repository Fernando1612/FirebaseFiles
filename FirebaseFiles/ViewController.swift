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
    
    var images: [StorageReference] = []
    
    let placeholderImage = UIImage(named:"placeholder")
    
    
    
    let storage = Storage.storage()
    
    var idImage: Int = 1
    var contador: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("viewDidLoad")
        
        
        let nib = UINib.init(nibName: "ImageCollectionViewCell", bundle: nil)
        coleccion.register(nib, forCellWithReuseIdentifier: "imageCellXIB")
        
        let isButtonEnabled = RemoteConfig.remoteConfig().configValue(forKey: "isButtonEnabled").boolValue
        
        if !isButtonEnabled{
            button.isEnabled = isButtonEnabled
            button.backgroundColor = .red
        }

        downloadImage()
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
        let imageRef = storageRef.child("images").child("profile").child("\(idImage + contador).jpg")
        contador = contador + 1
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: uploadMetaData) { (metadata, error) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("Image metadata: \(String(describing: metadata))")
            }
        }
    }
    
    func downloadImage(){
        let storageRef = storage.reference()
        
        let imageDownloadUrlRef = storageRef.child("images/profile/\(idImage).jpg")
        
        
        images.append(imageDownloadUrlRef)
        
        userImageView.sd_setImage(with: imageDownloadUrlRef, placeholderImage: placeholderImage)

        imageDownloadUrlRef.downloadURL { (url, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("URL:  \(String(describing: url!))")
            }
        }
        
    }
    
}

extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let optimizedImageData = userImage.jpegData(compressionQuality: 0.6){
            uploadImage(imageData: optimizedImageData)
            
            //poner imagen cuando se sube
            /*
            DispatchQueue.main.async {
                self.userImageView.image = userImage
            }*/
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCellXIB", for: indexPath) as! ImageCollectionViewCell
        
        
        let ref = images[indexPath.item]
        
        cell.imageViewCell.sd_setImage(with: ref, placeholderImage: placeholderImage)
        
        ref.downloadURL { (url, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("URL:  \(String(describing: url!))")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        let ref = images[indexPath.item]
        ref.getMetadata { metadata, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Metadata:    \(String(describing: metadata!))")
                
            }
          }
        
        viewController?.img = UIImage(named: "placeholder")!
        viewController?.name = "Detalles de la foto"
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
