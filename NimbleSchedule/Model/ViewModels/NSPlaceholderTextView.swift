//
//  NSPlaceholderTextView.swift
//

import UIKit

private var myContext = 0

@IBDesignable
public class NSPlaceholderTextView: UITextView {
    
    private struct Constants {
        static let defaultiOSPlaceholderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    }
    private let placeholderLabel: UILabel = UILabel()
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    
    @IBInspectable public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    @IBInspectable public var placeholderColor: UIColor = NSPlaceholderTextView.Constants.defaultiOSPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    override public var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override public var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override public var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override public var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "textDidChange",
            name: UITextViewTextDidChangeNotification,
            object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clearColor()
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
        
        addObserver(self,
            forKeyPath: "textContainer.size",
            options: [.Old, .New],
            context: &myContext)
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-left-[placeholder(width)]-right-|",
            options: [],
            metrics: [
                "left" : textContainerInset.left + textContainer.lineFragmentPadding,
                "right" : textContainerInset.right + textContainer.lineFragmentPadding,
                "width": textContainer.size.width - textContainer.lineFragmentPadding * 2.0
            ],
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(\(textContainerInset.top))-[placeholder]-(>=\(textContainerInset.bottom))-|",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc private func textDidChange() {
        placeholderLabel.hidden = !text.isEmpty
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard context == &myContext else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            return
        }
        guard let oldWidth = change?[NSKeyValueChangeOldKey]?.CGSizeValue().width else {
            return
        }
        guard let newWidth = change?[NSKeyValueChangeNewKey]?.CGSizeValue().width else {
            return
        }
        if oldWidth != newWidth {
            updateConstraintsForPlaceholderLabel()
            placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
            name: UITextViewTextDidChangeNotification,
            object: nil)
        removeObserver(self,
            forKeyPath: "textContainer.size",
            context: &myContext)
    }
    
}
