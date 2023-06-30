//
//  UnderlinedTextField.swift
//  VendingGamePOC
//
//  Created by Dmitrij Aleinikov on 05.10.2021.
//

import UIKit

public class UnderlinedTextField: UITextField {
    
    @IBInspectable public var underlineColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable public var isHiddenUnderline: Bool = false {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.borderStyle = .none
        self.addTarget(self, action: #selector(onTapHandler), for: .editingDidBegin)
        self.addTarget(self, action: #selector(onEditingDidEnd), for: UIControl.Event.editingDidEnd)
        self.setNeedsDisplay()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(isHiddenUnderline ? UIColor.clear.cgColor : underlineColor.cgColor)
            context.setLineWidth(2.0)
            
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.strokePath()
        }
    }
    
    @objc func onTapHandler() {
        self.perform(#selector(selectAll), with: nil, afterDelay: 0.0)
    }
    
    @objc func onEditingDidEnd() {
        self.selectedTextRange = nil
    }

    deinit {
        self.removeTarget(self, action: nil, for: .allEvents)
    }
}
