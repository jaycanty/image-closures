//
//  TableViewCell.swift
//  ImageManager
//
//  Created by Jay Canty on 4/18/16.
//  Copyright © 2016 Jay Canty. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    var imageClosures: ImageClosures?
    
    var data: String? {
        didSet {
            updateUI()
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        cellImageView.image = nil
        imageClosures = nil
    }
    
    private func updateUI() {
        
        imageClosures = ImageClosures(view: self)
        if let url = data {
            ImageManager.sharedManager.getImage(
                url: url,
                closure: imageClosures?.imageClosure
            )
        }
    }
}

class ImageClosures {
    
    weak var view: TableViewCell?
    
    var imageClosure: ((image: UIImage?) -> ())?
    
    init(view: TableViewCell) {
        self.view = view
        
        imageClosure = { [weak self] image in
            
            if let img = image {
                self?.view?.cellImageView.image = img
            } else {
                // TODO: load placeholder
                print("LOAD FAILED")
            }
        }
    }
}
