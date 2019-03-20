//
//  ViewController.swift
//  Pick Image App
//
//  Created by Suprianto Djamalu on 20/03/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var imgPicked:UIImageView!
    @IBOutlet weak var btnPick:UIButton!
    @IBOutlet weak var btnUpload:UIButton!
    @IBOutlet weak var ictLoading:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ictLoading.isHidden = true
    }
    
    @IBAction func pickImage(){
        
        let imgPicker = UIImagePickerController()
        
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .photoLibrary
        
        imgPicker.delegate = self
        
        present(imgPicker, animated:true)
        
    }
    
    @IBAction func upload(){
        
        ictLoading.isHidden = false
        ictLoading.startAnimating()
        btnUpload.isHidden = true
        
        AF.upload(multipartFormData: {mutilpartFormData in
            mutilpartFormData.append((self.imgPicked.image?.jpegData(compressionQuality: 0.25))!, withName: "image", fileName: "file.jpeg", mimeType: "image/jpeg")
            mutilpartFormData.append("IOS".data(using: String.Encoding.utf8)!, withName: "device")
            
        },
            to: "http://192.168.56.1/anows/ios_upload/upload.php").responseJSON{response in
                
                switch response.result{
                case .success(_):
                    self.ictLoading.isHidden = true
                    self.ictLoading.stopAnimating()
                    self.imgPicked.isHidden = true
                    self.btnPick.isHidden = false
                    
                    let alert = UIAlertController(title: "Upload", message: "Success", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                        
                    break;
                case .failure(_):
                    self.ictLoading.isHidden = true
                    self.ictLoading.stopAnimating()
                    self.btnUpload.isHidden = false
                    
                    let alert = UIAlertController(title: "Upload", message: "Failed", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    self.present(alert, animated: true)
                    
                    break
                }
                
        }
        
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        imgPicked.image = image
        
        imgPicked.isHidden = false
        btnUpload.isHidden = false
        btnPick.isHidden = true
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

