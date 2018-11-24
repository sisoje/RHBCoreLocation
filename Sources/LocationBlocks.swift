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
    public var didFinishDeferredUpdatesWithError:((Error?) -> Void)?
    public var didDetermineState:[CLRegionState:(CLRegion) -> Void] = [:]
    public var didRegionEvent:[RegionEvent:(CLRegion) -> Void] = [:]
    public var monitoringDidFailForRegion:((CLRegion?, Error) -> Void)?
    public var didUpdateLocations:(([CLLocation]) -> Void)?
    public var didChangeAuthorization:[CLAuthorizationStatus:() -> Void] = [:]
    public var didFailWithError:((Error) -> Void)?

    #if os(iOS)
    public var didUpdateHeading:((CLHeading) -> Void)?
    public var didRangeBeacons:(([CLBeacon],CLBeaconRegion) -> Void)?
    public var didVisit:((CLVisit) -> Void)?
    public var rangingBeaconsDidFailForRegion:((CLBeaconRegion, Error) -> Void)?
    public var shouldDisplayHeadingCalibration:(()->Bool)?
    public var didLocationUpdate:[LocationUpdate:() -> Void] = [:]
    #endif
}
