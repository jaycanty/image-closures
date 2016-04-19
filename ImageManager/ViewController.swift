//
//  ViewController.swift
//  ImageManager
//
//  Created by Jay Canty on 4/18/16.
//  Copyright © 2016 Jay Canty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let data: [String] = [
        "http://im.snibgo.com/fn_m2.jpg",
        "https://as.ftcdn.net/r/v1/pics/5569744154d0a37bfe332c51114f40775063815b/home/photoshop.jpg",
        "http://images.freeimages.com/images/previews/6d7/atlantis-waterslide-1523874.jpg",
        "http://images.freeimages.com/images/previews/2bb/autumn-1564066.jpg",
        "http://images.freeimages.com/images/previews/0f8/autumn-1564059.jpg",
        "http://images.freeimages.com/images/previews/ebb/autumn-1564065.jpg"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension ViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell") as? TableViewCell {
            
            cell.data = data[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
}