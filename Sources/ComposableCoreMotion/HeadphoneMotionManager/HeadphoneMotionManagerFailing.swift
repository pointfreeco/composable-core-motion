import ComposableArchitecture
import XCTestDynamicOverlay

@available(iOS 14, *)
@available(macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 7, *)
extension HeadphoneMotionManager {
  public static let failing = Self(
    delegate: { .failing("HeadphoneMotionManager.delegate") },
    deviceMotion: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.deviceMotion'")
      return nil
    },
    isDeviceMotionActive: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isDeviceMotionActive'")
      return false
    },
    isDeviceMotionAvailable: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isDeviceMotionAvailable'")
      return false
    },
    startDeviceMotionUpdates: { .failing("HeadphoneMotionManager.startDeviceMotionUpdates") },
    stopDeviceMotionUpdates: { .failing("HeadphoneMotionManager.stopDeviceMotionUpdates") }
  )
}
