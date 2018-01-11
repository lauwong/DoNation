//
//  RequestTableViewCell.swift
//  DoNation
//
//  Created by Lauren Wong on 10/28/17.
//  Copyright © 2017 The Nueva Quest. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    //MARK: Properties

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var organizationLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
