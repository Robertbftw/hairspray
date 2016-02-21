//
//  ViewController.swift
//  Hairspray
//
//  Created by Robert Boerema on 2/14/16.
//  Copyright © 2016 Robert Boerema. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke
import Alamofire

let screenSize: CGRect = UIScreen.mainScreen().bounds
let screenWidth = screenSize.width
let screenHeight = Int(screenSize.height)

var articleBoxX = CGFloat()
var articleBoxImgX = CGFloat()
var articleBoxTitleX = CGFloat()
var articleBoxVisitBtnX = CGFloat()

var checkVoteStartTimer = NSTimer()

let deviceCode = NSUserDefaults.standardUserDefaults().integerForKey("deviceCode")

var articleHeightShort = CGFloat()
var articleHeight = CGFloat()

class StartView: UIViewController {
    
    //Voting Part
    @IBOutlet var votingBtn: UIButton!
    @IBOutlet var votingDevider: UIImageView!
    
    @IBOutlet var articlesView: UIView!
    
    override func viewDidLoad() {
        
        switch deviceCode{
        case 4:
            articleHeight = 416
            articleHeightShort = 328
        case 5:
            articleHeight = 504
            articleHeightShort = 408
        case 6:
            articleHeight = 603
            articleHeightShort = 505
        case 7:
            articleHeight = 603
            articleHeightShort = 505
        default:
            articleHeight = 140
            articleHeightShort = 140
        }
        
        votingBtn.titleLabel?.font = UIFont(name: "Voyage", size: 30)
        votingBtn.layer.cornerRadius = 3
        
        if NSUserDefaults.standardUserDefaults().objectForKey("voteDone") != nil {
            votingBtn.setTitle("Bekijk De Resultaten", forState: .Normal)
        }
        
        //For Internet
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
//                votingButton()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Internet
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        
        let status = Reach().connectionStatus()
        switch status {
        case .Unknown, .Offline:
            checkVoteStartTimer.invalidate()
            let alert = UIAlertView(title: "Geen Internet", message: "Zorg ervoor dat je verbonden bent met het Internet!.", delegate: nil, cancelButtonTitle: "👍")
            alert.show()
            articlesView.hidden = true
        case .Online(.WWAN):
            checkVoteStartTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "votingButton", userInfo: nil, repeats: true)
            votingButton()
            if articlesView.hidden == true {
                articlesView.hidden = false
            }
        case .Online(.WiFi):
            checkVoteStartTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "votingButton", userInfo: nil, repeats: true)
            votingButton()
            if articlesView.hidden == true {
                articlesView.hidden = false
            }
        }
        
    }
    
    //Vote
    func votingButton(){
        
        var isError = Bool()
        let url = "http://school.robxert.com/hairspray/settings.php"
        var responseJSON = NSData()
        Alamofire.request(.GET, url)
            .response { request, response, data, error in
//                print(request)
//                print(response)
//                print("Error: \(error)")
                
                if (error != nil) {
                    isError = true
                } else {
                    isError = false
                }
            }
            .responseString { response in
                
                if isError == false {
                    responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let readableJSON = JSON(data :responseJSON, options: NSJSONReadingOptions.MutableContainers)
                    
                    let startVoting = readableJSON[0]["visible"].intValue
                    if startVoting == 1 {
                        
                        UIView.animateWithDuration(0.5) {
                            self.votingBtn.hidden = false
                            self.votingDevider.hidden = false
                            
                            self.articlesView.frame = CGRectMake(0, 162, screenWidth, articleHeightShort)
                        }
                        
                    } else {
                        
                        UIView.animateWithDuration(0.5) {
                            self.votingBtn.hidden = true
                            self.votingDevider.hidden = true
                            
//                            print(articleHeight)
                            self.articlesView.frame = CGRectMake(0, 64.5, screenWidth, articleHeight)
                        }
                        
                    }
                }
                
                
                
        }
        
    }
    
    
    
    
    //Button Actions
    
    @IBAction func voteNowBtn(sender: AnyObject) {
        
    }
    
}

