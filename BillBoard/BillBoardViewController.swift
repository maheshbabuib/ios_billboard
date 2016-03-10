//
//  BillBoardViewController.swift
//  BillBoard
//
//  Created by Mahesh Babu  on 03/03/16.
//  Copyright © 2016 MBPi513. All rights reserved.
//

import UIKit

class BillBoardViewController: UIViewController {

    var notificationBody:AnyObject?
    
    @IBOutlet weak var notificationLabel: UILabel!
   
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("BillBoardViewController startting.....")
        
        //Call getRandomColr function to change the view background
        self.getRandomColor()
        
        
        // Set the default Notification Message.
         if appDelegate.notificationBody != nil{
            notificationLabel.text = appDelegate.notificationBody
         } else {
            notificationLabel.text = "Message sent to billboard"
        }
        
        //Add the animation to NotificationLabel
        notificationLabel.alpha = 0
        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: .CurveEaseIn, animations: {
        self.notificationLabel.center = CGPoint(x: 200, y: 40)
        self.notificationLabel.alpha = 1 // Un-Hide
        }, completion: nil)
        self.notificationLabel.center = CGPoint(x: 200, y: 90 + 200)

        
        print("Notification Message is : \(appDelegate.notificationBody)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Change the Randomcolr of view background
    func getRandomColor() {
        
        print("Changing random color")
       
        var colorsArray = [
            UIColor.blackColor(),
            UIColor.whiteColor(),
            UIColor(red: 0/255.0, green: 153/255.0, blue: 76/255.0, alpha: 1.0),
            UIColor.cyanColor()
        ]
        
        //we are getting colrfalg value from appDelegate to change the colors
        let randomIndex = appDelegate.colorflag
        
        //print (randomIndex)
        
        self.view.backgroundColor = colorsArray[randomIndex]
        
        var colorDictionary = [0: UIColor.whiteColor(), 1: UIColor.blackColor(), 2:UIColor.whiteColor(),3:UIColor.blackColor()]
        
        self.notificationLabel.textColor = colorDictionary[randomIndex]
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
