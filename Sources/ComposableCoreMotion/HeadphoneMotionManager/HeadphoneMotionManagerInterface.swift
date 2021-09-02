import ComposableArchitecture
import CoreMotion

/// A wrapper around Core Motion's `CMHeadphoneMotionManager` that exposes its functionality
/// through effects and actions, making it easy to use with the Composable Architecture, and easy
/// to test.
@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
public struct HeadphoneMotionManager {

  /// Actions that correspond to `CMHeadphoneMotionManagerDelegate` methods.
  ///
  /// See `CMHeadphoneMotionManagerDelegate` for more information.
  public enum Action: Equatable {
    case didConnect
    case didDisconnect
  }

  /// A publisher of delegate actions.
  var delegate: () -> Effect<Action, Never>

  /// The latest sample of device-motion data.
  var deviceMotion: () -> DeviceMotion?

  /// A Boolean value that determines whether the app is receiving updates from the device-motion
  /// service.
  var isDeviceMotionActive: () -> Bool

  /// A Boolean value that indicates whether the device-motion service is available on the device.
  var isDeviceMotionAvailable: () -> Bool

  /// Starts device-motion updates without a block handler.
  ///
  /// Returns a long-living effect that emits device motion data each time the headphone motion
  /// manager receives a new value.
  var startDeviceMotionUpdates: (OperationQueue) -> Effect<DeviceMotion, Error>

  /// Stops device-motion updates.
  var stopDeviceMotionUpdates: () -> Effect<Never, Never>

  public init(
    delegate: @escaping () -> Effect<Action, Never>,
    deviceMotion: @escaping () -> DeviceMotion?,
    isDeviceMotionActive: @escaping () -> Bool,
    isDeviceMotionAvailable: @escaping () -> Bool,
    startDeviceMotionUpdates: @escaping (OperationQueue) ->
      Effect<DeviceMotion, Error>,
    stopDeviceMotionUpdates: @escaping () -> Effect<Never, Never>
  ) {
    self.delegate = delegate
    self.deviceMotion = deviceMotion
    self.isDeviceMotionActive = isDeviceMotionActive
    self.isDeviceMotionAvailable = isDeviceMotionAvailable
    self.startDeviceMotionUpdates = startDeviceMotionUpdates
    self.stopDeviceMotionUpdates = stopDeviceMotionUpdates
  }
}
