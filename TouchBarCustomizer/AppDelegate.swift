import AppKit

@main
class AppMain: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false)
        window.center()
        window.title = "TouchBar Config"
        window.makeKeyAndOrderFront(nil)
        
        TouchBarManager.shared.setupGlobalTouchBar()
    }
}
