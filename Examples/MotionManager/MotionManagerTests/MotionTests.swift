import Combine
import ComposableArchitecture
import ComposableCoreMotion
import CoreMotion
import XCTest

@testable import MotionManagerDemo

class MotionTests: XCTestCase {
  func testMotionUpdate() {
    let store = TestStore(
      initialState: .init(),
      reducer: appReducer,
      environment: .init(
        motionManager: .failing
      )
    )

    let motionSubject = PassthroughSubject<DeviceMotion, Error>()

    store.environment.motionManager.deviceMotion = { nil }
    store.environment.motionManager.startDeviceMotionUpdates = { _ in
      motionSubject.eraseToEffect()
    }
    store.environment.motionManager.stopDeviceMotionUpdates = {
      .fireAndForget { motionSubject.send(completion: .finished) }
    }

    let deviceMotion = DeviceMotion(
      attitude: .init(quaternion: .init(x: 1, y: 0, z: 0, w: 0)),
      gravity: CMAcceleration(x: 1, y: 2, z: 3),
      heading: 0,
      magneticField: .init(field: .init(x: 0, y: 0, z: 0), accuracy: .high),
      rotationRate: .init(x: 0, y: 0, z: 0),
      timestamp: 0,
      userAcceleration: CMAcceleration(x: 4, y: 5, z: 6)
    )

    store.send(.recordingButtonTapped) {
      $0.isRecording = true
    }

    motionSubject.send(deviceMotion)
    store.receive(.motionUpdate(.success(deviceMotion))) {
      $0.z = [32]
    }

    store.send(.recordingButtonTapped) {
      $0.isRecording = false
    }
  }

  func testFacingDirection() {
    let store = TestStore(
      initialState: .init(),
      reducer: appReducer,
      environment: .init(
        motionManager: .failing
      )
    )

    let motionSubject = PassthroughSubject<DeviceMotion, Error>()

    let initialDeviceMotion = DeviceMotion(
      attitude: .init(quaternion: .init(x: 1, y: 0, z: 0, w: 0)),
      gravity: CMAcceleration(x: 0, y: 0, z: 0),
      heading: 0,
      magneticField: .init(field: .init(x: 0, y: 0, z: 0), accuracy: .high),
      rotationRate: .init(x: 0, y: 0, z: 0),
      timestamp: 0,
      userAcceleration: CMAcceleration(x: 0, y: 0, z: 0)
    )
    var updatedDeviceMotion = initialDeviceMotion
    updatedDeviceMotion.attitude = .init(quaternion: .init(x: 0, y: 0, z: 1, w: 0))

    store.environment.motionManager.deviceMotion = { initialDeviceMotion }
    store.environment.motionManager.startDeviceMotionUpdates = { _ in
      motionSubject.eraseToEffect()
    }
    store.environment.motionManager.stopDeviceMotionUpdates = {
      .fireAndForget { motionSubject.send(completion: .finished) }
    }

    store.send(.recordingButtonTapped) {
      $0.isRecording = true
    }

    motionSubject.send(initialDeviceMotion)
    store.receive(.motionUpdate(.success(initialDeviceMotion))) {
      $0.facingDirection = .forward
      $0.initialAttitude = initialDeviceMotion.attitude
      $0.z = [0]
    }

    motionSubject.send(updatedDeviceMotion)
    store.receive(.motionUpdate(.success(updatedDeviceMotion))) {
      $0.z = [0, 0]
      $0.facingDirection = .backward
    }

    store.send(.recordingButtonTapped) {
      $0.facingDirection = nil
      $0.initialAttitude = nil
      $0.isRecording = false
    }
  }
}
