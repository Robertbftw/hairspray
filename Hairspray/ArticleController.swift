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
import Alamofire

var deviceFamily = NSUserDefaults.standardUserDefaults().objectForKey("deviceFamily") as! String

class ArticleController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        let headerBarAbove = UIImageView()
        let headerBar = UINavigationBar()
        let headerLogo = UIImageView()
        let headerBackBtn = UIButton()
        
        headerBarAbove.image = UIImage(named: "white")
        headerBarAbove.frame = CGRectMake(0, 0, screenWidth, 20)
        
        headerBar.frame = CGRectMake(0, 20, screenWidth, 44)
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        
        headerLogo.image = UIImage(named: "logo-hairspray")
        headerLogo.frame = CGRectMake(0, 30, screenWidth, 24)
        headerLogo.contentMode = .ScaleAspectFit
        headerLogo.layer.masksToBounds = true
        
        let buttonImage = UIImage(named: "round-left-button") as UIImage?
        headerBackBtn.contentMode = .ScaleAspectFit
        headerBackBtn.setImage(buttonImage, forState: .Normal)
        headerBackBtn.frame = CGRectMake(7, 27, 33, 33)
        
        headerBackBtn.addTarget(self, action: "goBack:", forControlEvents:.TouchUpInside)
    
        self.view.addSubview(headerBarAbove)
        self.view.addSubview(headerBar)
        self.view.addSubview(headerLogo)
        self.view.addSubview(headerBackBtn)
        
        
        
        let artNum = NSUserDefaults.standardUserDefaults().integerForKey("ArticleNumber")
        getArticle(artNum)
        
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
        var isError = Bool()
        let url = "http://school.robxert.com/hairspray/articleLoad.php?data=\(articleNumber)"
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
                
                let standardMarginTop = CGFloat(64)
                
                if isError == false {
                    responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let readableJSON = JSON(data :responseJSON, options: NSJSONReadingOptions.MutableContainers)
                    
                    let articleContentRaw = readableJSON[0]["content"].stringValue
                    let title = readableJSON[0]["title"].stringValue
                    let image = readableJSON[0]["img"].stringValue
                    
                    let url = NSURL(string: "http://school.robxert.com/hairspray/admin/inc/img/\(image)")
                    let data = NSData(contentsOfURL: url!)
                    
                    let articleImage = UIImageView()
                    let articleTitle = UILabel()
                    let articleContentView = UIWebView()
                    let titleBlur = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
                    
                    if (data != nil) {
                        articleImage.hnk_setImageFromURL(url!, placeholder: UIImage(named: "placeholder1.png"), format: Format<UIImage>(name: "image"), failure: { (error) -> () in }) { (image) -> () in
                            articleImage.image = image
                        }
                    } else {
                        articleImage.image = UIImage(named: "placeholder1.png")
                    }
                    articleImage.frame = CGRectMake(0, (0 + standardMarginTop), screenWidth, 200)
                    articleImage.contentMode = .ScaleAspectFill
                    articleImage.layer.masksToBounds = true
                    
                    titleBlur.frame = CGRectMake(0, (160 + standardMarginTop), (screenWidth), 40)
                    
                    articleTitle.text = title
                    articleTitle.frame = CGRectMake(0, (160 + standardMarginTop), screenWidth, 40)
                    articleTitle.textColor = UIColor(hexString: "#FFFFFF")
                    articleTitle.font = UIFont(name: "GurmukhiMN", size: 18)
                    articleTitle.textAlignment = .Center
                    
                    articleContentView.loadHTMLString(articleContentRaw, baseURL: nil)
                    
                    articleContentView.frame.origin.x = 10
                    articleContentView.frame.origin.y = (200 + standardMarginTop)
                    articleContentView.frame.size.width = (screenWidth - 20)
                    articleContentView.frame.size.height = (800)
//                    articleContentView.frame = CGRectMake(10, (200 + standardMarginTop), (screenWidth - 20), (800 - standardMarginTop))

                    self.scrollView.addSubview(articleImage)
                    self.scrollView.addSubview(titleBlur)
                    self.scrollView.addSubview(articleTitle)
                    self.scrollView.addSubview(articleContentView)
                    
                    self.scrollView.contentSize.height = (800 + 70 + 200 + standardMarginTop + 50)
                    
                    
                }
        }
    }
    
    func goBack(sender:UIButton!) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                
                print("Swiped right")
                
                //change view controllers
                
                self.dismissViewControllerAnimated(true, completion: {})
                
            default:
                break
            }
        }
    }
    
    
    
}

