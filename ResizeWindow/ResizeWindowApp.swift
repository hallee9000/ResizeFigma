//
//  ResizeWindowApp.swift
//  ResizeWindow
//
//  Created by hal on 2023/9/26.
//

import SwiftUI

@main
struct ResizeWindowApp: App {
    var body: some Scene {
        MenuBarExtra(content: {
            ContentView()
        }, label: {
            HStack {
                Image(systemName: "macwindow.on.rectangle")
            }
        })
        .menuBarExtraStyle(.window)
    }
}
