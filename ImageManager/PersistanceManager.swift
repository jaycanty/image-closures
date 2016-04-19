//
//  ImageManager.swift
//  ImageManager
//
//  Created by Jay Canty on 4/18/16.
//  Copyright © 2016 Jay Canty. All rights reserved.
//

import Foundation
import UIKit

class PersistenceManager
{
    static let sharedManager = PersistenceManager()
    
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    let imageDirectory = "/images/"
    
    // MARK: Images
    func archiveImage(image: UIImage, fileName: String) {
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            guard let fn = fileName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) else {
                print("Archive image - could not encode \(fileName)")
                return
            }
            let filePath = self.imagesDirectory().stringByAppendingPathComponent(fn)
            let success = NSKeyedArchiver.archiveRootObject(image, toFile: filePath)
            
            if !success {
                print("Archive image - Failed to archive \(fn) to images directory")
            }
        }
    }
    
    func unarchiveImage(fileName: String) -> UIImage? {
        
        guard let fn = fileName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet()) else {
            print("Unarchive image - could not encode \(fileName)")
            return nil
        }
        let filePath = imagesDirectory().stringByAppendingPathComponent(fn)
        if let image = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) {
            return (image as! UIImage)
        }
        return nil
    }
    
    // MARK: - helper
    private func imagesDirectory() -> NSString {
        
        let imagesDirectory = documentsDirectory().stringByAppendingPathComponent(imageDirectory)
        if !NSFileManager.defaultManager().fileExistsAtPath(imagesDirectory) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(imagesDirectory, withIntermediateDirectories: false, attributes: nil)
            } catch  {
                print("imagesDirectory: \(error)")
            }
        }
        return imagesDirectory
    }
    
    private func documentsDirectory() -> NSString {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    
    private func clearDocumentsDirectory() {
        
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(self.documentsDirectory() as String)
            let documentsDirectoryURL = NSURL(fileURLWithPath: self.documentsDirectory() as String)
            
            for filename in directoryContents {
                
                let file = documentsDirectoryURL.URLByAppendingPathComponent(filename)
                
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(file)
                }
                catch let error as NSError {
                    print("> Emptying sandbox: could not delete file", filename, error)
                }
            }
        }
        catch let error as NSError {
            print("> Emptying sandbox: Error emptying sandbox", error)
        }
    }
}
