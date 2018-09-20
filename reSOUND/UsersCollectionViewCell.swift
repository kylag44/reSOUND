//
//  UsersCollectionViewCell.swift
//  reSOUND
//
//  Created by Kyla  on 2018-09-20.
//  Copyright © 2018 Kyla . All rights reserved.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var placeHolderView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  var user: User?
  
  func configureCell(withUser user:User){
    self.user = user
    nameLabel.text = user.name
    addressLabel.text = user.city + ", " + user.province
  }
  
}
