.PHONY: build release package

SRC?=.build/release/lswift
DST?=/usr/local/bin

build:
	swift build

release:
	swift build --disable-sandbox -c release

install: release
	cp -f ${SRC} ${DST}

package:
	swift package generate-xcodeproj
