import Combine
import ComposableArchitecture
import CoreMotion

@available(iOS 4, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2, *)
extension MotionManager {
  public static func live(rawValue manager: CMMotionManager = .init()) -> Self {
    Self(
      accelerometerData: { manager.accelerometerData.map(AccelerometerData.init) },
      attitudeReferenceFrame: { manager.attitudeReferenceFrame },
      availableAttitudeReferenceFrames: CMMotionManager.availableAttitudeReferenceFrames,
      deviceMotion: { manager.deviceMotion.map(DeviceMotion.init) },
      gyroData: { manager.gyroData.map(GyroData.init) },
      isAccelerometerActive: { manager.isAccelerometerActive },
      isAccelerometerAvailable: { manager.isAccelerometerAvailable },
      isDeviceMotionActive: { manager.isDeviceMotionActive },
      isDeviceMotionAvailable: { manager.isDeviceMotionAvailable },
      isGyroActive: { manager.isGyroActive },
      isGyroAvailable: { manager.isGyroAvailable },
      isMagnetometerActive: { manager.isDeviceMotionActive },
      isMagnetometerAvailable: { manager.isMagnetometerAvailable },
      magnetometerData: { manager.magnetometerData.map(MagnetometerData.init) },
      set: { properties in
        .fireAndForget {
          if let accelerometerUpdateInterval = properties.accelerometerUpdateInterval {
            manager.accelerometerUpdateInterval = accelerometerUpdateInterval
          }
          if let deviceMotionUpdateInterval = properties.deviceMotionUpdateInterval {
            manager.deviceMotionUpdateInterval = deviceMotionUpdateInterval
          }
          if let gyroUpdateInterval = properties.gyroUpdateInterval {
            manager.gyroUpdateInterval = gyroUpdateInterval
          }
          if let magnetometerUpdateInterval = properties.magnetometerUpdateInterval {
            manager.magnetometerUpdateInterval = magnetometerUpdateInterval
          }
          if let showsDeviceMovementDisplay = properties.showsDeviceMovementDisplay {
            manager.showsDeviceMovementDisplay = showsDeviceMovementDisplay
          }
        }
      },
      startAccelerometerUpdates: { queue in
        Effect.run { subscriber in
          manager.startAccelerometerUpdates(to: queue) { data, error in
            if let data = data {
              subscriber.send(.init(data))
            } else if let error = error {
              subscriber.send(completion: .failure(error))
            }
          }
          return AnyCancellable {}
        }
      },
      startDeviceMotionUpdates: { frame, queue in
        return Effect.run { subscriber in
          manager.startDeviceMotionUpdates(using: frame, to: queue) { data, error in
            if let data = data {
              subscriber.send(.init(data))
            } else if let error = error {
              subscriber.send(completion: .failure(error))
            }
          }
          return AnyCancellable {}
        }
      },
      startGyroUpdates: { queue in
        Effect.run { subscriber in
          manager.startGyroUpdates(to: queue) { data, error in
            if let data = data {
              subscriber.send(.init(data))
            } else if let error = error {
              subscriber.send(completion: .failure(error))
            }
          }
          return AnyCancellable {}
        }
      },
      startMagnetometerUpdates: { queue in
        Effect.run { subscriber in
          manager.startMagnetometerUpdates(to: queue) { data, error in
            if let data = data {
              subscriber.send(.init(data))
            } else if let error = error {
              subscriber.send(completion: .failure(error))
            }
          }
          return AnyCancellable {}
        }
      },
      stopAccelerometerUpdates: {
        .fireAndForget { manager.stopAccelerometerUpdates() }
      },
      stopDeviceMotionUpdates: {
        .fireAndForget { manager.stopDeviceMotionUpdates() }
      },
      stopGyroUpdates: {
        .fireAndForget { manager.stopGyroUpdates() }
      },
      stopMagnetometerUpdates: {
        .fireAndForget { manager.stopMagnetometerUpdates() }
      }
    )
  }
}
