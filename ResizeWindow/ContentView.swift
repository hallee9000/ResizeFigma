//
//  ContentView.swift
//  ResizeWindow
//
//  Created by hal on 2023/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var width: String = "1080"
    @State private var height: String = "608"
    @State private var isCentered = false
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    var body: some View {
        VStack {
            HStack {
                Text("Width:")
                TextField("Width", text: $width, onCommit: {
                    checkForNumericInput(input: &width)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("Height:")
                TextField("Height", text: $height, onCommit: {
                    checkForNumericInput(input: &height)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Toggle(isOn: $isCentered) {
                Text("Centered window")
            }
            Button(action: {
                resizeWindow()
            }) {
                Text("Resize Figma")
            }
            Divider()
            HStack {
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }.keyboardShortcut("q")
            }
        }
        .padding()
    }
    func checkForNumericInput(input: inout String) {
        if Double(input) == nil {
            input = ""
        }
    }
    func resizeWindow() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)

        if accessibilityEnabled {
            let app = NSRunningApplication.runningApplications(withBundleIdentifier: "com.figma.Desktop").first
            if let app = app {
                let appRef = AXUIElementCreateApplication(app.processIdentifier)
                var value: AnyObject?
                let result = AXUIElementCopyAttributeValue(appRef, kAXMainWindowAttribute as CFString, &value)
                if result == AXError.success {
                    let windowRef = value as! AXUIElement
                    if let widthValue = Double(width),
                       let heightValue = Double(height) {
                        var size = CGSize(width: widthValue, height: heightValue+38)
                        let sizeRef = AXValueCreate(AXValueType.cgSize, &size)
                        AXUIElementSetAttributeValue(windowRef, kAXSizeAttribute as CFString, sizeRef!)
                        if isCentered {
                            // 获取屏幕的尺寸
                            let screenSize = NSScreen.main?.frame.size ?? CGSize(width: 0, height: 0)
                            // 计算新的窗口位置
                            var position = CGPoint(x: (screenSize.width - widthValue) / 2, y: (screenSize.height - heightValue - 38) / 2)
                            let positionRef = AXValueCreate(AXValueType.cgPoint, &position)
                            AXUIElementSetAttributeValue(windowRef, kAXPositionAttribute as CFString, positionRef!)
                        }
                    }
                }
            }
        } else {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
