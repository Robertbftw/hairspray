//
//  Articles.swift
//  Hairspray
//
//  Created by Robert Boerema on 2/18/16.
//
//

import UIKit
import SwiftyJSON
import Haneke
import Alamofire
import SwiftHEXColors

class Articles: UIViewController {
    
    var articleHeightShort = CGFloat()
    var articleHeight = CGFloat()
    
    var deviceFamily = NSUserDefaults.standardUserDefaults().objectForKey("deviceFamily") as! String
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch deviceCode{
        case 4:
            articleHeight = 200
            articleHeightShort = 200
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        //        print(userInfo)
        
        let status = Reach().connectionStatus()
        //        print(status)
        switch status {
        case .Unknown, .Offline: break
//            print("Offline:")
            //            notConnected()
        case .Online(.WWAN):
           getArticles()
        case .Online(.WiFi):
            getArticles()
        }
        
    }
    
    func getArticles(){
        let url = "http://school.robxert.com/hairspray/articles.php"
        var responseJSON = NSData()
        Alamofire.request(.GET, url)
            .responseString { response in
                responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                
                let readableJSON = JSON(data :responseJSON, options: NSJSONReadingOptions.MutableContainers)
                
                let contentArray = readableJSON.arrayValue
                var marginTop = CGFloat(0)
                var marginTopImg = CGFloat(10)
                var marginTopBar = CGFloat(100)
                
//                print(contentArray.count)
                
                for(var i = 0; i < contentArray.count; i += 1){
                    
                    let titleJSON = readableJSON[i]["title"].stringValue
                    let imgJSON = readableJSON[i]["img"].stringValue
                    let articleID = readableJSON[i]["id"].intValue
                    
                    let url = NSURL(string: "http://school.robxert.com/hairspray/admin/inc/img/\(imgJSON)")
                    let data = NSData(contentsOfURL: url!)
                    
                    let button = UIButton(type: UIButtonType.System) as UIButton
                    let images = UIImageView()
                    let pinkBar = UIImageView()
                    let titles = UILabel()
                    
                    if (data != nil) {
                        images.hnk_setImageFromURL(url!, placeholder: UIImage(named: "placeholder1.png"), format: Format<UIImage>(name: "image"), failure: { (error) -> () in }) { (image) -> () in
                             images.image = image
                        }
                    } else {
                        images.image = UIImage(named: "placeholder1.png")
                    }
                    
                    images.frame = CGRectMake(10, marginTopImg, 80, 80)
                    images.layer.cornerRadius = 10
                    images.layer.masksToBounds = true
                    images.contentMode = .ScaleAspectFill
                    
                    pinkBar.image = UIImage(named: "pink-box.png")
                    pinkBar.frame = CGRectMake(0, marginTopBar, screenWidth, 2)
                    
                    titles.text = titleJSON
                    titles.numberOfLines = 2
                    titles.frame = CGRectMake(100, marginTop, screenWidth - 130, 102)
                    titles.font = UIFont(name: "GurmukhiMN", size: 17)
                    titles.textColor = UIColor(hexString: "#779ECB")
                    
                    button.frame = CGRectMake(0, marginTop, screenWidth, 102)
                    button.tag = articleID
                    //                     button.setTitle(String(articleID), forState: UIControlState.Normal)
                    button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    self.scrollView.addSubview(button)
                    self.scrollView.addSubview(images)
                    self.scrollView.addSubview(titles)
                    self.scrollView.addSubview(pinkBar)
                    
                    marginTop = marginTop + 102
                    marginTopImg = marginTopImg + 102
                    marginTopBar = marginTopBar + 102
                    
                    self.scrollView.contentSize.height = marginTop
                    
                }
        }
        
        
    }
    
    func buttonAction(sender:UIButton!)
    {
        //        print("Button tapped")
        //        print(sender.tag)
        //        print(sender.currentTitle)
        NSUserDefaults.standardUserDefaults().setInteger(sender.tag, forKey: "ArticleNumber")
        let storyboard = UIStoryboard(name: deviceFamily, bundle: nil)
        let next = storyboard.instantiateViewControllerWithIdentifier("article") as UIViewController
        presentViewController(next, animated: true, completion: nil)
        
    }
    
}
