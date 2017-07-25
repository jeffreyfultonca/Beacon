import Foundation

// MARK: - PersistenceServiceProtocol

protocol PersistenceServiceProtocol {
    var uuid: String { get set }
    var major: String { get set }
    var minor: String { get set }
    var power: String { get set }
}

// MARK: - PersistenceService

class PersistenceService: PersistenceServiceProtocol {
    
    // MARK: - UserDefaults
    
    private let defaults = UserDefaults.standard
    struct Key {
        static let udid = "udid"
        static let major = "major"
        static let minor = "minor"
        static let power = "power"
    }
    
    // MARK: - PersistenceServiceProtocol
    
    var uuid: String {
        get { return defaults.string(forKey: Key.udid) ?? "" }
        set { defaults.set(newValue, forKey: Key.udid) }
    }
    
    var major: String {
        get { return defaults.string(forKey: Key.major) ?? "" }
        set { defaults.set(newValue, forKey: Key.major) }
    }
    
    var minor: String {
        get { return defaults.string(forKey: Key.minor) ?? "" }
        set { defaults.set(newValue, forKey: Key.minor) }
    }
    
    var power: String {
        get { return defaults.string(forKey: Key.power) ?? "" }
        set { defaults.set(newValue, forKey: Key.power) }
    }
}
