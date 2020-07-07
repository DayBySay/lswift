.PHONY: build release package

build:
	swift build

release:
	swift build --disable-sandbox -c release

package:
	swift package generate-xcodeproj
