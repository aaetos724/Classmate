import Foundation

class SetupManager {
    static let shared = SetupManager()
    
    var isSetupComplete: Bool {
        UserDefaults.standard.bool(forKey: "isSetupComplete")
    }
    
    func markSetupComplete() {
        UserDefaults.standard.set(true, forKey: "isSetupComplete")
    }
    
    func resetSetup() {
        UserDefaults.standard.set(false, forKey: "isSetupComplete")
    }
} 