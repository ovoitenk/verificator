//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 05.12.2020.
//

import Foundation
import UIKit

internal class CommonNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.barTintColor = ColorStyle.dark
        navigationBar.tintColor = ColorStyle.tintLight
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorStyle.white]
        navigationBar.shadowImage = UIImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
