import ComposableArchitecture
import CoreMotion
import XCTest

@testable import ComposableCoreMotion

class RotationTests: XCTestCase {
  func makeQuaternion(_ pitch: Double, _ roll: Double, _ yaw: Double) -> CMQuaternion {
    let qx = sin(pitch/2) * cos(roll/2) * cos(yaw/2)
    let qy = cos(pitch/2) * sin(roll/2) * cos(yaw/2)
    let qz = cos(pitch/2) * cos(roll/2) * sin(yaw/2)
    let qw = cos(pitch/2) * cos(roll/2) * cos(yaw/2)
    
    let q = CMQuaternion(x: qx, y: qy, z: qz, w: qw)
    return q
  }
  
  func testMakeQuaternion() {
    let q1 = makeQuaternion(.pi, 0, 0)
    XCTAssertEqual(q1.x, 1, accuracy: 1e-15)
    XCTAssertEqual(q1.y, 0, accuracy: 1e-15)
    XCTAssertEqual(q1.z, 0, accuracy: 1e-15)
    XCTAssertEqual(q1.w, 0, accuracy: 1e-15)
    
    let q2 = makeQuaternion(0,.pi, 0)
    XCTAssertEqual(q2.x, 0, accuracy: 1e-15)
    XCTAssertEqual(q2.y, 1, accuracy: 1e-15)
    XCTAssertEqual(q2.z, 0, accuracy: 1e-15)
    XCTAssertEqual(q2.w, 0, accuracy: 1e-15)
    
    let q3 = makeQuaternion(0, 0, .pi)
    XCTAssertEqual(q3.x, 0, accuracy: 1e-15)
    XCTAssertEqual(q3.y, 0, accuracy: 1e-15)
    XCTAssertEqual(q3.z, 1, accuracy: 1e-15)
    XCTAssertEqual(q3.w, 0, accuracy: 1e-15)
  }
  
  func testPitch() {
    let q = makeQuaternion(.pi/2, 0, 0)
    let a = Attitude(quaternion: q)
    
    XCTAssertEqual(a.pitch, .pi/2, accuracy: 1e-15)
    XCTAssertEqual(a.roll, 0)
    XCTAssertEqual(a.yaw, 0)
    
    let r = a.rotationMatrix
    
    XCTAssertEqual(r.m11,  1, accuracy: 1e-15)
    XCTAssertEqual(r.m21,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m31,  0, accuracy: 1e-15)

    XCTAssertEqual(r.m12,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m22,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m32, -1, accuracy: 1e-15)

    XCTAssertEqual(r.m13,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m23,  1, accuracy: 1e-15)
    XCTAssertEqual(r.m33,  0, accuracy: 1e-15)
    
  }
  
  func testPitch2() {
    let q = makeQuaternion(.pi/4, 0, 0)
    let a = Attitude(quaternion: q)
    
    XCTAssertEqual(a.pitch, .pi/4, accuracy: 1e-15)
    XCTAssertEqual(a.roll, 0)
    XCTAssertEqual(a.yaw, 0)
    
    let r = a.rotationMatrix
    
    XCTAssertEqual(r.m11,  1, accuracy: 1e-15)
    XCTAssertEqual(r.m21,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m31,  0, accuracy: 1e-15)

    XCTAssertEqual(r.m12,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m22,  sqrt(2)/2, accuracy: 1e-15)
    XCTAssertEqual(r.m32, -sqrt(2)/2, accuracy: 1e-15)

    XCTAssertEqual(r.m13,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m23,  sqrt(2)/2, accuracy: 1e-15)
    XCTAssertEqual(r.m33,  sqrt(2)/2, accuracy: 1e-15)
    
  }
  
  func testRoll() {
    let q = makeQuaternion(0, .pi/2, 0)
    let a = Attitude(quaternion: q)
    
    XCTAssertEqual(a.pitch, 0)
    XCTAssertEqual(a.roll, .pi/2, accuracy: 1e-15)
    XCTAssertEqual(a.yaw, 0)
    
    let r = a.rotationMatrix
    
    XCTAssertEqual(r.m11,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m21,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m31,  1, accuracy: 1e-15)

    XCTAssertEqual(r.m12,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m22,  1, accuracy: 1e-15)
    XCTAssertEqual(r.m32,  0, accuracy: 1e-15)

    XCTAssertEqual(r.m13, -1, accuracy: 1e-15)
    XCTAssertEqual(r.m23,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m33,  0, accuracy: 1e-15)
  }
  
  func testRoll2() {
    let q = makeQuaternion(0, .pi/4, 0)
    let a = Attitude(quaternion: q)
    
    XCTAssertEqual(a.pitch, 0)
    XCTAssertEqual(a.roll, .pi/4, accuracy: 1e-15)
    XCTAssertEqual(a.yaw, 0)
    
    let r = a.rotationMatrix
    
    XCTAssertEqual(r.m11,  sqrt(2)/2, accuracy: 1e-15)
    XCTAssertEqual(r.m21,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m31,  sqrt(2)/2, accuracy: 1e-15)

    XCTAssertEqual(r.m12,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m22,  1, accuracy: 1e-15)
    XCTAssertEqual(r.m32,  0, accuracy: 1e-15)

    XCTAssertEqual(r.m13, -sqrt(2)/2, accuracy: 1e-15)
    XCTAssertEqual(r.m23,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m33,  sqrt(2)/2, accuracy: 1e-15)
  }
  
  func testYaw() {
    let q = makeQuaternion(0, 0, .pi/2)
    let a = Attitude(quaternion: q)
    
    XCTAssertEqual(a.pitch, 0)
    XCTAssertEqual(a.roll, 0)
    XCTAssertEqual(a.yaw, .pi/2, accuracy: 1e-15)
    
    let r = a.rotationMatrix
    
    XCTAssertEqual(r.m11,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m21, -1, accuracy: 1e-15)
    XCTAssertEqual(r.m31,  0, accuracy: 1e-15)

    XCTAssertEqual(r.m12,  1, accuracy: 1e-15)
    XCTAssertEqual(r.m22,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m32,  0, accuracy: 1e-15)

    XCTAssertEqual(r.m13,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m23,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m33,  1, accuracy: 1e-15)
  }
  
  func testYaw2() {
    let q = makeQuaternion(0, 0, .pi/4)
    let a = Attitude(quaternion: q)
    
    XCTAssertEqual(a.pitch, 0)
    XCTAssertEqual(a.roll, 0)
    XCTAssertEqual(a.yaw, .pi/4, accuracy: 1e-15)
    
    let r = a.rotationMatrix
    
    XCTAssertEqual(r.m11,  sqrt(2)/2, accuracy: 1e-15)
    XCTAssertEqual(r.m21, -sqrt(2)/2, accuracy: 1e-15)
    XCTAssertEqual(r.m31,  0, accuracy: 1e-15)

    XCTAssertEqual(r.m12,  sqrt(2)/2, accuracy: 1e-15)
    XCTAssertEqual(r.m22,  sqrt(2)/2, accuracy: 1e-15)
    XCTAssertEqual(r.m32,  0, accuracy: 1e-15)

    XCTAssertEqual(r.m13,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m23,  0, accuracy: 1e-15)
    XCTAssertEqual(r.m33,  1, accuracy: 1e-15)
  }
}
