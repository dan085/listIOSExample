//
//  empty_notepad_view.swift
//  Chat_Information_Contact
//
//  Created by Daniel Verdugo Gonzalez on 10-11-16.
//  Copyright © 2018 Bimbask, LLC. All rights reserved.
//
import Foundation
import UIKit

class emptyViewEmptyView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emptyIcon: UIImageView!

    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
       // setupView()
        loadViewFromNib()
          
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     //   setupView()
        loadViewFromNib()
          
    }
    
    func loadViewFromXibFile() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "emptyViewEmptyView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    func setupView() {
        view = loadViewFromXibFile()
        view.frame = CGRect(x: 0 , y: 30, width: 260, height: 260)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        self.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = ""
        view.layer.cornerRadius = 1.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 8.0)
    }
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "emptyViewEmptyView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
   
  
}
