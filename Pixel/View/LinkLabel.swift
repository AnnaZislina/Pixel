//
//  LinkLabel.swift
//  Pixel
//
//  Created by Anna Zislina on 14/12/2019.
//  Copyright © 2019 Anna Zislina. All rights reserved.
//

import UIKit

@IBDesignable
class LinkLabel: UILabel {
    
    @IBInspectable
    var url: String? {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onLabelClick(sender:)))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(tap)
        }
    }
    
    override var text: String? {
        didSet {
            guard text != nil else { return }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onLabelClick(sender:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    private func openUrl(urlString: String!) {
        var url = URL(string: urlString)!
        if(!urlString.starts(with: "http")) {
            url = URL(string: "http://" + urlString)!
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func onLabelClick(sender: UITapGestureRecognizer) {
        self.openUrl(urlString: url)
    }
    
}
