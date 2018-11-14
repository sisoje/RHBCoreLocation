import CoreLocation

public enum RegionEvent {
    case startMonitoring
    case enter
    case exit
}

public enum LocationUpdate {
    case pause
    case resume
}

public class LocationBlocks {
    #if os(iOS)
    public var didUpdateHeading:((CLHeading)->Void)?
    public var didRangeBeacons:(([CLBeacon],CLBeaconRegion)->Void)?
    public var didVisit:((CLVisit)->Void)?
    public var rangingBeaconsDidFailForRegion:((CLBeaconRegion, Error)->Void)?
    public var shouldDisplayHeadingCalibration:(()->Bool)?
    public var didLocationUpdate:[LocationUpdate:()->Void] = [:]
    #endif

    #if os(iOS) || os(macOS)
    public var didFinishDeferredUpdatesWithError:((Error?)->Void)?
    #endif

    public var didDetermineState:[CLRegionState:(CLRegion)->Void] = [:]
    public var didRegionEvent:[RegionEvent:(CLRegion)->Void] = [:]
    public var monitoringDidFailForRegion:((CLRegion?, Error)->Void)?
    public var didUpdateLocations:(([CLLocation])->Void)?
    public var didChangeAuthorization:[CLAuthorizationStatus:()->Void] = [:]
    public var didFailWithError:((Error)->Void)?
}

public class LocationActions {
    public let blocks = LocationBlocks()
    weak var manager: CLLocationManager?
    lazy var delegate: CLLocationManagerDelegate = LocationManagerDelegateWithBlocks(blocks)

    public init(_ manager: CLLocationManager) {
        self.manager = manager
        manager.delegate = delegate
    }

    deinit {
        manager?.delegate = nil
    }
}

class LocationManagerDelegateWithBlocks: NSObject, CLLocationManagerDelegate {
    let blocks: LocationBlocks

    init(_ blocks: LocationBlocks) {
        self.blocks = blocks
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        blocks.didFailWithError?(error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        blocks.didUpdateLocations?(locations)
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        blocks.didDetermineState[state]?(region)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        blocks.didRegionEvent[.enter]?(region)
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        blocks.didRegionEvent[.exit]?(region)
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        blocks.monitoringDidFailForRegion?(region, error)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        blocks.didChangeAuthorization[status]?()
    }

    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        blocks.didRegionEvent[.startMonitoring]?(region)
    }

    #if os(iOS) || os(macOS)
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        blocks.didFinishDeferredUpdatesWithError?(error)
    }
    #endif

    #if os(iOS)
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        blocks.didUpdateHeading?(newHeading)
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        blocks.didLocationUpdate[.pause]?()
    }
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        blocks.didLocationUpdate[.resume]?()
    }
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        blocks.didVisit?(visit)
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        blocks.didRangeBeacons?(beacons, region)
    }
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        blocks.rangingBeaconsDidFailForRegion?(region, error)
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return blocks.shouldDisplayHeadingCalibration?() ?? false
    }
    #endif
}

