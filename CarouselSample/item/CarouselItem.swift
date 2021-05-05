//
//  CarouselItem.swift
//  CarouselSample
//
//  Created by AMRUTHAPRASAD KK on 05/05/21.
//  Copyright © 2021 MB. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CarouselItem: UIView {
    static let CAROUSEL_ITEM_NIB = "CarouselItem"
    
    
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var vwContent: UIView!
    @IBOutlet var vwBackground: UIView!
    var models: [String]?
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    convenience init(name: String? = "", url: String? = "", models: [String]) {
        self.init()
        self.models = models
        downloadImage(from: URL.init(string: url!)!)
    }
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    fileprivate func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.itemImageView.image = UIImage(data: data)
            }
        }
    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(CarouselItem.CAROUSEL_ITEM_NIB, owner: self, options: nil)
        vwContent.frame = bounds
        vwContent.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(vwContent)
    }
}
