import CoreBluetooth

// MARK: - TransmitterDelegate

protocol TransmitterDelegate: class {
    func transmitterDidPowerOn()
    func transmitterDidPowerOff()
    
    func transmitterDidStartAdvertising()
    func transmitterDidStopAdvertising()
}

// MARK: - Transmitter

final class Transmitter: NSObject {
    
    // MARK: - Stored Properties
    
    weak var delegate: TransmitterDelegate?
    private lazy var manager: CBPeripheralManager = {
        return CBPeripheralManager(delegate: self, queue: nil)
    }()
    private let advertisement: Advertisement
    
    // MARK: - Lifecycle
    
    init(
        delegate: TransmitterDelegate,
        advertisement: Advertisement)
    {
        self.delegate = delegate
        self.advertisement = advertisement
        
        super.init()
        
        self.startTransmitting()
    }
    
    deinit {
        stopTransmitting()
    }
    
    // MARK: - Transmitting
    
    private func startTransmitting() {
        manager.startAdvertising(advertisement.data)
        delegate?.transmitterDidStartAdvertising()
    }
    
    private func stopTransmitting() {
        manager.stopAdvertising()
        delegate?.transmitterDidStopAdvertising()
    }
    
    var isAdvertising: Bool {
        return manager.isAdvertising
    }
}

// MARK: - CBPeripheralManagerDelegate

extension Transmitter: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {    
        switch peripheral.state {
        case .poweredOn:
            delegate?.transmitterDidPowerOn()
        default:
            delegate?.transmitterDidPowerOff()
        }
    }
    
    func peripheralManagerDidStartAdvertising(
        _ peripheral: CBPeripheralManager,
        error: Error?)
    {
        guard error == nil else {
            print("\(#function) failed with: \(error!)")
            delegate?.transmitterDidStopAdvertising()
            return
        }
        
        delegate?.transmitterDidStartAdvertising()
    }
}
