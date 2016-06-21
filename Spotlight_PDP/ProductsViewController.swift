//
//  ViewController.swift
//  Spotlight_PDP
//
//  Created by Aynur Galiev on 14.06.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

func UI_THREAD(UI_BLOCK: (()->())) {
    dispatch_async(dispatch_get_main_queue(), UI_BLOCK)
}

class ProductsViewController: UIViewController {

    private var products: [String] = ["concentrates", "edibles", "flower default", "gear", "hybrid", "indica", "pre-rolls", "sativa", "seeds", "tincture", "topicals"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 101
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsetsZero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addProductToIndex(indexPath: NSIndexPath) {
        
        guard CSSearchableIndex.isIndexingAvailable() else {
            let alert = UIAlertController(title: "Core Spotlight Error", message: "Searching is not available on this device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let product = self.products[indexPath.row]
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeAudio as String)
        attributes.thumbnailData = UIImageJPEGRepresentation(UIImage(named: product)!, 0.5)
        attributes.rating = 3
        attributes.ratingDescription = "Some Description"
        attributes.duration = 5.0

        let item = CSSearchableItem(uniqueIdentifier: product, domainIdentifier: "com.flatstack.Favorited_products", attributeSet: attributes)
        attributes.title = product.capitalizedString
        attributes.contentDescription = "Description of \(product)"
        
        
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error: NSError?) in
        
            UI_THREAD {
                if let lError = error {
                    let alert = UIAlertController(title: "Core Spotlight Error", message: lError.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    
                }
            }
        }
    }
    
    func removeProductFromIndex(indexPath: NSIndexPath) {
        
        guard CSSearchableIndex.isIndexingAvailable() else {
            let alert = UIAlertController(title: "Core Spotlight Error", message: "Searching is not available on this device", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers([self.products[indexPath.row]], completionHandler: { (error: NSError?) in
            
            UI_THREAD {
                if let lError = error {
                    let alert = UIAlertController(title: "Core Spotlight Error", message: lError.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Destructive, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    
                }
            }
        })
    }
    
    override func updateUserActivityState(activity: NSUserActivity) {
        
    }
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        guard let searchItem = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
            return
        }
        guard let index = self.products.indexOf(searchItem) else { return }
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
        
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.duration = 1.2
        animation.autoreverses = true
        animation.fromValue = UIColor.whiteColor().CGColor
        animation.toValue = UIColor.redColor().colorWithAlphaComponent(0.6).CGColor
        animation.removedOnCompletion = true
        cell?.contentView.layer.addAnimation(animation, forKey: "backgroundColor")
    }
}

extension ProductsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell") as! ProductCell
        cell.imageView?.image = UIImage(named: self.products[indexPath.row])
        cell.nameLabel.text = self.products[indexPath.row]
        return cell
    }
}

extension ProductsViewController: UITableViewDelegate {

    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let likeAction = UITableViewRowAction(style: .Normal, title: "Like") { (action: UITableViewRowAction, indexPath: NSIndexPath) in
            self.tableView.setEditing(false, animated: true)
            self.addProductToIndex(indexPath)
        }
        likeAction.backgroundColor = UIColor.greenColor()
        
        let dislikeAction = UITableViewRowAction(style: .Normal, title: "Dislike") { (action: UITableViewRowAction, indexPath: NSIndexPath) in
            self.tableView.setEditing(false, animated: true)
            self.removeProductFromIndex(indexPath)
        }
        dislikeAction.backgroundColor = UIColor.redColor()
        return [likeAction, dislikeAction]
    }
}