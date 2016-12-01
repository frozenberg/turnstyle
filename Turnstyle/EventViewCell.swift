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
    @IBOutlet weak var overLayView: UIView!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var transparentBox: UIView!
    
    
    override func awakeFromNib() {
        
        
        eventNameOut.font = UIFont(name:"BebasNeue", size:18.0)
        hostingFlagOut.font = UIFont(name:"BebasNeue", size:18.0)
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
            let color = lineView.backgroundColor
            super.setSelected(selected, animated: animated)
        
            if(selected) {
                    lineView.backgroundColor = color
                    overLayView.backgroundColor = color
                    transparentBox.backgroundColor = color
            }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            let color = overLayView.backgroundColor
            super.setHighlighted(highlighted, animated: animated)
        
            if(highlighted) {
                    overLayView.backgroundColor = color
                
            }
    }
    

    
}
