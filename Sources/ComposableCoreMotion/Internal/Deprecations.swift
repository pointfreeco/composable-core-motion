import ComposableArchitecture

// NB: Deprecated after 0.1.1

@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
extension HeadphoneMotionManager {
  @available(*, deprecated, message: "Use 'Effect.cancellable' and 'Effect.cancel' to manage the lifecycle of 'HeadphoneMotionManager.delegate'")
  public func create(id: AnyHashable) -> Effect<HeadphoneMotionManager.Action, Never> {
    self.delegate()
      .eraseToEffect()
      .cancellable(id: id)
  }

  @available(*, deprecated, message: "Use 'Effect.cancellable' and 'Effect.cancel' to manage the lifecycle of 'HeadphoneMotionManager.delegate'")
  public func destroy(id: AnyHashable) -> Effect<Never, Never> {
    .cancel(id: id)
  }

  @available(*, unavailable, message: "Use 'HeadphoneMotionManager.failing', instead")
  public static func unimplemented(
    create: @escaping (AnyHashable) -> Effect<Action, Never> = { _ in _unimplemented("create") },
    destroy: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") },
    deviceMotion: @escaping (AnyHashable) -> DeviceMotion? = { _ in _unimplemented("deviceMotion")
    },
    isDeviceMotionActive: @escaping (AnyHashable) -> Bool = { _ in
      _unimplemented("isDeviceMotionActive")
    },
    isDeviceMotionAvailable: @escaping (AnyHashable) -> Bool = { _ in
      _unimplemented("isDeviceMotionAvailable")
    },
    startDeviceMotionUpdates: @escaping (AnyHashable, OperationQueue) ->
      Effect<DeviceMotion, Error> = { _, _ in _unimplemented("startDeviceMotionUpdates") },
    stopDeviceMotionUpdates: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("stopDeviceMotionUpdates")
    }
  ) -> HeadphoneMotionManager {
    fatalError()
  }
}

@available(iOS 4.0, *)
@available(macCatalyst 13.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2.0, *)
extension MotionManager {
  @available(*, deprecated, message: "This endpoint is no longer necessary.")
  public func create(id: AnyHashable) -> Effect<Never, Never> {
    .none
  }

  @available(*, deprecated, message: "This endpoint is no longer necessary.")
  public func destroy(id: AnyHashable) -> Effect<Never, Never> {
    .none
  }

  @available(*, unavailable, message: "Use 'MotionManager.failing', instead")
  public static func unimplemented(
    accelerometerData: @escaping (AnyHashable) -> AccelerometerData? = { _ in
      _unimplemented("accelerometerData")
    },
    attitudeReferenceFrame: @escaping (AnyHashable) -> CMAttitudeReferenceFrame = { _ in
      _unimplemented("attitudeReferenceFrame")
    },
    availableAttitudeReferenceFrames: @escaping () -> CMAttitudeReferenceFrame = {
      _unimplemented("availableAttitudeReferenceFrames")
    },
    create: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("create") },
    destroy: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") },
    deviceMotion: @escaping (AnyHashable) -> DeviceMotion? = { _ in _unimplemented("deviceMotion")
    },
    gyroData: @escaping (AnyHashable) -> GyroData? = { _ in _unimplemented("gyroData") },
    isAccelerometerActive: @escaping (AnyHashable) -> Bool = { _ in
      _unimplemented("isAccelerometerActive")
    },
    isAccelerometerAvailable: @escaping (AnyHashable) -> Bool = { _ in
      _unimplemented("isAccelerometerAvailable")
    },
    isDeviceMotionActive: @escaping (AnyHashable) -> Bool = { _ in
      _unimplemented("isDeviceMotionActive")
    },
    isDeviceMotionAvailable: @escaping (AnyHashable) -> Bool = { _ in
      _unimplemented("isDeviceMotionAvailable")
    },
    isGyroActive: @escaping (AnyHashable) -> Bool = { _ in _unimplemented("isGyroActive") },
    isGyroAvailable: @escaping (AnyHashable) -> Bool = { _ in _unimplemented("isGyroAvailable") },
    isMagnetometerActive: @escaping (AnyHashable) -> Bool = { _ in
      _unimplemented("isMagnetometerActive")
    },
    isMagnetometerAvailable: @escaping (AnyHashable) -> Bool = { _ in
      _unimplemented("isMagnetometerAvailable")
    },
    magnetometerData: @escaping (AnyHashable) -> MagnetometerData? = { _ in
      _unimplemented("magnetometerData")
    },
    set: @escaping (AnyHashable, MotionManager.Properties) -> Effect<Never, Never> = { _, _ in
      _unimplemented("set")
    },
    startAccelerometerUpdates: @escaping (AnyHashable, OperationQueue) -> Effect<
      AccelerometerData, Error
    > = { _, _ in _unimplemented("startAccelerometerUpdates") },
    startDeviceMotionUpdates: @escaping (AnyHashable, CMAttitudeReferenceFrame, OperationQueue) ->
      Effect<DeviceMotion, Error> = { _, _, _ in _unimplemented("startDeviceMotionUpdates") },
    startGyroUpdates: @escaping (AnyHashable, OperationQueue) -> Effect<GyroData, Error> = {
      _, _ in
      _unimplemented("startGyroUpdates")
    },
    startMagnetometerUpdates: @escaping (AnyHashable, OperationQueue) -> Effect<
      MagnetometerData, Error
    > = { _, _ in _unimplemented("startMagnetometerUpdates") },
    stopAccelerometerUpdates: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("stopAccelerometerUpdates")
    },
    stopDeviceMotionUpdates: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("stopDeviceMotionUpdates")
    },
    stopGyroUpdates: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("stopGyroUpdates")
    },
    stopMagnetometerUpdates: @escaping (AnyHashable) -> Effect<Never, Never> = { _ in
      _unimplemented("stopMagnetometerUpdates")
    }
  ) -> MotionManager {
    fatalError()
  }
}
