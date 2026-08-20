import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

@main
struct MacupApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var controller = CaffeineController()

    var body: some Scene {
        MenuBarExtra {
            Button(controller.isActive ? "Stop" : "Start") {
                controller.toggle()
            }
            Divider()
            Button("Quit") {
                controller.stop()
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: controller.isActive ? "cup.and.saucer.fill" : "cup.and.saucer")
                .symbolRenderingMode(.monochrome)
        }
        .menuBarExtraStyle(.menu)
    }
}
