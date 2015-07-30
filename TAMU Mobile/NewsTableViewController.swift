//
//  NewsTableViewController.swift
//  TAMU Mobile
//
//  Created by Mike Choi on 7/27/15.
//  Copyright (c) 2015 coolaf. All rights reserved.
//

import Foundation
import SDWebImage
//http://www.12thman.com/rss.aspx

class NewsTableViewController: UITableViewController, XMLParserDelegate {
    
    var xmlParser : XMLParser!
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "http://www.12thman.com/rss.aspx")
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url!)
    }
    
    // MARK: XMLParserDelegate method implementation
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return xmlParser.arrParsedData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewsTableViewCell
        cell.shareButton.addTarget(self, action: "shareArticle:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let currentDictionary = xmlParser.arrParsedData[indexPath.section] as Dictionary<String, String>
        
        cell.titleLabel.text = currentDictionary["title"]
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) -> Void in
        }
        
        if let urlString = currentDictionary["description"]{
            cell.newsImage.sd_setImageWithURL(validURLAddress(urlString), completed: block)
        }
        if let date = currentDictionary["pubDate"]{
            cell.dateLabel.text = reformattedDate(date)
        }
        
        return cell
    }
    
    func shareArticle(sender : AnyObject){
        var cell = tableView.indexPathForRowAtPoint(sender.convertPoint(CGPointZero, toView: tableView))
        let dictionary = xmlParser.arrParsedData[cell!.section] as Dictionary<String, String>

        let url = dictionary["link"]!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let articleURL = NSURL(string: url)
        
        let shareText = "\nCheckout this article I found on the TAMU iOS mobile app by sick.af"
        let activityVC = UIActivityViewController(activityItems: [articleURL!, shareText], applicationActivities: nil)
        
        //New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePostToFlickr, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypePostToTencentWeibo]
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func reformattedDate(rssDate : String) -> String{
        //Fri, 24 Jul 2015 22:35:00 GMT
        dateFormatter.dateFormat = "eee, dd MMM yyyy HH:mm:ss zzz"
        let date = dateFormatter.dateFromString(rssDate)

        //Jul 24, 2015
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "MMM dd, YYYY"
 
        let dateString = dateFormatter.stringFromDate(date!)

        return dateString
    }
    
    func validURLAddress(htmlString : String) -> NSURL{
        var urlString = htmlString.stringByReplacingOccurrencesOfString("<img src=\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        //urlString = urlString.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        urlString = urlString.componentsSeparatedByString("\"").first!
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

        return NSURL(string: urlString)!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9.5
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var spacing = UIView()
        spacing.backgroundColor = UIColor(red: 80.0/255.0, green: 0, blue: 0, alpha: 1.0)
        return spacing
    }
    

}