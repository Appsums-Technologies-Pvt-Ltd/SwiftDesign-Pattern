//
//  ScoreEntity.swift
//  Digit Bust
//
//  Created by Beautistar on 9/7/17.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import Foundation

class ScoreEntity : NSObject, NSCoding {
    
    var _id = ""
    var _score = ""
    var _date :String = ""
    
    override init() {
        
    }
    
    required init(coder decoder: NSCoder) {
        
        self._id = decoder.decodeObject(forKey: "b_id") as? String ?? ""
        self._date = decoder.decodeObject(forKey: "b_date") as? String ?? ""
        self._score = decoder.decodeObject(forKey: "b_score") as? String ?? ""
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(_id, forKey: "b_id")
        coder.encode(_date, forKey: "b_date")
        coder.encode(_score, forKey: "b_score")
    }
}

