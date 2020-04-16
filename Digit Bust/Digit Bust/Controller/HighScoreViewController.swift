//
//  HighScoreViewController.swift
//  Digit Bust
//
//  Created by Beautistar on 9/4/17.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblBust: UITableView!
    
    var bust_history = [ScoreEntity]()
    var sorted_history = [ScoreEntity]()
    
    var count:Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // retrieving a value for a key
        if let data = UserDefaults.standard.data(forKey: "bust_history"),
            let score_hostory = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ScoreEntity] {
            bust_history = score_hostory
            bust_history.forEach({print( $0._id, $0._score, $0._date)})
        } else {
            print("There is an issue")
        }
        
        tblBust.tableFooterView = UIView()
        
        //sort and get top 20 history

        let _sorted_history = bust_history.sorted {
            $0._score.compare($1._score, options: .numeric) == .orderedDescending
        }
        if _sorted_history.count > count {
            sorted_history = Array(_sorted_history.prefix(count))
        } else {
            sorted_history = _sorted_history
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorted_history.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreListCell") as! ScoreListCell
        cell.lblScore.text = String(sorted_history[indexPath.row]._score)
        cell.lblDate.text = sorted_history[indexPath.row]._date
        return cell
    }
}
