//
//  WoboTableViewController.swift
//  WoboStaff
//
//  Created by Alessandro on 12/31/15.
//  Copyright © 2016 Alessandro Belardinelli. All rights reserved.
//

import UIKit
import SystemConfiguration

class WoboTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Private structs
    
    private struct WoboTimeZone
    {
        let timezone: String
        let usersInThisTimezone: [WoboUser]
    }
    
    private struct Constants
    {
        static let woboUsersCellIdentifiers = "WoboUserCell"
        static let dateFormatToSort = "yyyy-MM-dd HH:mm:ss"
        static let dateFormatToDisplay = "M/d/y EEE h:mm:ss a"
        static let headerColor = UIColor(red: 0.4275, green: 0.6392, blue: 0.7765, alpha: 1.0)
        static let headerHeight: CGFloat = 50
        static let headerFontSize: CGFloat = 15
        static let oddRowsColor = UIColor.lightGrayColor()
        static let evenRowsColor = UIColor.whiteColor()
        static let alertCriticalLevel = "Critical"
        static let alertNormalLevel = "Normal"
        static let alertNoDataTitle = "Can't load any data!"
        static let alertNoDataMessage = "Please check your internet connection and try again."
        static let alertButtonNoDataTitle = "Retry"
        static let alertNoConnectionTitle = "Network is not reachable"
        static let alertNoConnectionMessage = "Will try to load data from the cache."
        static let alertButtonNoConnectionTitle = "Continue"
        static let alertNoUsersTitle = "No users found!"
        static let alertNoUsersMessage = "The current search does not match any result."
        static let alertButtonNoUsersTitle = "Reload"
        static let defaultUserStatus = "Offline"
        static let noNetworkUserStatus = "Unknown (network not available)"
    }
    
    // MARK: - Private variables
    
    private var WoboUsers: [WoboUser] = []
    private var uniqueTimes: [String] = []
    private var activeWoboTimezones: [WoboTimeZone] = []
    private var networkIsAvailable = false
    private var searchText: String?
    private var data: JSON?
    
    private let hipChatRequest: HipChatRequest = HipChatRequest()
    
    // MARK: - Private functions
    
    private func reloadData (data: JSON?, filterText: String?)
    {
        if data != nil {
            parseJson(data!, filterText: searchText)
            tableView.reloadData()
        }
        else {
            createAlert(Constants.alertNoDataTitle, alertMessage: Constants.alertNoDataMessage, alertStyle: .Alert, buttonTitle: Constants.alertButtonNoDataTitle, alertType: Constants.alertCriticalLevel)
        }
    }
    
    private func createAlert (alertTitle: String, alertMessage: String, alertStyle: UIAlertControllerStyle, buttonTitle: String, alertType: String)
    {
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: alertStyle)
        if alertType == Constants.alertCriticalLevel {
            alertView.addAction(UIAlertAction(title: buttonTitle, style: .Default)
                { action -> Void in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.refresh()
                    })
                    
                })
        }
        else {
            alertView.addAction(UIAlertAction(title: buttonTitle, style: .Default, handler: nil))
        }
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func parseJson (jsonData: JSON, filterText: String?)
    {
        WoboUsers.removeAll()
        uniqueTimes.removeAll()
        activeWoboTimezones.removeAll()
        let myJson = jsonData
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatToSort
        
        for (_,subJson):(String, JSON) in myJson["items"] {
            if userPassesFilter(subJson["name"].string!, currentFilter: searchText) {
                dateFormatter.timeZone = NSTimeZone(name: subJson["timezone"].string!)
                let thisFormattedTime = dateFormatter.stringFromDate(date)
                var thisUserStatus = Constants.defaultUserStatus
                if networkIsAvailable {
                    if subJson["presence"]["show"] != nil {
                        thisUserStatus = hipChatRequest.getUserStatus(subJson["presence"]["show"].string!)
                    }
                }
                else {
                    thisUserStatus = Constants.noNetworkUserStatus
                }
                let thisUser = WoboUser()
                thisUser.name = subJson["name"].string!
                thisUser.title = subJson["title"].string!
                thisUser.imgUrl = subJson["photo_url"].string!
                thisUser.localFormattedTime = thisFormattedTime
                thisUser.onlineStatus = thisUserStatus
                WoboUsers.append(thisUser)
                if !uniqueTimes.contains(thisFormattedTime) {
                    uniqueTimes.append(thisFormattedTime)
                }
            }
        }
        
        if uniqueTimes.isEmpty {
            createAlert(Constants.alertNoUsersTitle, alertMessage: Constants.alertNoUsersMessage, alertStyle: .Alert, buttonTitle: Constants.alertButtonNoUsersTitle, alertType: Constants.alertCriticalLevel)
        }
        else {
            uniqueTimes.sortInPlace({ $0 < $1 })
            WoboUsers.sortInPlace({ $0.name < $1.name })
        
            for thisTime in uniqueTimes
            {
                let filteredWoboUsersArray = WoboUsers.filter{$0.localFormattedTime == thisTime}
                let thisActiveWoboTimeZone = WoboTimeZone(timezone: thisTime, usersInThisTimezone: filteredWoboUsersArray)
                activeWoboTimezones.append(thisActiveWoboTimeZone)
            }
        }
    }
    
    private func userPassesFilter (jsonUser: String, currentFilter: String?) -> Bool
    {
        if currentFilter == nil {
            return true
        }
        else {
            if currentFilter! == "" || jsonUser.lowercaseString.containsString(currentFilter!.lowercaseString) {
                return true
            }
        }
        return false
    }
    
    private func connectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
    
    private func refresh()
    {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    // MARK: - Search text field
    
    @IBOutlet weak var searchTextField: UITextField!
    {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
            reloadData(data, filterText: searchText)
        }
        return true
    }
    
    // MARK: - Refresh control
    
    @IBAction private func refresh(sender: UIRefreshControl?)
    {
        searchTextField?.text = nil
        searchText = nil
        networkIsAvailable = connectedToNetwork()
        if networkIsAvailable {
            hipChatRequest.fetchAndSaveUsers()
        }
        else {
            createAlert(Constants.alertNoConnectionTitle, alertMessage: Constants.alertNoConnectionMessage, alertStyle: .Alert, buttonTitle: Constants.alertButtonNoConnectionTitle, alertType: Constants.alertNormalLevel)
        }
        data = hipChatRequest.readUsersFromFile()
        reloadData(data, filterText: searchText)
        sender?.endRefreshing()
    }
    
    // MARK: - View lifecycle
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.navigationItem.title = "Wobo Staff"
        refresh()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return activeWoboTimezones.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return activeWoboTimezones[section].usersInThisTimezone.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.woboUsersCellIdentifiers, forIndexPath: indexPath) as! WoboTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Constants.oddRowsColor
        } else {
            cell.backgroundColor = Constants.evenRowsColor
        }
        
        cell.thisUser = activeWoboTimezones[indexPath.section].usersInThisTimezone[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return Constants.headerHeight
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let title: UILabel = UILabel()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatToSort
        let thisTitle = dateFormatter.dateFromString(activeWoboTimezones[section].timezone)
        dateFormatter.dateFormat = Constants.dateFormatToDisplay
        let thisFormattedTime = dateFormatter.stringFromDate(thisTitle!)
        
        title.text = "Local Time: " + thisFormattedTime
        title.textAlignment = NSTextAlignment.Center
        title.backgroundColor = Constants.headerColor
        title.font = UIFont.boldSystemFontOfSize(Constants.headerFontSize)
        
        return title
    }
    
}