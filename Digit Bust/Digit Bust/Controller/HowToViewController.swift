//
//  HowToViewController.swift
//  Digit Bust
//
//  Created by Beautistar on 9/4/17.
//  Copyright © 2017 Beautistar. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tvHowTo: UITextView!
    
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
        
        label.text = "    You have 90 seconds to enter as many codes correctly as possible.\n\n    If a mistake is made you can press RESET and will lose 2 seconds but the code and digits will stay the same.\n\n    Press BUST when think code is entered correctly. If entered correctly a new code will appear and digits will scramable. If entered incorrectly then will lose 5 seconds, digits will scramble and a new code will appear.\n\n  Good Luck \n\n    Take a screen shot of your score and share with the world using @digitbust on instagram and or fb.me/digitbustapp.com"
        let strHowTo = (label.text)!
        let underlineAttriString = NSMutableAttributedString(string: strHowTo)
        let range1 = (strHowTo as NSString).range(of: "RESET")
        underlineAttriString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
        let range2 = (strHowTo as NSString).range(of: "BUST")
        underlineAttriString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range2)
        label.attributedText = underlineAttriString
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
