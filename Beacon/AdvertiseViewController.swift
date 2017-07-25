import Cocoa

// MARK: - AdvertiseViewController

final class AdvertiseViewController: NSViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var uuidTextField: NSTextFieldCell!
    @IBOutlet private var majorTextField: NSTextField!
    @IBOutlet private var minorTextField: NSTextField!
    @IBOutlet private var powerTextField: NSTextField!
    @IBOutlet private var generateUUIDButton: NSButton!
    @IBOutlet private var startStopAdvertisingButton: NSButton!
    
    // MARK: - Stored Properties
    
    
    private let persistenceService = PersistenceService()
    private var transmitter: Transmitter?
    
    // MARK: - Computed Properties
    
    fileprivate var isAdvertising: Bool {
        return transmitter?.isAdvertising ?? false
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPreviousAdvertisement()
    }
    
    // MARK: - Load/Save
    
    private func loadPreviousAdvertisement() {
        uuidTextField.stringValue = persistenceService.uuid
        majorTextField.stringValue = persistenceService.major
        minorTextField.stringValue = persistenceService.minor
        powerTextField.stringValue = persistenceService.power
    }
    
    private func saveAdvertisement() {
        persistenceService.uuid = uuidTextField.stringValue
        persistenceService.major = majorTextField.stringValue
        persistenceService.minor = minorTextField.stringValue
        persistenceService.power = powerTextField.stringValue
    }
    
    // MARK: - Actions
    
    @IBAction func startStopAdvertisingButtonClicked(_ sender: AnyObject) {
        if isAdvertising {
            stopAdvertising()
        } else {
            saveAdvertisement()
            startAdvertising()
        }
    }
    
    @IBAction func genereateUUIDClicked(_ sender: AnyObject) {
        uuidTextField.stringValue = "\(UUID().uuidString)"
    }
    
    // MARK: - Advertising
    
    private func startAdvertising() {
        guard let proximityUUID = UUID(uuidString: uuidTextField.stringValue) else { return }
        
        let advertisement = Advertisement(
            proximityUUID: proximityUUID,
            major: UInt16(majorTextField.integerValue),
            minor: UInt16(minorTextField.integerValue),
            power: Int8(powerTextField.integerValue)
        )
        self.transmitter = Transmitter(
            delegate: self,
            advertisement: advertisement
        )
    }
    
    private func stopAdvertising() {
        self.transmitter = nil
    }
    
    // MARK: - Update
    
    fileprivate func updateUI(for AdvertisingStatus: AdvertisingStatus) {
        switch AdvertisingStatus {
        case .advertising:
            startStopAdvertisingButton.title = "Stop Advertising"
            startStopAdvertisingButton.isEnabled = true
            disableControls()
            
        case .notAdvertising:
            startStopAdvertisingButton.title = "Start Advertising"
            startStopAdvertisingButton.isEnabled = true
            enableControls()
            
        case .resumeAdvertise:
            startAdvertising()
            startStopAdvertisingButton.isEnabled = true
            disableControls()
            
        case .cannotAdvertise:
            startStopAdvertisingButton.isEnabled = false
            disableControls()
        }
    }
    
    private func enableControls() {
        updateControls(enabled: true)
    }
    
    private func disableControls() {
        updateControls(enabled: false)
    }
    
    private func updateControls(enabled: Bool) {
        generateUUIDButton.isEnabled = enabled
        uuidTextField.isEnabled = enabled
        majorTextField.isEnabled = enabled
        minorTextField.isEnabled = enabled
        powerTextField.isEnabled = enabled
    }
}

// MARK: - TransmitterDelegate

extension AdvertiseViewController: TransmitterDelegate {
    func transmitterDidPowerOn() {
        let advertisingStatus = AdvertisingStatus(isAdvertising: isAdvertising)
        updateUI(for: advertisingStatus)
    }
    
    func transmitterDidPowerOff() {
        updateUI(for: .cannotAdvertise)
    }
    
    func transmitterDidStartAdvertising() {
        updateUI(for: .advertising)
    }
    
    func transmitterDidStopAdvertising() {
        updateUI(for: .notAdvertising)
    }
}
