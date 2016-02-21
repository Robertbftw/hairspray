//
//  ArticleController.swift
//  Hairspray
//
//  Created by Robert Boerema on 2/14/16.
//  Copyright © 2016 Robert Boerema. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Haneke

var deviceFamily = NSUserDefaults.standardUserDefaults().objectForKey("deviceFamily") as! String

class ArticleController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleContent: UILabel!
    @IBOutlet var articleImg: UIImageView!
    
    @IBOutlet var contentWebView: UIWebView!
    
    override func viewDidLoad() {
        
        contentWebView.opaque = false
        contentWebView.backgroundColor = UIColor.clearColor()
        
        scrollView.contentSize.height = 1000
        
        let artNum = NSUserDefaults.standardUserDefaults().integerForKey("ArticleNumber")
        getArticle(artNum)
        
//        checkVoteStartTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "scrollTop", userInfo: nil, repeats: true)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArticle(articleNumber: Int){
        
        print(articleNumber)
        
        let jsonData = NSData(contentsOfURL: NSURL(string: "http://school.robxert.com/hairspray/articleLoad.php?data=\(articleNumber)")!) as NSData!
        let readableJSON = JSON(data :jsonData, options: NSJSONReadingOptions.MutableContainers)
        
        if readableJSON == nil {
            print("shit")
        }
        
        articleTitle.text = readableJSON[0]["title"].stringValue
        let articleContentRaw = readableJSON[0]["content"].stringValue
        
        contentWebView.loadHTMLString(articleContentRaw, baseURL: nil)
        
        let img = readableJSON[0]["img"].stringValue
        
        let url = NSURL(string: "http://school.robxert.com/hairspray/admin/inc/img/\(img)")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        if (data != nil) {
             self.articleImg.hnk_setImageFromURL(url!, placeholder: UIImage(named: "placeholder1.png"), format: Format<UIImage>(name: "image"), failure: { (error) -> () in }) { (image) -> () in
                 self.articleImg.image = image
                self.articleImg.frame = CGRectMake(0,0,screenWidth, 200)
                self.articleImg.contentMode = .ScaleAspectFill
            }
        } else {
            NSLog("error")
        }
    }
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                
                print("Swiped right")
                
                //change view controllers
                
                let storyBoard : UIStoryboard = UIStoryboard(name: deviceFamily, bundle:nil)
                
                let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("home") as UIViewController
                
                self.presentViewController(resultViewController, animated:true, completion:nil)    


                
                
            default:
                break
            }
        }
    }
    
    
    
}

