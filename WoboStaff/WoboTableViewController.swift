//
//  WoboTableViewController.swift
//  WoboStaff
//
//  Created by Alessandro on 12/31/15.
//  Copyright © 2015 Alessandro Belardinelli. All rights reserved.
//

import UIKit

// MARK: - Public structs

struct WoboUser
{
    let name :String
    let title :String
    let imgUrl :String
    let localFormattedTime :String
}

class WoboTableViewController: UITableViewController {
    
    // MARK: - Private structs
    
    private struct WoboTimeZone
    {
        let timezone :String
        let usersInThisTimezone :[WoboUser]
    }
    
    private struct Constants
    {
        static let WoboUsersCellIdentifiers = "WoboUserCell"
        static let DateFormatToSort = "yyyy-MM-dd HH:mm:ss"
        static let DateFormatToDisplay = "M/d/y EEEE h:mm:ss a"
        static let HeaderColor = UIColor(red: 0.4275, green: 0.6392, blue: 0.7765, alpha: 1.0)
        static let HeaderHeight :CGFloat = 50
        static let HeaderFontSize :CGFloat = 15
        static let AlertTitle = "Can't load the data from the network!"
        static let AlertMessage = "Please check your internet connection and try again."
        static let ButtonTitle = "Retry"
    }
    
    // MARK: - Private variables
    
    private var WoboUsers :[WoboUser] = []
    private var uniqueTimes :[String] = []
    private var activeWoboTimezones :[WoboTimeZone] = []
    
    private let hipChatRequest :HipChatRequest = HipChatRequest()
    
    private var data :JSON?
    {
        didSet {
            if (data != nil) {
                //if it exists, it is a parsable json
                parseJson(data!)
                tableView.reloadData()
            }
            else {
                createAlert(Constants.AlertTitle, alertMessage: Constants.AlertMessage, buttonTitle: Constants.ButtonTitle)
            }
        }
    }
    
    // MARK: - Private functions
    
    private func createAlert (alertTitle :String, alertMessage :String, buttonTitle :String) {
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: buttonTitle, style: .Default)
            { action -> Void in
                self.refresh()
            })
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func parseJson (jsonData :JSON)
    {
        let myJson = jsonData
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = Constants.DateFormatToSort
        
        for (_,subJson):(String, JSON) in myJson["items"] {
            dateFormatter.timeZone = NSTimeZone(name: subJson["timezone"].string!)
            let thisFormattedTime = dateFormatter.stringFromDate(date)
            let thisUser = WoboUser(name: subJson["name"].string!, title: subJson["title"].string!, imgUrl: subJson["photo_url"].string!, localFormattedTime: thisFormattedTime)
            WoboUsers.append(thisUser)
            if uniqueTimes.contains(thisFormattedTime) == false {
                uniqueTimes.append(thisFormattedTime)
            }
        }
        
        uniqueTimes.sortInPlace({ $0 < $1 })
        WoboUsers.sortInPlace({ $0.name < $1.name })
        
        for thisTime in uniqueTimes
        {
            let filteredWoboUsersArray = WoboUsers.filter{$0.localFormattedTime == thisTime}
            let thisActiveWoboTimeZone = WoboTimeZone(timezone: thisTime, usersInThisTimezone: filteredWoboUsersArray)
            activeWoboTimezones.append(thisActiveWoboTimeZone)
        }
    }
    
    private func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction private func refresh(sender: UIRefreshControl?) {
        hipChatRequest.fetchAndSaveUsers()
        data = hipChatRequest.readUsersFromFile()
        sender?.endRefreshing()
    }
    
    // MARK: - View lifecycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.WoboUsersCellIdentifiers, forIndexPath: indexPath) as! WoboTableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.lightGrayColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        cell.thisUser = activeWoboTimezones[indexPath.section].usersInThisTimezone[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return Constants.HeaderHeight
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let title: UILabel = UILabel()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = Constants.DateFormatToSort
        let thisTitle = dateFormatter.dateFromString(activeWoboTimezones[section].timezone)
        dateFormatter.dateFormat = Constants.DateFormatToDisplay
        let thisFormattedTime = dateFormatter.stringFromDate(thisTitle!)
        
        title.text = "Time: " + thisFormattedTime
        title.backgroundColor = Constants.HeaderColor
        title.font = UIFont.boldSystemFontOfSize(Constants.HeaderFontSize)
        
        return title
    }
    
}