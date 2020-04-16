//
//  NumberPadCell.swift
//  Digit Bust
//
//  Created by Beautistar on 9/5/17.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import UIKit

class NumberPadCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        //You Code here
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2.0
        self.layer.borderColor = Constant.borderColor.cgColor
    }
    
    @IBOutlet weak var lblNumber: UILabel!
    
    
}
