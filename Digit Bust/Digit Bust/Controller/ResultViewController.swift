//
//  ResultViewController.swift
//  Digit Bust
//
//  Created by Beautistar on 9/6/17.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import UIKit

class ResultViewController: BaseViewController {

    @IBOutlet weak var lblScore: UILabel!
    
    var bust:Int = 0
    
    var bust_history = [ScoreEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {        
        
        lblScore.layer.borderWidth = 3
        lblScore.layer.borderColor = Constant.borderColor.cgColor
        lblScore.text = String(bust)
        
        //get history from userdefault
        bust_history.removeAll()
        // retrieving a value for a key
        if let data = UserDefaults.standard.data(forKey: "bust_history"),
            let score_hostory = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ScoreEntity] {
            bust_history = score_hostory
            bust_history.forEach({print( $0._id, $0._score, $0._date)})
        } else {
            print("There is an issue")
            let reEncodedData = NSKeyedArchiver.archivedData(withRootObject: bust_history)
            UserDefaults.standard.set(reEncodedData, forKey: "bust_history")
            UserDefaults.standard.synchronize()
        }
        
        //create new scoreEntity
        
        let _scoreEntity = ScoreEntity()
        
        _scoreEntity._score = String(self.bust)
        
        var last_id = -1
        if bust_history.count == 0 {
            last_id = -1
        } else {
            last_id = Int(bust_history.map{$0._id}.max()!) ?? -1
        }
        _scoreEntity._id = String(last_id + 1)
        
        
        //save date into userdefault
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        let date_str = formatter.string(from: date)
        _scoreEntity._date = date_str
        
        bust_history.append(_scoreEntity)
        
        /// save facebook album into userdefault as object array
        let reEncodedData = NSKeyedArchiver.archivedData(withRootObject: bust_history)
        UserDefaults.standard.set(reEncodedData, forKey: "bust_history")
        UserDefaults.standard.synchronize()
        
    }
    
    @IBAction func playAgainAction(_ sender: Any) {
        
        self.dismiss(animated:true)
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        let rootNav = self.storyboard?.instantiateViewController(withIdentifier: "rootNav") as! UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = rootNav
    }    
}
