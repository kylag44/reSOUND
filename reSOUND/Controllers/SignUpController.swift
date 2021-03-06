//
//  SignUpController.swift
//  reSOUND
//
//  Created by Kyla  on 2018-09-25.
//  Copyright © 2018 Kyla . All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  @IBOutlet weak var signUpImageView: UIImageView!
  @IBOutlet weak var signUpName: UITextField!
  @IBOutlet weak var signUpCity: UITextField!
  @IBOutlet weak var signUpProvince: UITextField!
  @IBOutlet weak var signUpEmail: UITextField!
  @IBOutlet weak var signUpDescription: UITextField!
  @IBOutlet weak var signUpLink: UITextField!
  @IBOutlet weak var signUpSkills: UILabel!
  @IBOutlet weak var popOverSignUp: PopOverSignUp!
  @IBOutlet weak var popOverHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var popOverTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var signUpAddSkillsButton: gradientButton!
  
  //  @IBOutlet weak var profileView: UIView!
  //  @IBOutlet weak var skillsButton: UIButton!

  var user: User?
  var userName  = Auth.auth().currentUser!
  let database = DatabaseManager.shared
  let storageRef = Storage.storage()
  var skillsArray = [String]()
  var picsArray = [UIImage]()
  var skillSet = ["engineer":false,"lyricist":false,"singer":false,"producer":false,"musician":false,"top liner":false,"listener":false,"composer":false]
  var imagePicker: UIImagePickerController!
 

  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      signUpCity.delegate = self
      signUpName.delegate = self
      signUpProvince.delegate = self
      signUpLink.delegate = self
      signUpEmail.delegate = self
      signUpDescription.delegate = self
//      self.signUpName.text = userName.displayName
//      self.signUpEmail.text = userName.email
        view.setGradientBackground(colorOne: colors.black, colorTwo: colors.darkGrey)
      
        self.signUpName.attributedPlaceholder = NSAttributedString(string: "enter name",
                                                                      attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        self.signUpCity.attributedPlaceholder = NSAttributedString(string: "enter city",
                                                                      attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        self.signUpProvince.attributedPlaceholder = NSAttributedString(string: "enter province",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        self.signUpEmail.attributedPlaceholder = NSAttributedString(string: "enter email",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        self.signUpDescription.attributedPlaceholder = NSAttributedString(string: "enter a little description about yourself", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        self.signUpLink.attributedPlaceholder = NSAttributedString(string: "enter any links to your work if applicable", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
      
        self.signUpImageView.layer.masksToBounds = false
        self.signUpImageView.layer.cornerRadius = signUpImageView.frame.width/2
        self.signUpImageView.clipsToBounds = true
        self.signUpImageView.layer.borderWidth = 4
        self.signUpImageView.layer.borderColor = colors.white.cgColor
      
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        signUpImageView.isUserInteractionEnabled = true
        signUpImageView.addGestureRecognizer(imageTap)
     
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }

  func updateProfile() {
    var user = [String:String]()
    let keys = ["name","province","email","city", "id","link","userDescription"]
  
    let userID = database.currentUser!.uid
    user["name"] = signUpName.text
    user["province"] = signUpProvince.text
    user["email"] = signUpEmail.text
    user["city"] = signUpCity.text
    user["id"] = userID
    user["link"] = signUpLink.text
    user["userDescription"] = signUpDescription.text
  
    for key in keys {
      database.reference.child(database.usersPath + "/\(userID)/" + key).setValue(user[key])
    }
  }

  func updateSkills() {
    var skill = [String:Bool]()
    let keys = ["Audio Engineer", "Lyricist", "Producer", "Singer","Musician","Top Liner","Listener","Composer"]
  
    print(skillSet)
    let skills = database.currentUser!.uid
    skill["Audio Engineer"] = skillSet["engineer"]
    skill["Lyricist"] = skillSet["lyricist"]
    skill["Producer"] = skillSet["producer"]
    skill["Singer"] = skillSet["singer"]
    skill["Musician"] = skillSet["musician"]
    skill["Top Liner"] = skillSet["top liner"]
    skill["Listener"] = skillSet["listener"]
    skill["Composer"] = skillSet["composer"]
  
    for key in keys {
      database.reference.child(database.skillsPath + "/\(skills)/" + key).setValue(skill[key])
    }
  }
  
  func uploadPic(profileImage: UIImage) {
    let userID = database.currentUser!.uid
    let storage = Storage.storage().reference()
    let tempImageRef = storage.child("users/\(userID)/usersProfileImage.jpg")
  
    let image = profileImage
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
  
    tempImageRef.putData(UIImageJPEGRepresentation(image, 0.8)!, metadata:metaData) { (data, error) in
      if error == nil {
        print("upload successful")
      } else {
        print("error with upload pic")
      }
    }
  }
  
  func animateBackgroundColor() {
    UIView.animate(withDuration: 15, delay: 0, options: [.autoreverse, .curveLinear, .repeat], animations: {
      let x = -(self.signUpImageView.frame.width - self.view.frame.width)
      self.signUpImageView.transform = CGAffineTransform(translationX: x, y: 0)
    })
  }

  ////#Pragma Mark Actions
  @IBAction func skillsButtonPressed(_ sender: gradientButton) {
    popOverSignUp.signUpController = self 
      if (sender.pressed == true) {
        popOverTopConstraint.constant +=
          (popOverHeightConstraint.constant * -1)
        sender.setTitle("done", for: UIControlState.normal)
      }  else  {
        popOverTopConstraint.constant -=
          (popOverHeightConstraint.constant * -1)
        sender.setTitle("add skills", for: UIControlState.normal)
      }
      UIView.animate(withDuration: 2.0) {}
  }

  @IBAction func signUpButtonPressed(_ sender: UIButton) {
      updateSkills()
      updateProfile()
      uploadPic(profileImage: self.signUpImageView.image!)
  }
  
  ////Pragma Mark: Image Picker
  @objc func openImagePicker(_ sender:Any) {
    self.present(imagePicker, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
  
    if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
      self.signUpImageView.image = pickedImage
    }
  
    picker.dismiss(animated: true, completion: nil)
  }
  
  
  //  Pragma Mark: Text Field Delegate
  func textFieldDidBeginEditing(_ textField: UITextField) {
    animateViewMoving(up: true, moveValue: 120)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    animateViewMoving(up: false, moveValue: 120)
  }
  
  func animateViewMoving (up:Bool, moveValue :CGFloat){
    let movementDuration:TimeInterval = 0.3
    let movement:CGFloat = ( up ? -moveValue : moveValue)
    UIView.beginAnimations( "animateView", context: nil)
    UIView.setAnimationBeginsFromCurrentState(true)
    UIView.setAnimationDuration(movementDuration )
    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
    UIView.commitAnimations()
  }
  
  //Dismiss keyboard method
  func keyboardDismiss() {
    signUpName.resignFirstResponder()
    signUpProvince.resignFirstResponder()
    signUpCity.resignFirstResponder()
    signUpLink.resignFirstResponder()
    signUpDescription.resignFirstResponder()
    signUpEmail.resignFirstResponder()
  }
  
  //ADD Gesture Recignizer to Dismiss keyboard then view tapped
  @IBAction func viewTapped(_ sender: AnyObject) {
    keyboardDismiss()
  }
  
  //Dismiss keyboard using Return Key (Done) Button
  //Do not forgot to add protocol UITextFieldDelegate
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    keyboardDismiss()
    return true
  }
  
}





