#if canImport(CoreLocation)
  import ComposableArchitecture
  import CoreLocation

  extension CLAuthorizationStatus: CustomDebugOutputConvertible {
    public var debugOutput: String {
      switch self {
      case .notDetermined:
        return "notDetermined"
      case .restricted:
        return "restricted"
      case .denied:
        return "denied"
      case .authorizedAlways:
        return "authorizedAlways"
      case .authorizedWhenInUse:
        return "authorizedWhenInUse"
      @unknown default:
        return "unknown"
      }
    }
  }
#endif
