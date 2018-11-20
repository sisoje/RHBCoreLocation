import CoreLocation

public class LocationActions {
    public init() {
        delegate = LocationManagerDelegateWithBlocks(blocks)
    }
    public let blocks = LocationBlocks()
    public weak var manager: CLLocationManager? {
        didSet {
            oldValue?.delegate = nil
            manager?.delegate = delegate
        }
    }
    let delegate: CLLocationManagerDelegate
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        blocks.didChangeAuthorization[status]?()
    }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        blocks.didRegionEvent[.startMonitoring]?(region)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        blocks.didUpdateLocations?(locations)
    }
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        blocks.didDetermineState[state]?(region)
    }
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        blocks.didFinishDeferredUpdatesWithError?(error)
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

