//
//  CustomTableViewCell.swift
//  TableView
//
//  Created by Christopher Loubassou on 27/04/2018.
//  Copyright © 2018 Christopher Loubassou. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
