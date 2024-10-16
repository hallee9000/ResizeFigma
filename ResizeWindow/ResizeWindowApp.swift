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
            let image: NSImage = {
                let ratio = $0.size.height / $0.size.width
                $0.size.height = 18
                $0.size.width = 18 / ratio
                $0.isTemplate = true  // 设置为模板图像
                return $0
            }(NSImage(named: "MenuBarIcon")!)

            Image(nsImage: image)
        })
        .menuBarExtraStyle(.window)
    }
}
