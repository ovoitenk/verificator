//
//  File.swift
//  
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit

struct PhotoCaptureConfiguration {
    let title: String
    let description: String
    let defaultCamera: PhotoCaptureCameraType
    let tintColor: UIColor
    let errorHandlingMode: VeritificatorErrorHandlingMode
}
