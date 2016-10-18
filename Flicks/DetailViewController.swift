//
//  DetailViewController.swift
//  Flicks
//
//  Created by Mike Tehranian on 10/16/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    var imageUrl: String?
    var smallImageUrl: String?
    var largeImageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        loadImage()
        
        titleLabel.sizeToFit()
        overviewLabel.sizeToFit()
    }
    
    func loadImage() {
        
        if imageUrl == nil || largeImageUrl == nil || smallImageUrl == nil {
            return
        }
        
        self.posterImageView.setImageWith(
            URLRequest(url: URL(string: smallImageUrl!)!),
            placeholderImage: UIImage(named: "video"),
            success: { (smallImageRequest, smallImageResponse, smallImage) in
                
                self.posterImageView.alpha = 0.0
                self.posterImageView.image = smallImage
                
                UIView.animate(
                    withDuration: 0.3,
                    animations: {
                        self.posterImageView.alpha = 1.0
                    },
                    completion: { (success) -> Void in
                        self.posterImageView.setImageWith(
                            URLRequest(url: URL(string: self.largeImageUrl!)!),
                            placeholderImage: smallImage,
                            success: {
                                (largeImageRequest, largeImageResponse, largeImage) in
                                self.posterImageView.image = largeImage
                            },
                            failure: nil)
                })
            },
            failure: nil)
        
    }
}
