import ComposableArchitecture

@available(iOS 4, *)
@available(macCatalyst 13, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS 2, *)
extension MotionManager {
  public static let failing = Self(
    accelerometerData: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.accelerometerData'")
      return nil
    },
    attitudeReferenceFrame: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.attitudeReferenceFrame'")
      return []
    },
    availableAttitudeReferenceFrames: {
      XCTFail(
        "A failing endpoint was accessed: 'HeadphoneMotionManager.availableAttitudeReferenceFrames'"
      )
      return []
    },
    deviceMotion: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.deviceMotion'")
      return nil
    },
    gyroData: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.gyroData'")
      return nil
    },
    isAccelerometerActive: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isAccelerometerActive'")
      return false
    },
    isAccelerometerAvailable: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isAccelerometerAvailable'")
      return false
    },
    isDeviceMotionActive: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isDeviceMotionActive'")
      return false
    },
    isDeviceMotionAvailable: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isDeviceMotionAvailable'")
      return false
    },
    isGyroActive: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isGyroActive'")
      return false
    },
    isGyroAvailable: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isGyroAvailable'")
      return false
    },
    isMagnetometerActive: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isMagnetometerActive'")
      return false
    },
    isMagnetometerAvailable: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.isMagnetometerAvailable'")
      return false
    },
    magnetometerData: {
      XCTFail("A failing endpoint was accessed: 'HeadphoneMotionManager.magnetometerData'")
      return nil
    },
    set: { _ in .failing("MotionManager.set") },
    startAccelerometerUpdates: { _ in .failing("MotionManager.startAccelerometerUpdates") },
    startDeviceMotionUpdates: { _, _ in .failing("MotionManager.startDeviceMotionUpdates") },
    startGyroUpdates: { _ in .failing("MotionManager.startGyroUpdates") },
    startMagnetometerUpdates: { _ in .failing("MotionManager.startMagnetometerUpdates") },
    stopAccelerometerUpdates: { .failing("MotionManager.stopAccelerometerUpdates") },
    stopDeviceMotionUpdates: { .failing("MotionManager.stopDeviceMotionUpdates") },
    stopGyroUpdates: { .failing("MotionManager.stopGyroUpdates") },
    stopMagnetometerUpdates: { .failing("MotionManager.stopMagnetometerUpdates") }
  )
}
