#!/bin/sh -x

rm Cartfile.resolved
rm -rf ~/Library/Developer/Xcode/DerivedData/PlaygroundWithOSS*

carthage update --no-use-binaries --platform iOS
