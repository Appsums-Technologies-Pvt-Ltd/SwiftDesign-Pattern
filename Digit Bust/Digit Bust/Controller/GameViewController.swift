//
//  GameViewController.swift
//  Digit Bust
//
//  Created by Beautistar on 9/4/17.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import UIKit
import AudioToolbox
import GameKit

class GameViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, LTMorphingLabelDelegate {
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var lblTime: LTMorphingLabel!
    @IBOutlet weak var lblScore: LTMorphingLabel!
    @IBOutlet weak var cvPad: UICollectionView!
    
    var w:CGFloat = 0.0
    var h:CGFloat = 0.0
    
    var numbers:[Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
    var digit : Int = 0
    var kTapped : Int = 0
    var curValue : Int = 0
    
    var countTimer : Timer!
    var time:Int = 90
    var shake_animation : CABasicAnimation!
    var bust : Int = 0
    var kColorChange:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //shake animation of score label
        shake_animation = CABasicAnimation(keyPath: "position")
        shake_animation.duration = 0.03
        shake_animation.repeatCount = 4
        shake_animation.autoreverses = true
        shake_animation.fromValue = NSValue(cgPoint: CGPoint.init(x: lblScore.center.x - 10, y: lblScore.center.y))
        shake_animation.toValue = NSValue(cgPoint: CGPoint(x: lblScore.center.x + 10, y: lblScore.center.y))
    }
    
    func initView() {
        
        time = Constant.total_time
        bust = 0
        let navHeight = self.navigationController?.navigationBar.frame.size.height ?? 44.0
        
        w = (self.view.frame.size.width-30) / 3.0
        h = (self.view.frame.size.height - 20 - navHeight - 20) / 5.0
        
        timeView.layer.borderColor = Constant.borderColor.cgColor
        scoreView.layer.borderColor = Constant.borderColor.cgColor

        initGame()
        startTimer()
    }
    
    func initGame() {
        
        kTapped = 0
        digit = 0
        curValue = 0
        
        //generate random pad
        numbers.shuffle()
        cvPad.reloadData()
        updateDigit()
        
        kColorChange = true
        
        self.lblTime.morphingEffect = .evaporate
        
    }
    
    func startTimer() {
        
        countTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.aTimer), userInfo: nil, repeats: true)
    }
    
    func aTimer() {
        
        if time >= 0 {
            
            lblTime.text = String(time)
            time -= 1;
            
        } else {
            
            countTimer.invalidate()
            gotoResultVC()
            sound(kCase: Constant.kSuccess)
        }
        
        if time < Constant.warnning_time && kColorChange {
            timeView.layer.borderColor = Constant.mainColor.cgColor
            scoreView.layer.borderColor = Constant.mainColor.cgColor
            cvPad.reloadData()
            kColorChange = false
        }
    }
    
    func gotoResultVC() {
        let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        resultVC.bust = self.bust
        saveScoreToLeaderboard(score: self.bust)
        self.present(resultVC, animated:true)
    }
    
    func saveScoreToLeaderboard(score: Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier:"digit.bust.leaderboard")
            scoreReporter.value = Int64(score)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    
    func updateDigit() {
        //generate random 5 digit number
        digit = generateRandomNumber(numDigit: Constant.kDigit)
        lblScore.text = String(digit)
    }
    
    func generateRandomNumber(numDigit: Int) -> Int {
        var place = 1
        var finalNumber = 0;
        
        for _ in 0 ..< numDigit {
            place *= 10
            let randomNumber = arc4random_uniform(10)
            finalNumber += Int(randomNumber) * place
        }
        
        finalNumber = finalNumber / 10
        
        if finalNumber == 0 {
            finalNumber = 99999
        }
        
        if finalNumber < 10000 {
            
            while finalNumber < 10000 {
                finalNumber *= 10
            }
        }
        
        return finalNumber
    }
    
    //MARK:- CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Constant.btn_count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberPadCell", for: indexPath) as! NumberPadCell
        
        if time > Constant.warnning_time {
            cell.layer.borderColor = Constant.borderColor.cgColor
        } else {
            cell.layer.borderColor = Constant.mainColor.cgColor
        }
        
        if indexPath.row == Constant.reset_btn_idx {
            cell.lblNumber.text = "ReSeT"
            cell.lblNumber.adjustsFontSizeToFitWidth = true
        } else if indexPath.row == Constant.bust_btn_idx {
            cell.lblNumber.text = "BusT"
            cell.lblNumber.adjustsFontSizeToFitWidth = true
        } else {
            cell.lblNumber.text = String(format: "%d", numbers[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! NumberPadCell
        
        if indexPath.row == Constant.bust_btn_idx {//Bust
            if curValue == digit {// correct
                countTimer.invalidate()
                time += 3 // add 3 to timer
                startTimer()
                
                lblScore.morphingEffect = .sparkle
                lblScore.morphingDuration = 0.3
                self.bust += 1
                sound(kCase: 0)
                
            } else {//incorrect
                
                lblScore.layer.add(shake_animation, forKey: "position")
                lblScore.morphingEffect = .pixelate
                lblTime.morphingEffect = .pixelate
                
                time -= Constant.failed_time
                self.lblTime.transform = self.lblTime.transform.scaledBy(x: 0.7, y: 0.7);
                UIView.animate(withDuration: 0.3) {
                    self.lblTime.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
                sound(kCase: Constant.kIncorrect)
            }

            initGame()

            
        } else if indexPath.row == Constant.reset_btn_idx {//Reset
            time -= Constant.reset_time
            kTapped = 0
            curValue = 0
            
            self.lblTime.transform = self.lblTime.transform.scaledBy(x: 0.7, y: 0.7);
            UIView.animate(withDuration: 0.3) {
                self.lblTime.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            sound(kCase: Constant.kIncorrect)
        } else {
            
            cell.lblNumber.transform = cell.lblNumber.transform.scaledBy(x: 1.5, y: 1.5);
            UIView.animate(withDuration: 0.3) {
                cell.lblNumber.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            curValue += numbers[indexPath.row] * Int(pow(Double(10), Double(4-kTapped)))
            kTapped += 1
            
        }
    }
    
    func sound(kCase:Int) {
        
        var filename = ""
        let ext = "wav"
        
        if kCase == Constant.kCorrect {
            filename = "correct"
        } else if kCase == Constant.kIncorrect {
            filename = "incorrect"
        } else if kCase == Constant.kSuccess {
            filename = "endtime"
        }
        
        if let soundUrl = Bundle.main.url(forResource: filename, withExtension: ext) {
            var soundId: SystemSoundID = 0
            
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
            
            AudioServicesAddSystemSoundCompletion(soundId, nil, nil, { (soundId, clientData) -> Void in
                AudioServicesDisposeSystemSoundID(soundId)
            }, nil)
            
            AudioServicesPlaySystemSound(soundId)
        }
    }

}


 extension GameViewController : UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
 
        return CGSize(width: CGFloat(w), height: CGFloat(h))
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
 
        return 0
    }
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

extension GameViewController {
    
    func morphingDidStart(_ label: LTMorphingLabel) {
        
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        
    }
    
    func morphingOnProgress(_ label: LTMorphingLabel, progress: Float) {
        
    }
    
}





