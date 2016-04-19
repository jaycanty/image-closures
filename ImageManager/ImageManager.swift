//
//  ImageManager.swift
//  ImageManager
//
//  Created by Jay Canty on 4/18/16.
//  Copyright © 2016 Jay Canty. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ImageManager
{
    static let instance = ImageManager()
    
    func getResizerImage(url resizerURL: String, width: CGFloat, height: CGFloat, closure: ((image: UIImage?) -> ())?)
    {
        let scale = UIScreen.mainScreen().scale
        let url = resizerURL
            .stringByReplacingOccurrencesOfString("{width}", withString: "\(Int(ceil(width * scale)))")
            .stringByReplacingOccurrencesOfString("{height}", withString: "\(Int(ceil(height * scale)))")
        
        getImage(url, closure: closure)
    }
    
    func getImage(url: String, closure: ((image: UIImage?) -> ())?)
    {
        if let image = PersistenceManager.sharedManager.unarchiveImage(url)
        {
            closure?(image: image)
        }
        else
        {
            fetchImage(url, closure: closure)
        }
    }
    
    private func fetchImage(url: String, closure: ((image: UIImage?)->())?)
    {
        Alamofire.request(.GET, url)
            .responseJSON {response in
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    
                    var image: UIImage?
                    if let data = response.data
                    {
                        image = UIImage(data: data)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        closure?(image: image)
                        
                        if let img = image
                        {
                            PersistenceManager.sharedManager.archiveImage(img, fileName: url)
                        }
                    }
                }
        }
    }
}
