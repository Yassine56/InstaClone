//
//  PostViewController.swift
//  Instagram
//
//  Created by Abouelouafa Yassine on 11/15/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Parse
class PostViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    
    @IBAction func chooseImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
             imageToPost.image = image
        }
        self.dismiss(animated: true, completion: nil )
    }
    
    func displayAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        if let image = imageToPost.image {
            let post = PFObject(className: "Post")
            post["comment"] = comment.text
            post["userId"] = PFUser.current()?.objectId
            post["userInfo"] = PFUser.current()?.email
            if let imagedata = UIImagePNGRepresentation(image) {
                
                 let imageFile = PFFile(name: "image.png", data: imagedata)
                post["imageFile"] = imageFile
                // spinner begin
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                // spinner ends
                post.saveInBackground(block: { (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if success {
                        self.displayAlert(title: "Image Poster", description: "Your image has been posted successfully")
                        self.comment.text = ""
                        self.imageToPost.image = nil
                    } else {
                        self.displayAlert(title: "error", description: "couldn't post image, please try later.. ")
                        self.comment.text = ""
                        self.imageToPost.image = nil
                    }
                })
            }
            
        }
        
    }
    @IBOutlet var comment: UITextField!
    @IBOutlet var imageToPost: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
