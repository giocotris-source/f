import Foundation
import IOKit.ps

class BatteryManager {
    func getBatteryStats() -> (percentage: Int, wattage: Double) {
        let blob = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let list = IOPSCopyPowerSourcesList(blob).takeRetainedValue() as [CFTypeRef]
        
        guard let first = list.first else { return (0, 0.0) }
        
        let dict = IOPSGetPowerSourceDescription(blob, first).takeUnretainedValue() as! [String: Any]
        
        let capacity = dict[kIOPSCurrentCapacityKey] as? Int ?? 0
        let maxCapacity = dict[kIOPSMaxCapacityKey] as? Int ?? 100
        let percentage = Int((Double(capacity) / Double(maxCapacity)) * 100)
        
        let voltage = dict[kIOPSVoltageKey] as? Double ?? 0.0
        let amperage = dict[kIOPSAmperageKey] as? Double ?? 0.0
        let wattage = (voltage / 1000.0) * (amperage / 1000.0)
        
        return (percentage, wattage)
    }
}
