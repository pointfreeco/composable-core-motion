#if compiler(>=5.3) && (os(iOS) || os(watchOS) || targetEnvironment(macCatalyst))
  import Combine
  import ComposableArchitecture
  import CoreMotion

  @available(iOS 14, *)
  @available(macCatalyst 14, *)
  @available(macOS, unavailable)
  @available(tvOS, unavailable)
  @available(watchOS 7, *)
  extension HeadphoneMotionManager {
    public static var live: Self {
      let manager = CMHeadphoneMotionManager()

      let delegate = Effect<Action, Never>.run { subscriber in
        let delegate = Delegate(subscriber)
        manager.delegate = delegate

        return AnyCancellable {
          _ = delegate
        }
      }
      .share()
      .eraseToEffect()

      return Self(
        delegate: { delegate },
        deviceMotion: { manager.deviceMotion.map(DeviceMotion.init) },
        isDeviceMotionActive: { manager.isDeviceMotionActive },
        isDeviceMotionAvailable: { manager.isDeviceMotionAvailable },
        startDeviceMotionUpdates: { queue in
          Effect.run { subscriber in
            manager.startDeviceMotionUpdates(to: queue) { data, error in
              if let data = data {
                subscriber.send(.init(data))
              } else if let error = error {
                subscriber.send(completion: .failure(error))
              }
            }
            return AnyCancellable {}
          }
        },
        stopDeviceMotionUpdates: {
          .fireAndForget { manager.stopDeviceMotionUpdates() }
        }
      )
    }

    private class Delegate: NSObject, CMHeadphoneMotionManagerDelegate {
      let subscriber: Effect<HeadphoneMotionManager.Action, Never>.Subscriber

      init(_ subscriber: Effect<HeadphoneMotionManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
      }

      func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        self.subscriber.send(.didConnect)
      }

      func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        self.subscriber.send(.didDisconnect)
      }
    }
  }
#endif
