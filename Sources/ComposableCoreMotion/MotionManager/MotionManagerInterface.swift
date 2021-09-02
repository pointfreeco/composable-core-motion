import ComposableArchitecture
import CoreMotion

/// A wrapper around Core Motion's `CMMotionManager` that exposes its functionality through
/// effects and actions, making it easy to use with the Composable Architecture, and easy to test.
///
/// To use in your application, you can add an action to your feature's domain that represents the
/// type of motion data you are interested in receiving. For example, if you only want motion
/// updates, then you can add the following action:
///
/// ```swift
/// import ComposableCoreLocation
///
/// enum FeatureAction {
///   case motionUpdate(Result<DeviceMotion, NSError>)
///
///   // Your feature's other actions:
///   ...
/// }
/// ```
///
/// This action will be sent every time the motion manager receives new device motion data.
///
/// Next, add a `MotionManager` type, which is a wrapper around a `CMMotionManager` that this
/// library provides, to your feature's environment of dependencies:
///
/// ```swift
/// struct FeatureEnvironment {
///   public var motionManager: MotionManager
///
///   // Your feature's other dependencies:
///   ...
/// }
/// ```
///
/// Then, create a motion manager by returning an effect from our reducer. You can either do this
/// when your feature starts up, such as when `onAppear` is invoked, or you can do it when a user
/// action occurs, such as when the user taps a button.
///
/// As an example, say we want to create a motion manager and start listening for motion updates
/// when a "Record" button is tapped. Then we can can do both of those things by executing two
/// effects, one after the other:
///
/// ```swift
/// let featureReducer = Reducer<FeatureState, FeatureAction, FeatureEnvironment> {
///   state, action, environment in
///
///   switch action {
///   case .recordingButtonTapped:
///     return environment.motionManager
///       .startDeviceMotionUpdates(
///         using: .xArbitraryZVertical,
///         to: .main
///       )
///       .mapError { $0 as NSError }
///       .catchToEffect()
///       .map(AppAction.motionUpdate)
///
///   ...
///   }
/// }
/// ```
///
/// After those effects are executed you will get a steady stream of device motion updates sent to
/// the `.motionUpdate` action, which you can handle in the reducer. For example, to compute how
/// much the device is moving up and down we can take the dot product of the device's gravity
/// vector with the device's acceleration vector, and we could store that in the feature's state:
///
/// ```swift
/// case let .motionUpdate(.success(deviceMotion)):
///    state.zs.append(
///      motion.gravity.x * motion.userAcceleration.x
///        + motion.gravity.y * motion.userAcceleration.y
///        + motion.gravity.z * motion.userAcceleration.z
///    )
///
/// case let .motionUpdate(.failure(error)):
///   // Do something with the motion update failure, like show an alert.
/// ```
///
/// And then later, if you want to stop receiving motion updates, such as when a "Stop" button is
/// tapped, we can execute an effect to stop the motion manager:
///
/// ```swift
/// case .stopButtonTapped:
///   return environment.motionManager
///     .stopDeviceMotionUpdates()
///     .fireAndForget()
/// ```
///
/// That is enough to implement a basic application that interacts with Core Motion.
///
/// But the true power of building your application and interfacing with Core Motion this way is
/// the ability to instantly _test_ how your application behaves with Core Motion. We start by
/// creating a `TestStore` whose environment contains an `.unimplemented` version of the
/// `MotionManager`. The `.unimplemented` function allows you to create a fully controlled version
/// of the motion manager that does not deal with a real `CMMotionManager` at all. Instead, you
/// override whichever endpoints your feature needs to supply deterministic functionality.
///
/// For example, let's test that we property start the motion manager when we tap the record
/// button, and that we compute the z-motion correctly, and further that we stop the motion
/// manager when we tap the stop button. We can construct a `TestStore` with a mock motion manager
/// that keeps track of when the manager is created and destroyed, and further we can even
/// substitute in a subject that we control for device motion updates. This allows us to send any
/// data we want to for the device motion.
///
/// ```swift
/// func testFeature() {
///   let motionSubject = PassthroughSubject<DeviceMotion, Error>()
///
///   let store = TestStore(
///     initialState: .init(),
///     reducer: appReducer,
///     environment: .init(
///       motionManager: .failing
///     )
///   )
///
///   store.environment.motionManager.startDeviceMotionUpdates: { _, _ in
///     motionSubject.eraseToEffect()
///   }
///   store.environment.motionManager.stopDeviceMotionUpdates: {
///     .fireAndForget { motionSubject.send(completion: .finished) }
///   }
///
/// }
/// ```
///
/// We can then make an assertion on our store that plays a basic user script. We can simulate the
/// situation in which a user taps the record button, then some device motion data is received,
/// and finally the user taps the stop button. During that script of user actions we expect the
/// motion manager to be started, then for some z-motion values to be accumulated, and finally for
/// the motion manager to be stopped:
///
/// ```swift
/// let deviceMotion = DeviceMotion(
///   attitude: .init(quaternion: .init(x: 1, y: 0, z: 0, w: 0)),
///   gravity: CMAcceleration(x: 1, y: 2, z: 3),
///   heading: 0,
///   magneticField: .init(field: .init(x: 0, y: 0, z: 0), accuracy: .high),
///   rotationRate: .init(x: 0, y: 0, z: 0),
///   timestamp: 0,
///   userAcceleration: CMAcceleration(x: 4, y: 5, z: 6)
/// )
///
/// store.send(.recordingButtonTapped)
///
/// motionSubject.send(deviceMotion)
/// store.receive(.motionUpdate(.success(deviceMotion))) {
///   $0.zs = [32]
/// }
///
/// store.send(.stopButtonTapped)
/// ```
///
/// This is only the tip of the iceberg. We can access any part of the `CMMotionManager` API in
/// this way, and instantly unlock testability with how the motion functionality integrates with
/// our core application logic. This can be incredibly powerful, and is typically not the kind of
/// thing one can test easily.
@available(iOS 4.0, *)
@available(macCatalyst 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2.0, *)
public struct MotionManager {
  /// The latest sample of accelerometer data.
  public var accelerometerData: () -> AccelerometerData?

  /// Returns either the reference frame currently being used or the default attitude reference
  /// frame.
  public var attitudeReferenceFrame: () -> CMAttitudeReferenceFrame

  /// Returns a bitmask specifying the available attitude reference frames on the device.
  public var availableAttitudeReferenceFrames: () -> CMAttitudeReferenceFrame

  /// The latest sample of device-motion data.
  public var deviceMotion: () -> DeviceMotion?

  /// The latest sample of gyroscope data.
  public var gyroData: () -> GyroData?

  /// A Boolean value that indicates whether accelerometer updates are currently happening.
  public var isAccelerometerActive: () -> Bool

  /// A Boolean value that indicates whether an accelerometer is available on the device.
  public var isAccelerometerAvailable: () -> Bool

  /// A Boolean value that determines whether the app is receiving updates from the device-motion
  /// service.
  public var isDeviceMotionActive: () -> Bool

  /// A Boolean value that indicates whether the device-motion service is available on the device.
  public var isDeviceMotionAvailable: () -> Bool

  /// A Boolean value that determines whether gyroscope updates are currently happening.
  public var isGyroActive: () -> Bool

  /// A Boolean value that indicates whether a gyroscope is available on the device.
  public var isGyroAvailable: () -> Bool

  /// A Boolean value that determines whether magnetometer updates are currently happening.
  public var isMagnetometerActive: () -> Bool

  /// A Boolean value that indicates whether a magnetometer is available on the device.
  public var isMagnetometerAvailable: () -> Bool

  /// The latest sample of magnetometer data.
  public var magnetometerData: () -> MagnetometerData?

  /// Sets certain properties on the motion manager.
  public var set: (Properties) -> Effect<Never, Never>

  public var startAccelerometerUpdates: () -> Effect<AccelerometerData, Error>

  public var startDeviceMotionUpdates: (CMAttitudeReferenceFrame) -> Effect<DeviceMotion, Error>

  public var startGyroUpdates: () -> Effect<GyroData, Error>

  public var startMagnetometerUpdates: () -> Effect<MagnetometerData, Error>

  /// Stops accelerometer updates.
  public var stopAccelerometerUpdates: () -> Effect<Never, Never>

  /// Stops device-motion updates.
  public var stopDeviceMotionUpdates: () -> Effect<Never, Never>

  /// Stops gyroscope updates.
  public var stopGyroUpdates: () -> Effect<Never, Never>

  /// Stops magnetometer updates.
  public var stopMagnetometerUpdates: () -> Effect<Never, Never>

  public init(
    accelerometerData: @escaping () -> AccelerometerData?,
    attitudeReferenceFrame: @escaping () -> CMAttitudeReferenceFrame,
    availableAttitudeReferenceFrames: @escaping () -> CMAttitudeReferenceFrame,
    deviceMotion: @escaping () -> DeviceMotion?,
    gyroData: @escaping () -> GyroData?,
    isAccelerometerActive: @escaping () -> Bool,
    isAccelerometerAvailable: @escaping () -> Bool,
    isDeviceMotionActive: @escaping () -> Bool,
    isDeviceMotionAvailable: @escaping () -> Bool,
    isGyroActive: @escaping () -> Bool,
    isGyroAvailable: @escaping () -> Bool,
    isMagnetometerActive: @escaping () -> Bool,
    isMagnetometerAvailable: @escaping () -> Bool,
    magnetometerData: @escaping () -> MagnetometerData?,
    set: @escaping (Properties) -> Effect<Never, Never>,
    startAccelerometerUpdates: @escaping () -> Effect<AccelerometerData, Error>,
    startDeviceMotionUpdates: @escaping (CMAttitudeReferenceFrame) -> Effect<DeviceMotion, Error>,
    startGyroUpdates: @escaping () -> Effect<GyroData, Error>,
    startMagnetometerUpdates: @escaping () -> Effect<MagnetometerData, Error>,
    stopAccelerometerUpdates: @escaping () -> Effect<Never, Never>,
    stopDeviceMotionUpdates: @escaping () -> Effect<Never, Never>,
    stopGyroUpdates: @escaping () -> Effect<Never, Never>,
    stopMagnetometerUpdates: @escaping () -> Effect<Never, Never>
  ) {
    self.accelerometerData = accelerometerData
    self.attitudeReferenceFrame = attitudeReferenceFrame
    self.availableAttitudeReferenceFrames = availableAttitudeReferenceFrames
    self.deviceMotion = deviceMotion
    self.gyroData = gyroData
    self.isAccelerometerActive = isAccelerometerActive
    self.isAccelerometerAvailable = isAccelerometerAvailable
    self.isDeviceMotionActive = isDeviceMotionActive
    self.isDeviceMotionAvailable = isDeviceMotionAvailable
    self.isGyroActive = isGyroActive
    self.isGyroAvailable = isGyroAvailable
    self.isMagnetometerActive = isMagnetometerActive
    self.isMagnetometerAvailable = isMagnetometerAvailable
    self.magnetometerData = magnetometerData
    self.set = set
    self.startAccelerometerUpdates = startAccelerometerUpdates
    self.startDeviceMotionUpdates = startDeviceMotionUpdates
    self.startGyroUpdates = startGyroUpdates
    self.startMagnetometerUpdates = startMagnetometerUpdates
    self.stopAccelerometerUpdates = stopAccelerometerUpdates
    self.stopDeviceMotionUpdates = stopDeviceMotionUpdates
    self.stopGyroUpdates = stopGyroUpdates
    self.stopMagnetometerUpdates = stopMagnetometerUpdates
  }

  /// Sets certain properties on the motion manager.
  public func set(
    accelerometerUpdateInterval: TimeInterval? = nil,
    deviceMotionUpdateInterval: TimeInterval? = nil,
    gyroUpdateInterval: TimeInterval? = nil,
    magnetometerUpdateInterval: TimeInterval? = nil,
    showsDeviceMovementDisplay: Bool? = nil
  ) -> Effect<Never, Never> {
    self.set(
      .init(
        accelerometerUpdateInterval: accelerometerUpdateInterval,
        deviceMotionUpdateInterval: deviceMotionUpdateInterval,
        gyroUpdateInterval: gyroUpdateInterval,
        magnetometerUpdateInterval: magnetometerUpdateInterval,
        showsDeviceMovementDisplay: showsDeviceMovementDisplay
      )
    )
  }

  public struct Properties {
    public var accelerometerUpdateInterval: TimeInterval?
    public var deviceMotionUpdateInterval: TimeInterval?
    public var gyroUpdateInterval: TimeInterval?
    public var magnetometerUpdateInterval: TimeInterval?
    public var showsDeviceMovementDisplay: Bool?

    public init(
      accelerometerUpdateInterval: TimeInterval? = nil,
      deviceMotionUpdateInterval: TimeInterval? = nil,
      gyroUpdateInterval: TimeInterval? = nil,
      magnetometerUpdateInterval: TimeInterval? = nil,
      showsDeviceMovementDisplay: Bool? = nil
    ) {
      self.accelerometerUpdateInterval = accelerometerUpdateInterval
      self.deviceMotionUpdateInterval = deviceMotionUpdateInterval
      self.gyroUpdateInterval = gyroUpdateInterval
      self.magnetometerUpdateInterval = magnetometerUpdateInterval
      self.showsDeviceMovementDisplay = showsDeviceMovementDisplay
    }
  }
}
