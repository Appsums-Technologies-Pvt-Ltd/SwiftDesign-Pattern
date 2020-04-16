//
//  HomeViewController.swift
//  Digit Bust
//
//  Created by Beautistar on 9/4/17.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

class HomeViewController: UIViewController, GADBannerViewDelegate, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var Banner: GADBannerView!

    var bust_history = [ScoreEntity]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Banner.isHidden = true
        
        
        
        Banner.delegate = self
        
        Banner.adUnitID = "ca-app-pub-8966801546797059/8483305237"
        Banner.rootViewController = self
        Banner.load(GADRequest())
        
        authPlayer()
        
        
        
        

        // Do any additional setup after loading the view.
        
        /// save userdefault as object array
//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: bust_history)
//        UserDefaults.standard.set(encodedData, forKey: "bust_history")
//        UserDefaults.standard.synchronize()

    }

    @IBAction func leaderboardClicked(_ sender: Any) {
        let viewController = self.view.window?.rootViewController
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        viewController?.present(gcViewController, animated: true, completion: nil)
    }
    
    func authPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (view, error) in
            if let view = view {
                self.present(view, animated: true, completion: nil)
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        Banner.isHidden = false
    
    }

    func adView(bannerView: GADBannerView!, didFailtoReceiveAdWithError error: GADRequestError!) {
        Banner.isHidden = true
    
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
