//
//  voteController.swift
//  Hairspray
//
//  Created by Robert Boerema on 2/15/16.
//  Copyright © 2016 Robert Boerema. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftHEXColors
import Haneke

class voteController: UIViewController {
    
    @IBOutlet var voteBtns: [UIButton]!
    
    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        
        //New
        
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
       
        switch deviceCode{
        case 4:
            mainScreen5()
            results5()
        case 5:
            mainScreen5()
            results5()
        case 6:
            mainScreen6()
            results6()
        case 7:
            results6p()
            mainScreen6p()
        default:
            mainScreen5()
        }
       
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        //Old
        
        if NSUserDefaults.standardUserDefaults().objectForKey("voteDone") != nil {
//            resultsScreen()
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func vote(person: Int){
        Alamofire.request(.POST, "http://school.robxert.com/hairspray/vote.php", parameters: ["data": person])
            .responseData { response in
                
                switch response.result {
                case .Success:
                    NSUserDefaults.standardUserDefaults().setObject("done", forKey: "voteDone")
                    self.successfullVote(person)
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    func successfullVote(person: Int) {
        
        UIView.animateWithDuration(0.3) {
            self.voteBtns[0].alpha = 0
            self.voteBtns[1].alpha = 0
            self.voteBtns[2].alpha = 0
            self.voteBtns[3].alpha = 0
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(person, forKey: "votedForPerson")
    }
    
    func results5() {
        var isError = Bool()
        let url = "http://school.robxert.com/hairspray/getVotesNew.php"
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
                var marginTop = CGFloat(30)
                let screenWidthHalf = CGFloat((screenWidth / 2))
                var extraMarginBorder = CGFloat(0)
                
                var imageXPos = CGFloat((screenWidthHalf / 4))
                var imageYPos = CGFloat(20 + standardMarginTop)
                
                var labelXPos = CGFloat(0)
                var labelYPos = CGFloat(155)
                
                if isError == false {
                    responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let readableJSON = JSON(data: responseJSON, options: NSJSONReadingOptions.MutableContainers)
                    
                    let amount = readableJSON.arrayValue
                    //                    print(amount.count)
                    
                    for (var i = 0; i < amount.count; i += 1){
                        
                        
                        let borderDown = UIImageView()
                        let borderMiddle = UIImageView()
                        let votesLabel = UILabel()
                        
                        
                        
                        borderDown.image = UIImage(named: "pink-box")
                        borderDown.frame = CGRectMake(0, (screenWidthHalf + standardMarginTop + extraMarginBorder), screenWidth, 2)
                        
                        borderMiddle.image = UIImage(named: "pink-box")
                        borderMiddle.frame = CGRectMake((screenWidthHalf - 1), (standardMarginTop + extraMarginBorder), 2, screenWidthHalf)
                        
                        
                        
                        votesLabel.text = "\(readableJSON[i].stringValue)% van de stemmen"
                        votesLabel.frame = CGRectMake(labelXPos, labelYPos, screenWidthHalf, 20)
                        votesLabel.textAlignment = .Center
                        votesLabel.font = UIFont(name: "GurmukhiMN", size: 14)
                        votesLabel.textColor = UIColor(hexString: "#CB99C9")
                        
                        self.scrollView.addSubview(borderDown)
                        self.scrollView.addSubview(borderMiddle)
                        self.scrollView.addSubview(votesLabel)
                        
                        extraMarginBorder = screenWidthHalf + extraMarginBorder
                        
                        if (i % 2) == 0{
                            labelXPos = screenWidthHalf
                            
                            
                        } else {
                            labelXPos = 0
                            labelYPos = labelYPos + 165
                            
                            
                        }
                        
                        
                        self.scrollView.contentSize.height = CGFloat(Int((screenWidth / 2)) * (amount.count / 2) + 64)
                    }
                    
                }
        }
        
    }
    
    func mainScreen5(){
        var isError = Bool()
        let url = "http://school.robxert.com/hairspray/candidatesInfo.php"
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
                let screenWidthHalf = CGFloat((screenWidth / 2))
                
                var imageXPos = CGFloat((screenWidthHalf / 4))
                var imageYPos = CGFloat(10 + standardMarginTop)
                
                var labelXPos = CGFloat(0)
                var labelYPos = CGFloat(175)
                
                if isError == false {
                    responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let readableJSON = JSON(data: responseJSON, options: NSJSONReadingOptions.MutableContainers)
                    
                    let amount = readableJSON.arrayValue
                    
                    for (var i = 0; i < amount.count; i += 1){
                        
                        let personName = UILabel()
                        let personIMG = UIImageView()
                        
                        personName.text = readableJSON[i]["name"].stringValue
                        personName.frame = CGRectMake(labelXPos, labelYPos, screenWidthHalf, 20)
                        personName.textAlignment = .Center
                        personName.textColor = UIColor(hexString: "#779ECB")
                        personName.font = UIFont(name: "GurmukhiMN", size: 14)
                        
                        let imgJSON = readableJSON[i]["img"].stringValue
                        
                        let url = NSURL(string: "http://school.robxert.com/hairspray/admin/inc/img/\(imgJSON)")
                        let data = NSData(contentsOfURL: url!)
                        
                        if (data != nil) {
                            personIMG.hnk_setImageFromURL(url!, placeholder: UIImage(named: "placeholder1.png"), format: Format<UIImage>(name: "image"), failure: { (error) -> () in }) { (image) -> () in
                                personIMG.image = image
                            }
                        } else {
                            personIMG.image = UIImage(named: "placeholder1.png")
                        }
                        personIMG.frame = CGRectMake(imageXPos, imageYPos, (screenWidthHalf / 2), (screenWidthHalf / 2))
                        personIMG.contentMode = .ScaleAspectFill
                        personIMG.layer.borderWidth=2.0
                        personIMG.layer.masksToBounds = false
                        personIMG.layer.borderColor = UIColor(hexString: "#779ECB")!.CGColor
                        personIMG.layer.cornerRadius = personIMG.frame.size.height/2
                        personIMG.clipsToBounds = true
                        
                        self.scrollView.addSubview(personIMG)
                        self.scrollView.addSubview(personName)
                        
                        if (i % 2) == 0{
                            imageXPos = ((screenWidthHalf / 4) + screenWidthHalf)
                            
                            labelXPos = screenWidthHalf
                            
                        } else {
                            imageYPos = CGFloat(imageYPos + 160)
                            imageXPos = (screenWidthHalf / 4)
                            
                            labelXPos = 0
                            labelYPos = labelYPos + 165
                        }
                        
                    }
                }
        }
    }
    
    func results6() {
        var isError = Bool()
        let url = "http://school.robxert.com/hairspray/getVotesNew.php"
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
                var marginTop = CGFloat(30)
                let screenWidthHalf = CGFloat((screenWidth / 2))
                var extraMarginBorder = CGFloat(0)
                
                var imageXPos = CGFloat((screenWidthHalf / 4))
                var imageYPos = CGFloat(20 + standardMarginTop)
            
                var labelXPos = CGFloat(0)
                var labelYPos = CGFloat(185)
                
                if isError == false {
                    responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let readableJSON = JSON(data: responseJSON, options: NSJSONReadingOptions.MutableContainers)
                    
                    let amount = readableJSON.arrayValue
//                    print(amount.count)
                    
                    for (var i = 0; i < amount.count; i += 1){
                        
                        
                        let borderDown = UIImageView()
                        let borderMiddle = UIImageView()
                        let votesLabel = UILabel()
                        
                        
                        
                        borderDown.image = UIImage(named: "pink-box")
                        borderDown.frame = CGRectMake(0, (screenWidthHalf + standardMarginTop + extraMarginBorder), screenWidth, 2)
                        
                        borderMiddle.image = UIImage(named: "pink-box")
                        borderMiddle.frame = CGRectMake((screenWidthHalf - 1), (standardMarginTop + extraMarginBorder), 2, screenWidthHalf)
                        

                        
                        votesLabel.text = "\(readableJSON[i].stringValue)% van de stemmen"
                        votesLabel.frame = CGRectMake(labelXPos, labelYPos, screenWidthHalf, 20)
                        votesLabel.textAlignment = .Center
                        votesLabel.font = UIFont(name: "GurmukhiMN", size: 17)
                        votesLabel.textColor = UIColor(hexString: "#CB99C9")
                        
                        self.scrollView.addSubview(borderDown)
                        self.scrollView.addSubview(borderMiddle)
                        self.scrollView.addSubview(votesLabel)
                        
                        extraMarginBorder = screenWidthHalf + extraMarginBorder
                        
                        if (i % 2) == 0{
                            labelXPos = screenWidthHalf
                            
                            
                        } else {
                            labelXPos = 0
                            labelYPos = labelYPos + 190
                            
                            
                        }
                        
                                                
                        self.scrollView.contentSize.height = CGFloat(Int((screenWidth / 2)) * (amount.count / 2) + 64)
                    }
                    
                }
        }
    
    }
    
    func mainScreen6(){
        var isError = Bool()
        let url = "http://school.robxert.com/hairspray/candidatesInfo.php"
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
                let screenWidthHalf = CGFloat((screenWidth / 2))
                
                var imageXPos = CGFloat((screenWidthHalf / 4))
                var imageYPos = CGFloat(20 + standardMarginTop)
                
                var labelXPos = CGFloat(0)
                var labelYPos = CGFloat(210)
                
                if isError == false {
                    responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let readableJSON = JSON(data: responseJSON, options: NSJSONReadingOptions.MutableContainers)
                    
                    let amount = readableJSON.arrayValue
                    
                    for (var i = 0; i < amount.count; i += 1){
                        
                        let personName = UILabel()
                        let personIMG = UIImageView()
                        
                        personName.text = readableJSON[i]["name"].stringValue
                        personName.frame = CGRectMake(labelXPos, labelYPos, screenWidthHalf, 20)
                        personName.textAlignment = .Center
                        personName.textColor = UIColor(hexString: "#779ECB")
                        personName.font = UIFont(name: "GurmukhiMN", size: 17)
                        
                        let imgJSON = readableJSON[i]["img"].stringValue
                        
                        let url = NSURL(string: "http://school.robxert.com/hairspray/admin/inc/img/\(imgJSON)")
                        let data = NSData(contentsOfURL: url!)
                        
                        if (data != nil) {
                            personIMG.hnk_setImageFromURL(url!, placeholder: UIImage(named: "placeholder1.png"), format: Format<UIImage>(name: "image"), failure: { (error) -> () in }) { (image) -> () in
                                personIMG.image = image
                            }
                        } else {
                            personIMG.image = UIImage(named: "placeholder1.png")
                        }
                        personIMG.frame = CGRectMake(imageXPos, imageYPos, (screenWidthHalf / 2), (screenWidthHalf / 2))
                        personIMG.contentMode = .ScaleAspectFill
                        personIMG.layer.borderWidth=2.0
                        personIMG.layer.masksToBounds = false
                        personIMG.layer.borderColor = UIColor(hexString: "#779ECB")!.CGColor
                        personIMG.layer.cornerRadius = personIMG.frame.size.height/2
                        personIMG.clipsToBounds = true
                        
                        self.scrollView.addSubview(personIMG)
                        self.scrollView.addSubview(personName)
                        
                        if (i % 2) == 0{
                            imageXPos = ((screenWidthHalf / 4) + screenWidthHalf)
                            
                            labelXPos = screenWidthHalf
                            
                        } else {
                            imageYPos = CGFloat(imageYPos + 190)
                            imageXPos = (screenWidthHalf / 4)
                            
                            labelXPos = 0
                            labelYPos = labelYPos + 190
                        }

                    }
                }
        }
    }
    
    func results6p() {
        var isError = Bool()
        let url = "http://school.robxert.com/hairspray/getVotesNew.php"
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
                var marginTop = CGFloat(30)
                let screenWidthHalf = CGFloat((screenWidth / 2))
                var extraMarginBorder = CGFloat(0)
                
                var imageXPos = CGFloat((screenWidthHalf / 4))
                var imageYPos = CGFloat(20 + standardMarginTop)
                
                var labelXPos = CGFloat(0)
                var labelYPos = CGFloat(190)
                
                if isError == false {
                    responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let readableJSON = JSON(data: responseJSON, options: NSJSONReadingOptions.MutableContainers)
                    
                    let amount = readableJSON.arrayValue
                    //                    print(amount.count)
                    
                    for (var i = 0; i < amount.count; i += 1){
                        
                        
                        let borderDown = UIImageView()
                        let borderMiddle = UIImageView()
                        let votesLabel = UILabel()
                        
                        
                        
                        borderDown.image = UIImage(named: "pink-box")
                        borderDown.frame = CGRectMake(0, (screenWidthHalf + standardMarginTop + extraMarginBorder), screenWidth, 2)
                        
                        borderMiddle.image = UIImage(named: "pink-box")
                        borderMiddle.frame = CGRectMake((screenWidthHalf - 1), (standardMarginTop + extraMarginBorder), 2, screenWidthHalf)
                        
                        
                        
                        votesLabel.text = "\(readableJSON[i].stringValue)% van de stemmen"
                        votesLabel.frame = CGRectMake(labelXPos, labelYPos, screenWidthHalf, 20)
                        votesLabel.textAlignment = .Center
                        votesLabel.font = UIFont(name: "GurmukhiMN", size: 17)
                        votesLabel.textColor = UIColor(hexString: "#CB99C9")
                        
                        self.scrollView.addSubview(borderDown)
                        self.scrollView.addSubview(borderMiddle)
                        self.scrollView.addSubview(votesLabel)
                        
                        extraMarginBorder = screenWidthHalf + extraMarginBorder
                        
                        if (i % 2) == 0{
                            labelXPos = screenWidthHalf
                            
                            
                        } else {
                            labelXPos = 0
                            labelYPos = labelYPos + 205
                        }
                        
                        
                        self.scrollView.contentSize.height = CGFloat(Int((screenWidth / 2)) * (amount.count / 2) + 64)
                    }
                    
                }
        }
        
    }
    
    func mainScreen6p(){
        var isError = Bool()
        let url = "http://school.robxert.com/hairspray/candidatesInfo.php"
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
                let screenWidthHalf = CGFloat((screenWidth / 2))
                
                var imageXPos = CGFloat((screenWidthHalf / 4))
                var imageYPos = CGFloat(20 + standardMarginTop)
                
                var labelXPos = CGFloat(0)
                var labelYPos = CGFloat(215)
                
                if isError == false {
                    responseJSON = response.result.value!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let readableJSON = JSON(data: responseJSON, options: NSJSONReadingOptions.MutableContainers)
                    
                    let amount = readableJSON.arrayValue
                    
                    for (var i = 0; i < amount.count; i += 1){
                        
                        let personName = UILabel()
                        let personIMG = UIImageView()
                        
                        personName.text = readableJSON[i]["name"].stringValue
                        personName.frame = CGRectMake(labelXPos, labelYPos, screenWidthHalf, 20)
                        personName.textAlignment = .Center
                        personName.textColor = UIColor(hexString: "#779ECB")
                        personName.font = UIFont(name: "GurmukhiMN", size: 17)
                        
                        let imgJSON = readableJSON[i]["img"].stringValue
                        
                        let url = NSURL(string: "http://school.robxert.com/hairspray/admin/inc/img/\(imgJSON)")
                        let data = NSData(contentsOfURL: url!)
                        
                        if (data != nil) {
                            personIMG.hnk_setImageFromURL(url!, placeholder: UIImage(named: "placeholder1.png"), format: Format<UIImage>(name: "image"), failure: { (error) -> () in }) { (image) -> () in
                                personIMG.image = image
                            }
                        } else {
                            personIMG.image = UIImage(named: "placeholder1.png")
                        }
                        personIMG.frame = CGRectMake(imageXPos, imageYPos, (screenWidthHalf / 2), (screenWidthHalf / 2))
                        personIMG.contentMode = .ScaleAspectFill
                        personIMG.layer.borderWidth=2.0
                        personIMG.layer.masksToBounds = false
                        personIMG.layer.borderColor = UIColor(hexString: "#779ECB")!.CGColor
                        personIMG.layer.cornerRadius = personIMG.frame.size.height/2
                        personIMG.clipsToBounds = true
                        
                        self.scrollView.addSubview(personIMG)
                        self.scrollView.addSubview(personName)
                        
                        if (i % 2) == 0{
                            imageXPos = ((screenWidthHalf / 4) + screenWidthHalf)
                            
                            labelXPos = screenWidthHalf
                            
                        } else {
                            imageYPos = CGFloat(imageYPos + 205)
                            imageXPos = (screenWidthHalf / 4)
                            
                            labelXPos = 0
                            labelYPos = labelYPos + 205

                        }
                        
                    }
                }
        }
    }
    
    func resultsScreen(){
        
        let vote = NSUserDefaults.standardUserDefaults().integerForKey("votedForPerson")
        print("hoi")
        
        voteBtns[0].hidden = true
        voteBtns[1].hidden = true
        voteBtns[2].hidden = true
        voteBtns[3].hidden = true
        
        
    }
    
    func goBack(sender:UIButton!) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    @IBAction func voteBtn1(sender: AnyObject) {
        vote(1)
    }
    @IBAction func voteBtn2(sender: AnyObject) {
        vote(2)
    }
    @IBAction func voteBtn3(sender: AnyObject) {
        vote(3)
    }
    @IBAction func voteBtn4(sender: AnyObject) {
        vote(4)
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


