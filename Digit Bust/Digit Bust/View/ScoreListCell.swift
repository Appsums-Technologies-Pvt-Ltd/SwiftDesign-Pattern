//
//  ScoreListCell.swift
//  Digit Bust
//
//  Created by Beautistar on 9/4/17.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import UIKit

class ScoreListCell: UITableViewCell {

    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
