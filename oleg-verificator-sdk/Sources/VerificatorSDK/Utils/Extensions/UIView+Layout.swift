//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation
import UIKit

internal struct Constraint {
    let fromAttribute: NSLayoutConstraint.Attribute
    let to: Any?
    let toAttribute: NSLayoutConstraint.Attribute
    let constant: CGFloat
    
    init(_ attribute: NSLayoutConstraint.Attribute) {
        self.fromAttribute = attribute
        self.to = nil
        switch fromAttribute {
        case .bottom:
            self.toAttribute = .bottom
        case .top:
            self.toAttribute = .top
        case .leading:
            self.toAttribute = .leading
        case .trailing:
            self.toAttribute = .trailing
        case .centerX:
            self.toAttribute = .centerX
        case .centerY:
            self.toAttribute = .centerY
        default:
            self.toAttribute = .notAnAttribute
        }
        self.constant = 0
    }
    
    init(from: NSLayoutConstraint.Attribute, to: Any?, toAttribute: NSLayoutConstraint.Attribute, constant: CGFloat) {
        self.fromAttribute = from
        self.to = to
        self.toAttribute = toAttribute
        self.constant = constant
    }
    
    func constant(_ offset: CGFloat) -> Constraint {
        var newOffset = offset
        switch fromAttribute {
        case .bottom, .trailing:
            newOffset = -offset
        default:
            break
        }
        return Constraint(
            from: fromAttribute,
            to: to,
            toAttribute: toAttribute,
            constant: newOffset
        )
    }
    
    func to(_ to: Any?) -> Constraint {
        return Constraint(
            from: fromAttribute,
            to: to,
            toAttribute: toAttribute,
            constant: constant
        )
    }
    
    func to(_ to: Any?, attribute: NSLayoutConstraint.Attribute) -> Constraint {
        return Constraint(
            from: fromAttribute,
            to: to,
            toAttribute: attribute,
            constant: constant
        )
    }
}

internal extension UIView {
    @discardableResult
    func layout(_ constraints: [Constraint]) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let layoutConstraints = constraints.map({ (constraint) -> NSLayoutConstraint in
            var to = constraint.to
            if to == nil {
                switch constraint.fromAttribute {
                case .bottom, .trailing, .leading, .top, .centerX, .centerY:
                    to = superview
                default:
                    to = nil
                }
            }
            return NSLayoutConstraint(
                item: self,
                attribute: constraint.fromAttribute,
                relatedBy: .equal,
                toItem: to,
                attribute: constraint.toAttribute,
                multiplier: 1.0,
                constant: constraint.constant
            )
        })
        NSLayoutConstraint.activate(layoutConstraints)
        return layoutConstraints
    }
}
