//
//  EventViewCell.swift
//  Turnstyle
//
//  Created by Ross Arkin on 11/29/16.
//  Copyright © 2016 6164 Productions. All rights reserved.
//

import UIKit

class EventViewCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!

    @IBOutlet weak var eventNameOut: UILabel!
    
    @IBOutlet weak var hostingFlagOut: UILabel!
    
    override func awakeFromNib() {
        eventNameOut.font = UIFont(name:"BebasNeue", size:18.0)
        hostingFlagOut.font = UIFont(name:"BebasNeue", size:18.0)
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
