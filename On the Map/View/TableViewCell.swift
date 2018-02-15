//
//  TableViewCell.swift
//  On the Map
//
//  Created by Jaskirat Singh on 11/02/18.
//  Copyright © 2018 jassie. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{


    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    func configCell(student1: Students)
    {
        topText.text = student1.fullName
        bottomText.text = student1.link
    }
}
