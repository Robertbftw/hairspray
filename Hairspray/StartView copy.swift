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


class StartView: UIViewController {
    
    //    @IBOutlet var headerImg: UIImageView!
    @IBOutlet var logoImg: UIImageView!
    @IBOutlet var headerMenuBtn: UIButton!
    @IBOutlet var headerMenuBar: UINavigationBar!
    
    //    @IBOutlet var articleBox: [UIImageView]!
    @IBOutlet var articleBoxDeiver: [UIImageView]!
    @IBOutlet var articleBoxImg: [UIImageView]!
    @IBOutlet var articleBoxTitle: [UILabel]!
    @IBOutlet var articleBoxVisitBtn: [UIButton]!
    
    @IBOutlet var voteNowBtn: UIButton!
    @IBOutlet var voteNowDevider: UIImageView!
    
    override func viewDidLoad() {
        
        
        
        voteNowBtn.titleLabel?.font = UIFont(name: "Voyage", size: 30)
        voteNowBtn.layer.cornerRadius = 3
        
        if NSUserDefaults.standardUserDefaults().objectForKey("voteDone") != nil {
            voteNowBtn.setTitle("Bekijk De Resultaten", forState: .Normal)
        }
        
        logoImg.frame.origin.y = -100
        headerMenuBtn.frame.origin.y = -100
        headerMenuBar.frame.origin.y = -100
        
        UIView.animateWithDuration(1) {
            self.logoImg.frame.origin.y = 30
            self.headerMenuBtn.frame.origin.y = 27
            self.headerMenuBar.frame.origin.y = 20
        }
        
        voteNowBtn.hidden = true
        voteNowDevider.hidden = true
        
        //For Internet
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Functions
    
    //Initial Setup
    
    func setUp(){
        
        for (var i = 0; i < articleBoxDeiver.count; i += 1){
            print(i)
            articleBoxDeiver[i].frame.origin.x = -1000
            articleBoxImg[i].frame.origin.x = -1000
            articleBoxTitle[i].frame.origin.x = -1000
            articleBoxVisitBtn[i].frame.origin.x = -1000
        }

        
    }
    
    //Internet
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        //        print(userInfo)
        
        let status = Reach().connectionStatus()
        //        print(status)
        switch status {
        case .Unknown, .Offline:
            notConnected()
        case .Online(.WWAN):
            print("online")
            Connected()
        case .Online(.WiFi):
            print("online")
            Connected()
        }
        
    }
    
    func notConnected() {
        let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        
        checkVoteStartTimer.invalidate()
        
        for (var j = 0; j < articleBoxVisitBtn.count; j += 1){
            articleBoxImg[j].hidden = true
            articleBoxTitle[j].hidden = true
            articleBoxDeiver[j].hidden = true
            articleBoxVisitBtn[j].hidden = true
        }
    }
    
    func Connected() {
        loadArticles()
        checkVoting()
        setUp()
        
        checkVoteStartTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "checkVoting", userInfo: nil, repeats: true)
        
        if NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") != nil {
            
            if NSUserDefaults.standardUserDefaults().objectForKey("deviceDone") == nil{
                let deviceToken = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as! String
                registerDevice(deviceToken)
            } else {
                print("done")
            }
        }
    }
    
    //REGISTER DEVICE
    func registerDevice(token: String) {
        let url: NSURL = NSURL(string: "http://school.robxert.com/hairspray/registerdevice.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        
        let bodyData = "data=\(token)"
        request.HTTPMethod = "POST"
        
        NSUserDefaults.standardUserDefaults().setObject(1, forKey: "deviceDone")
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                (response, data, error) in
                print(response)
                
        }
        
    }
    
    //JSON STUFF
    
    func checkVoting(){
        
        let url = "http://school.robxert.com/hairspray/settings.php"
        var responseJSON = NSData()
        Alamofire.request(.GET, url)
            .responseString { response in
                responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                
                let readableJSON = JSON(data :responseJSON, options: NSJSONReadingOptions.MutableContainers)
                
                let startVoting = readableJSON[0]["visible"].intValue
                
                if startVoting == 1 {
                    
                    //            checkVoteStartTimer.invalidate()
                    
                    if self.voteNowBtn.hidden == true {
                        self.VoteActive(true)
                        self.delay(0.4){
                            self.voteNowBtn.alpha = 0
                            self.voteNowDevider.alpha = 0
                            self.voteNowBtn.hidden = false
                            self.voteNowDevider.hidden = false
                            UIView.animateWithDuration(0.5) {
                                self.voteNowBtn.alpha = 1
                                self.voteNowDevider.alpha = 1
                            }
                        }
                    }
                } else {
                    if self.voteNowBtn.hidden == false {
                        UIView.animateWithDuration(0.5) {
                            self.voteNowBtn.alpha = 0
                            self.voteNowDevider.alpha = 0
                        }
                        self.delay(0.6){
                            self.voteNowBtn.hidden = true
                            self.voteNowDevider.hidden = true
                            self.VoteActive(false)
                        }
                        
                    }
                }
        }
        
        //        let jsonData = NSData(contentsOfURL: NSURL(string: "http://school.robxert.com/hairspray/settings.php")!) as NSData!
        
        
        
        
        
    }
    
    func loadArticles(){
        
        let jsonData = NSData(contentsOfURL: NSURL(string: "http://school.robxert.com/hairspray/articles.php")!) as NSData!
        let readableJSON = JSON(data :jsonData, options: NSJSONReadingOptions.MutableContainers)
        
        articleBoxTitle[0].text = readableJSON[0]["title"].stringValue
        articleBoxTitle[1].text = readableJSON[1]["title"].stringValue
        articleBoxTitle[2].text = readableJSON[2]["title"].stringValue
        
        for(var i = 0; i < articleBoxImg.count; i += 1){
            
            let img =  readableJSON[i]["img"].stringValue
            let url = NSURL(string: "http://school.robxert.com/hairspray/img/\(img)")
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            
            if (data != nil) {
                
                loadArticleImg(url!, num: i)
                
                articleBoxImg[i].layer.cornerRadius = 10
                articleBoxImg[i].layer.masksToBounds = true
                
            } else {
                NSLog("error")
            }
        }
        
        
    }
    
    func loadArticleImg(imgURL: NSURL, num: Int) {
        self.articleBoxImg[num].hnk_setImageFromURL(imgURL, placeholder: UIImage(named: "placeholder1.png"), format: Format<UIImage>(name: "image"), failure: { (error) -> () in }) { (image) -> () in
            self.articleBoxImg[num].image = image
        }
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func VoteActive(answer: Bool){
        if answer == true {
            
            let gutter = CGFloat(100)
            
            var buttonStart = CGFloat(160)
            var titleStart = CGFloat(160)
            var imageStart = CGFloat(170)
            var deviderStart = CGFloat(260)
            
            for (var i = 0; i < articleBoxVisitBtn.count; i += 1){
                
                UIView.animateWithDuration(0.5) {
                    
                    if i == 0{
                        self.articleBoxVisitBtn[i].frame.origin.y = buttonStart
                        self.articleBoxTitle[i].frame.origin.y = titleStart
                        self.articleBoxImg[i].frame.origin.y = imageStart
                        self.articleBoxDeiver[i].frame.origin.y = deviderStart
                    } else {
                        self.articleBoxVisitBtn[i].frame.origin.y = buttonStart + gutter
                        self.articleBoxTitle[i].frame.origin.y = titleStart + gutter
                        self.articleBoxImg[i].frame.origin.y = imageStart + gutter
                        self.articleBoxDeiver[i].frame.origin.y = deviderStart + gutter
                        buttonStart = buttonStart + gutter
                        titleStart = titleStart + gutter
                        imageStart = imageStart + gutter
                        deviderStart = deviderStart + gutter
                    }
                }
            }
            
        } else {
            
            let gutter = CGFloat(100)
            
            var buttonStart = CGFloat(90)
            var titleStart = CGFloat(90)
            var imageStart = CGFloat(100)
            var deviderStart = CGFloat(190)
            
            for (var i = 0; i < articleBoxVisitBtn.count; i += 1){
                
                UIView.animateWithDuration(0.5) {
                    
                    if i == 0 {
                        self.articleBoxVisitBtn[i].frame.origin.y = buttonStart
                        self.articleBoxTitle[i].frame.origin.y = titleStart
                        self.articleBoxImg[i].frame.origin.y = imageStart
                        self.articleBoxDeiver[i].frame.origin.y = deviderStart
                    } else {
                        self.articleBoxVisitBtn[i].frame.origin.y = buttonStart + gutter
                        self.articleBoxTitle[i].frame.origin.y = titleStart + gutter
                        self.articleBoxImg[i].frame.origin.y = imageStart + gutter
                        self.articleBoxDeiver[i].frame.origin.y = deviderStart + gutter
                        buttonStart = buttonStart + gutter
                        titleStart = titleStart + gutter
                        imageStart = imageStart + gutter
                        deviderStart = deviderStart + gutter
                    }
                }
            }
        }
    }
    
    
    
    
    //Button Actions
    
    @IBAction func voteNowBtn(sender: AnyObject) {
        
    }
    
    @IBAction func articleOneBtn(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "ArticleNumber")
        articleBoxVisitBtn[0].backgroundColor = UIColor(red: 0.4, green: 1.0, blue: 0.2, alpha: 0.5)
    }
    
    @IBAction func ArticleTwoBtn(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "ArticleNumber")
    }
    
    @IBAction func ArticleThreeBtn(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "ArticleNumber")
    }
}

