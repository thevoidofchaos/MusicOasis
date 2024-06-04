//
//  EKPresentation.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 23/05/23.
//

import Foundation
import UIKit
import SwiftEntryKit

public func EKCustomPresentation(animationType: EKAttributes?, titleText: String?, descriptionText: String?, gradientColor1: UIColor?, gradientColor2: UIColor?, startPoint: CGPoint?, endPoint: CGPoint?, titleFont: UIFont?, descriptionFont: UIFont?) {
    
    
    var attributes = animationType ?? EKAttributes.topFloat
    
    attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(gradientColor1 ?? UIColor.black), EKColor(gradientColor2 ?? UIColor.white)], startPoint: startPoint ?? .zero, endPoint: endPoint ?? CGPoint(x: 1, y: 1)))
    
    attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.5), scale: .init(from: 1, to: 0.7, duration: 0.7)))
    attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
    attributes.statusBar = .dark
    attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)

    let title = EKProperty.LabelContent(text: titleText ?? "", style: .init(font: titleFont ?? UIFont.systemFont(ofSize: 20), color: EKColor.white))
    let description = EKProperty.LabelContent(text: descriptionText ?? "", style: .init(font: descriptionFont ?? UIFont.systemFont(ofSize: 15), color: EKColor.white))
    
    let simpleMessage = EKSimpleMessage(title: title, description: description)
    let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

    let contentView = EKNotificationMessageView(with: notificationMessage)
    SwiftEntryKit.display(entry: contentView, using: attributes)
    
}
