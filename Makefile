PLATFORM_IOS = iOS Simulator,name=iPhone 11 Pro Max
PLATFORM_MACOS = macOS
PLATFORM_WATCHOS = watchOS Simulator,name=Apple Watch Series 4 - 44mm

default: test

test:
	xcodebuild test \
		-scheme ComposableCoreMotion \
		-destination platform="$(PLATFORM_IOS)"
	xcodebuild test \
		-scheme ComposableCoreMotion \
		-destination platform="$(PLATFORM_MACOS)"
	xcodebuild \
		-scheme ComposableCoreMotion_watchOS \
		-destination platform="$(PLATFORM_WATCHOS)"
	cd Examples/MotionManager
		&& xcodebuild test \
		-scheme MotionManager \
		-destination platform="$(PLATFORM_IOS)"

format:
	swift format --in-place --recursive \
		./Examples ./Package.swift ./Sources ./Tests

.PHONY: format test
