//
//  NotifyUserViewController.swift
//  BillBoard
//
//  Created by Mahesh Babu  on 01/03/16.
//  Copyright © 2016 MacBook Pro. All rights reserved.
//

import UIKit

class NotifyUserViewController: UIViewController {
    
    var username = "kak1@kak.com"
    var password = "1234"
    var deviceToken:AnyObject = ""
    
    @IBOutlet weak var getNotificationButton: UIButton!
   
    @IBOutlet weak var activityIdentify: UIActivityIndicatorView!
    
    @IBAction func notifyUserButton(sender: UIButton) {
        print("Notification process started.....")
        self.getNotificationButton.enabled = false
        self.activityIdentify.hidden = false
        notifyUserSECall()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIdentify.hidden = true
        
        // Do any additional setup after loading the view.
        
        //checkingLoginAuthentication()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func checkingLoginAuthentication() {
        
        print("Auto logged Successfully ")
        
        do {
            
            try KiiUser.authenticateSynchronous(username, withPassword: password)
            
            // Creating user variable in other scene by globally
            
            deviceToken = NSUserDefaults.standardUserDefaults().objectForKey("devicetoken")!
            
            print("Get-token: \(deviceToken)")
            
            try KiiPushInstallation.installSynchronousWithDeviceToken(deviceToken as! NSData, andDevelopmentMode: true)
            
            print("pushInstallation-token: \(deviceToken)")
            
        } catch{
            print("Dim background error")
        }
        
    }
    
    func notifyUserAPICall(){
        print("notification API call started....")
        //Resr POST API - STARTS//
        let postsEndpoint: String = "https://api.kii.com/api/apps/2ffeb59c/server-code/versions/current/notifyUser"
        
        guard let postsURL = NSURL(string: postsEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        
        let postsUrlRequest = NSMutableURLRequest(URL: postsURL)
        
        let postHeaders: NSDictionary = ["Authorization": "Bearer bPKKE0cM2WTV8gtpf0nTisshguaB6r6ogskEHYoWFPc",
            "X-Kii-AppID": "2ffeb59c",
            "X-Kii-AppKey": "4a1ea3db6e13e83b6c3e54b48374f42c"]
        
        postsUrlRequest.allHTTPHeaderFields = (postHeaders as! [String : String])
        
        postsUrlRequest.HTTPMethod = "POST"
        
        let postString = "mailId=\(username)"
        
        postsUrlRequest.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let postTask = NSURLSession.sharedSession().dataTaskWithRequest(postsUrlRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            print("Please Call NotifyUSer")
            /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("billBoard") as! BillBoardViewController
            self.presentViewController(vc, animated: true, completion: nil)*/
            
        }
        postTask.resume()
        //Rest POST API - ENDS//
    }
    
    func notifyUserSECall(){
        print("notification SE call started....")
        do {
            // Instantiate with the endpoint.
            let entry: KiiServerCodeEntry = Kii.serverCodeEntry("notifyUser")
            
            // Set the custom parameters.
            let argDict: NSDictionary = [
                "mailId" : username
            ]
            let argument = KiiServerCodeEntryArgument(dictionary: argDict as [NSObject : AnyObject])
            
            // Execute the server code
            let result: KiiServerCodeExecResult = try entry.executeSynchronous(argument)
            
            
            // Parse the result
            let returnedDict: NSDictionary = result.returnedValue()
            
            let message: AnyObject = returnedDict.objectForKey("returnedValue")!
            
            let response: AnyObject = message.objectForKey("response") as! String
            let responseMessage = message.objectForKey("Message") as! String
            print("response Text : \(response)")
            print("responseMessage Text : \(responseMessage)")
            
            
        } catch let error as NSError{
            let alert = UIAlertController(title: "Warning", message: error.userInfo.description, preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
            }
            
            alert.addAction(okAction)
            self.activityIdentify.hidden = true
            self.getNotificationButton.enabled = true
            
        } catch {
            print("Exception while calling server code")
        }
        
    }

}
