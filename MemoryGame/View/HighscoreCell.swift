//
//  HighscoreCell.swift
//  MemoryGame
//
//  Created by Arber Basha on 7.2.20.
//  Copyright © 2020 Arber Basha. All rights reserved.
//

import UIKit

class HighscoreCell: UITableViewCell {

    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPoints: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
