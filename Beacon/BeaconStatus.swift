enum AdvertisingStatus {
    case advertising
    case notAdvertising
    case resumeAdvertise
    case cannotAdvertise
    
    init(isAdvertising: Bool) {
        self = isAdvertising ? .resumeAdvertise : .notAdvertising
    }
}
