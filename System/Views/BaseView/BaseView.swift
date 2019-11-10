//
//  BaseView.swift
//  System
//
//  Created by SangNX on 11/10/19.
//  Copyright © 2019 nxsang063@gmail.com. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    open var view: UIView!
    private let kEmptyString = ""

    func getClassName(object: Any) -> String {
        return String(describing: type(of: (object as AnyObject))).replacingOccurrences(of:kEmptyString, with:".Type")
    }
    
    deinit {
        let str = getClassName(object: self) + " deinit"
        print(str)
    }
    
    
    private func setupXib() {
        view = loadViewFromNib()
        view.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        view.frame = bounds
        addSubview(view)
        self.setFullLayout(view)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        firstInit()
    }
    
    open func firstInit() {
        
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName:self.getClassName(object: self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
        firstInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    func setFullLayout(_ view : UIView)  {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0))
    }
    
}
