import XCTest

@testable import ComposableCoreMotion

class ComposableCoreMotionTests: XCTestCase {
  func testQuaternionInverse() {
    let q = CMQuaternion(x: 1, y: 2, z: 3, w: 4)
    let inv = q.inverse
    let result = q.multiplied(by: inv)

    XCTAssertEqual(result.x, 0)
    XCTAssertEqual(result.y, 0)
    XCTAssertEqual(result.z, 0)
    XCTAssertEqual(result.w, 1)
  }

  func testQuaternionMultiplication() {
    let q1 = CMQuaternion(x: 1, y: 2, z: 3, w: 4)
    let q2 = CMQuaternion(x: -4, y: 3, z: -2, w: 1)
    let result = q1.multiplied(by: q2)

    XCTAssertEqual(result.x, -28)
    XCTAssertEqual(result.y, 4)
    XCTAssertEqual(result.z, 6)
    XCTAssertEqual(result.w, 8)
  }

  func testRollPitchYaw() {
    let q1 = Attitude(quaternion: .init(x: 1, y: 0, z: 0, w: 0))
    let q2 = Attitude(quaternion: .init(x: 0, y: 1, z: 0, w: 0))
    let q3 = Attitude(quaternion: .init(x: 0, y: 0, z: 1, w: 0))
    let q4 = Attitude(quaternion: .init(x: 0, y: 0, z: 0, w: 1))

    XCTAssertEqual(q1.roll, 0)
    XCTAssertEqual(q1.pitch, 180.0)
    XCTAssertEqual(q1.yaw, 0)

    XCTAssertEqual(q2.roll, 0)
    XCTAssertEqual(q2.pitch, 180.0)
    XCTAssertEqual(q2.yaw, 180.0)

    XCTAssertEqual(q3.roll, 0)
    XCTAssertEqual(q3.pitch, 0)
    XCTAssertEqual(q3.yaw, 180.0)

    XCTAssertEqual(q4.roll, 0)
    XCTAssertEqual(q4.pitch, 0)
    XCTAssertEqual(q4.yaw, 0)
  }
  
  func testRotationMatrix() {
    let q = CMQuaternion(x: 1, y: 2, z: 3, w: 4)
    let a = Attitude(quaternion: q)
    
    let m = a.rotationMatrix
    
    XCTAssertEqual(m.m11, 0.13333333, accuracy: 0.0001)
    XCTAssertEqual(m.m12, 0.93333333, accuracy: 0.0001)
    XCTAssertEqual(m.m13, 0.73333333, accuracy: 0.0001)
    
    XCTAssertEqual(m.m21, -0.6666666, accuracy: 0.0001)
    XCTAssertEqual(m.m22, 0.33333333, accuracy: 0.0001)
    XCTAssertEqual(m.m23, 0.66666666, accuracy: 0.0001)

    XCTAssertEqual(m.m31, -0.33333333, accuracy: 0.0001)
    XCTAssertEqual(m.m32, 0.13333333, accuracy: 0.0001)
    XCTAssertEqual(m.m33, 0.66666666, accuracy: 0.0001)
  }

  func testCompability() {
    let q = CMQuaternion(x: -0.000882, y: -0.005251, z: 0.932196, w: -0.361915)
    let a = Attitude(quaternion: q)
    XCTAssertEqual(a.pitch, -0.524317, accuracy: 0.0001)
    XCTAssertEqual(a.roll, 0.312014, accuracy: 0.0001)
    XCTAssertEqual(a.yaw, -137.562226, accuracy: 0.01)
  }
}
