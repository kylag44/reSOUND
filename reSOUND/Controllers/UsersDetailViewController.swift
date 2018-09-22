//
//  UsersDetailViewController.swift
//  reSOUND
//
//  Created by Kyla  on 2018-09-20.
//  Copyright © 2018 Kyla . All rights reserved.
//

import UIKit
import Firebase

class UsersDetailViewController: UIViewController, UIImagePickerControllerDelegate {
  
  @IBOutlet weak var detailView: UIView!
  @IBOutlet weak var detailNameLabel: UILabel!
  @IBOutlet weak var detailCityLabel: UILabel!
  @IBOutlet weak var detailProvinceLabel: UILabel!
  @IBOutlet weak var detailSkillsLabel: UILabel!
  @IBOutlet weak var connectButton: UIButton!
  
  var user: User?
  var ref: DatabaseReference!
  var skills = [String]()
  
  override func viewDidLoad() {
    view.setGradientBackground(colorOne: colors.black, colorTwo: colors.lightGrey)
    
    connectButton.layer.cornerRadius = connectButton.frame.size.height/2
    connectButton.layer.masksToBounds = true
    connectButton.setGradientBackground(colorOne: colors.orange, colorTwo: colors.brightOrange)

    configureDatabase()
    self.detailNameLabel.text = user?.name
    self.detailCityLabel.text = user?.city
    self.detailProvinceLabel.text = user?.province
    
   ref.child("skills").child("U001").observeSingleEvent(of: .value, with: { (snapshot) in
    guard let value = snapshot.value as? [String:Bool] else {return}
      for key in value.keys {
      if value[key] == true {
      self.skills.append(key)
      }
      }
    self.detailSkillsLabel.text = self.skills.joined(separator: ", ")
  })
    

  }
  
  func configureDatabase() {
    ref = Database.database().reference()
  }

  //#Pragma Mark Actions
  
  @IBAction func connectButtonPressed(_ sender: UIButton) {
    print("button pressed")
    sender.pulsate()
    sender.flash()
  }
  
  
}



