# Composable Core Motion

[![CI](https://github.com/pointfreeco/composable-core-motion/workflows/CI/badge.svg)](https://github.com/pointfreeco/composable-core-motion/actions?query=workflow%3ACI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fcomposable-core-motion%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/pointfreeco/composable-core-motion)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fpointfreeco%2Fcomposable-core-motion%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/pointfreeco/composable-core-motion)

Composable Core Motion is library that bridges [the Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) and [Core Motion](https://developer.apple.com/documentation/coremotion).

* [Example](#example)
* [Basic usage](#basic-usage)
* [Installation](#installation)
* [Documentation](#documentation)
* [Help](#help)

## Example

Check out the [MotionManager](./Examples/MotionManager) demo to see ComposableCoreMotion in practice.

## Basic Usage

To use ComposableCoreMotion your application, you can add an action to your feature's domain that represents the type of motion data you are interested in receiving. For example, if you only want motion updates, then you can add the following action:

```swift
import ComposableCoreMotion

enum FeatureAction {
  case motionUpdate(Result<DeviceMotion, NSError>)

  // Your feature's other actions:
  ...
}
```

This action will be sent every time the motion manager receives new device motion data.

Next, add a `MotionManager` type, which is a wrapper around a `CMMotionManager` that this library provides, to your feature's environment of dependencies:

```swift
struct FeatureEnvironment {
  var motionManager: MotionManager

  // Your feature's other dependencies:
  ...
}
```

Then, start listening to a motion manager's updates by returning an effect from our reducer. You can either do this when your feature starts up, such as when `onAppear` is invoked, or you can do it when a user action occurs, such as when the user taps a button.

As an example, say we want to start listening for motion updates when a "Record" button is tapped.

```swift
let featureReducer = Reducer<FeatureState, FeatureAction, FeatureEnvironment> {
  state, action, environment in

  switch action {
  case .recordingButtonTapped:
    return environment.motionManager
      .startDeviceMotionUpdates(.xArbitraryZVertical)
      .mapError { $0 as NSError }
      .catchToEffect()
      .map(AppAction.motionUpdate)

  ...
  }
}
```

After those effects are executed you will get a steady stream of device motion updates sent to the `.motionUpdate` action, which you can handle in the reducer. For example, to compute how much the device is moving up and down we can take the dot product of the device's gravity vector with the device's acceleration vector, and we could store that in the feature's state:

```swift
case let .motionUpdate(.success(deviceMotion)):
   state.zs.append(
     motion.gravity.x * motion.userAcceleration.x
       + motion.gravity.y * motion.userAcceleration.y
       + motion.gravity.z * motion.userAcceleration.z
   )

case let .motionUpdate(.failure(error)):
  // Do something with the motion update failure, like show an alert.
```

And then later, if you want to stop receiving motion updates, such as when a "Stop" button is tapped, we can execute an effect to stop the motion manager:

```swift
case .stopButtonTapped:
  return environment.motionManager
    .stopDeviceMotionUpdates()
    .fireAndForget()
```

That is enough to implement a basic application that interacts with Core Motion.

But the true power of building your application and interfacing with Core Motion this way is the ability to instantly _test_ how your application behaves with Core Motion. We start by creating a `TestStore` whose environment contains an `.unimplemented` version of the `MotionManager`. The `.failing` motion manager allows you to override whichever endpoints your feature needs to supply deterministic functionality.

For example, let's test that we property start the motion manager when we tap the record button, and that we compute the z-motion correctly, and further that we stop the motion manager when we tap the stop button. We can construct a `TestStore` with a failing motion manager, and we can substitute in a subject that we control for device motion updates. This allows us to send any data we want to for the device motion.

```swift
func testFeature() {
  let motionSubject = PassthroughSubject<DeviceMotion, Error>()
  var motionManagerIsLive = false

  let store = TestStore(
    initialState: .init(),
    reducer: appReducer,
    environment: .init(
      motionManager: .failing
    )
  )
  
  store.environment.motionManager.startDeviceMotionUpdates = { _ in 
    motionSubject.eraseToEffect()
  }
  store.environment.motionManager.stopDeviceMotionUpdates: { _ in
    .fireAndForget { motionSubject.send(completion: .finished) }
  }

}
```

We can then make an assertion on our store that plays a basic user script. We can simulate the situation in which a user taps the record button, then some device motion data is received, and finally the user taps the stop button. During that script of user actions we expect the motion manager to be started, then for some z-motion values to be accumulated, and finally for the motion manager to be stopped:

```swift
let deviceMotion = DeviceMotion(
  attitude: .init(quaternion: .init(x: 1, y: 0, z: 0, w: 0)),
  gravity: CMAcceleration(x: 1, y: 2, z: 3),
  heading: 0,
  magneticField: .init(field: .init(x: 0, y: 0, z: 0), accuracy: .high),
  rotationRate: .init(x: 0, y: 0, z: 0),
  timestamp: 0,
  userAcceleration: CMAcceleration(x: 4, y: 5, z: 6)
)

store.send(.recordingButtonTapped)

motionSubject.send(deviceMotion)
store.receive(.motionUpdate(.success(deviceMotion))) {
  $0.zs = [32]
}

store.send(.stopButtonTapped)
```

This is only the tip of the iceberg. We can access any part of the `CMMotionManager` API in this way, and instantly unlock testability with how the motion functionality integrates with our core application logic. This can be incredibly powerful, and is typically not the kind of thing one can test easily.

## Installation

You can add ComposableCoreMotion to an Xcode project by adding it as a package dependency.

  1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
  2. Enter "https://github.com/pointfreeco/composable-core-motion" into the package repository URL text field

## Documentation

The latest documentation for the Composable Core Motion APIs is available [here](https://pointfreeco.github.io/composable-core-motion/).

## Help

If you want to discuss Composable Core Motion and the Composable Architecture, or have a question about how to use them to solve a particular problem, ask around on [its Swift forum](https://forums.swift.org/c/related-projects/swift-composable-architecture).

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
