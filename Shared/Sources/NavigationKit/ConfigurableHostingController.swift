//
//  ConfigurableHostingController.swift
//  Shared
//
//  Created by David Blake on 24/08/2025.
//

import SwiftUI

protocol ConfigurableHostingControllerProtocol: AnyObject {
    var navConfig: NavigationBarData { get }
}

final class ConfigurableHostingController<Content: View>: UIHostingController<Content>, ConfigurableHostingControllerProtocol {
    let navConfig: NavigationBarData
    
    init(rootView: Content, navConfig: NavigationBarData) {
        self.navConfig = navConfig
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
