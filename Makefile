.PHONY: build release package

build:
	swift build

release:
	swift build --disable-sandbox -c release

install: release
	cp -f .build/release/lswift /usr/local/bin

package:
	swift package generate-xcodeproj
