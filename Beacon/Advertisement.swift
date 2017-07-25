import CoreLocation

// MARK: - Advertisement
    
struct Advertisement {
    
    // MARK: - Stored Properties
    
    let proximityUUID: UUID
    let major:  CLBeaconMajorValue
    let minor: CLBeaconMinorValue
    let power: Int8
    
    // MARK: - Computed Properties
    
    /// Magic data structure which CBPeripheralManager knows how to advertise with.
    var data: [String: Any] {
        let bufferSize = 21
        let beaconKey: NSString = "kCBAdvDataAppleBeaconKey"
        
        var advertisementBytes = [CUnsignedChar](repeating: 0, count: bufferSize)

        (proximityUUID as NSUUID).getBytes(&advertisementBytes)
        
        advertisementBytes[16] = CUnsignedChar(major >> 8)
        advertisementBytes[17] = CUnsignedChar(major & 255)
        
        advertisementBytes[18] = CUnsignedChar(minor >> 8)
        advertisementBytes[19] = CUnsignedChar(minor & 255)
        
        // http://stackoverflow.com/a/25667091/3824765
        advertisementBytes[20] = CUnsignedChar(bitPattern: power)
        
        // http://stackoverflow.com/questions/24196820/nsdata-from-byte-array-in-swift
        let advertisement = Data(bytes: UnsafePointer<UInt8>(advertisementBytes), count: bufferSize)
        
        let nsDictionary = NSDictionary(object: advertisement, forKey: beaconKey)
        
        return nsDictionary as? [String: Any] ?? [:]
    }
}
