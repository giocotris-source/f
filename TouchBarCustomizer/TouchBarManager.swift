import AppKit

class TouchBarManager: NSObject, NSTouchBarDelegate {
    static let shared = TouchBarManager()
    
    var touchBar: NSTouchBar!
    let batteryManager = BatteryManager()
    let weatherManager = WeatherManager()
    
    func setupGlobalTouchBar() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        
        touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.weather, .battery, .chat, .clock, .calc, .dino, .media]
        
        NSTouchBar.presentSystemModalFunctionBar(touchBar, systemTrayItemIdentifier: "com.pietro.touchbar")
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case .weather:
            let button = NSButton(title: "Meteo...", target: nil, action: nil)
            weatherManager.fetchWeather { temp in
                button.title = temp
            }
            item.view = button
            
        case .battery:
            let button = NSButton(title: "Bat", target: nil, action: nil)
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                let stats = self.batteryManager.getBatteryStats()
                button.title = "\(stats.percentage)% | \(String(format: "%.2f", stats.wattage))W"
            }
            item.view = button
            
        case .chat:
            let textField = NSTextField(string: "")
            textField.placeholderString = "Chat AI..."
            textField.target = self
            textField.action = #selector(handleChat(_:))
            textField.widthAnchor.constraint(equalToConstant: 120).isActive = true
            item.view = textField
            
        case .clock:
            let label = NSTextField(labelWithString: "")
            label.font = NSFont.monospacedDigitSystemFont(ofSize: 14, weight: .bold)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                label.stringValue = formatter.string(from: Date())
            }
            item.view = label
            
        case .calc:
            let button = NSButton(image: NSImage(named: NSImage.touchBarCalculateTemplateName)!, target: self, action: #selector(openCalculator))
            item.view = button
            
        case .dino:
            let button = NSButton(title: "🦖", target: self, action: #selector(launchDino))
            item.view = button
            
        case .media:
            let stack = NSStackView()
            stack.orientation = .horizontal
            stack.spacing = 2
            let playBtn = NSButton(image: NSImage(named: NSImage.touchBarPlayPauseTemplateName)!, target: self, action: #selector(mediaPlay))
            let nextBtn = NSButton(image: NSImage(named: NSImage.touchBarFastForwardTemplateName)!, target: self, action: #selector(mediaNext))
            stack.addArrangedSubview(playBtn)
            stack.addArrangedSubview(nextBtn)
            item.view = stack
            
        default: return nil
        }
        
        return item
    }
    
    @objc func handleChat(_ sender: NSTextField) {
        let query = sender.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://chatgpt.com/?q=\(query)") {
            NSWorkspace.shared.open(url)
        }
        sender.stringValue = ""
    }
    
    @objc func openCalculator() {
        if let url = URL(string: "file:///System/Applications/Calculator.app") {
            NSWorkspace.shared.open(url)
        }
    }
    
    @objc func launchDino() {}
    @objc func mediaPlay() {}
    @objc func mediaNext() {}
}

extension NSTouchBarItem.Identifier {
    static let weather = NSTouchBarItem.Identifier("com.pietro.weather")
    static let battery = NSTouchBarItem.Identifier("com.pietro.battery")
    static let chat = NSTouchBarItem.Identifier("com.pietro.chat")
    static let clock = NSTouchBarItem.Identifier("com.pietro.clock")
    static let calc = NSTouchBarItem.Identifier("com.pietro.calc")
    static let dino = NSTouchBarItem.Identifier("com.pietro.dino")
    static let media = NSTouchBarItem.Identifier("com.pietro.media")
}
