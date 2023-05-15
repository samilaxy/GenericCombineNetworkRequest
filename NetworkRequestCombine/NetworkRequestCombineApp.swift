//
//  NetworkRequestCombineApp.swift
//  NetworkRequestCombine
//
//  Created by Noye Samuel on 26/03/2023.
//

import SwiftUI

@main
struct NetworkRequestCombineApp: App {
    static let dataService = CombineImp()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
