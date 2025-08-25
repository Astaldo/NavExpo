//
//  ConfigurableHostingController.swift
//  Shared
//
//  Created by David Blake on 24/08/2025.
//

import SwiftUI
import UIKit

protocol ConfigurableHostingControllerProtocol: AnyObject {
    var navConfigFactory: NavigationBarDataFactory? { get }
}

final class ConfigurableHostingController<Content: View>: UIHostingController<Content>, ConfigurableHostingControllerProtocol {
    let navConfigFactory: NavigationBarDataFactory?
    
    init(rootView: Content, navConfigFactory: NavigationBarDataFactory?) {
        self.navConfigFactory = navConfigFactory
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
