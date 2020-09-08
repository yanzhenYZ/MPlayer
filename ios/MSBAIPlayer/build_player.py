#!/usr/bin/env python
# -*- coding:utf-8 -*-
# build_player.py

"""
1. python build_player.py: build MSBPlayer.xcodeproj and MSBAIPlayerSimulators.xcodeproj
2. ./build_player.py:      build MSBPlayer.xcodeproj and MSBAIPlayerSimulators.xcodeproj

More
3. python build_player.py ...: build MSBPlayer、MSBAIPlayerSimulators and MSBAVMedia.xcodeproj
4. ./build_player.py ...:      build MSBPlayer、MSBAIPlayerSimulators and MSBAVMedia.xcodeproj
"""

SIMULATORSFILE="build/Release-iphonesimulator/MSBAIPlayerSimulators.framework/MSBAIPlayerSimulators"
IPHONEOSFILE="../../Frameworks/player/MSBPlayer.framework/MSBPlayer"

import sys, os

def _buildMSBPlayer():
    _buildProj("MSBPlayer.xcodeproj")
    _buildProj("MSBAIPlayerSimulators.xcodeproj", "iphonesimulator")
    #create
    command = "lipo -create %s %s -output %s" % (SIMULATORSFILE, IPHONEOSFILE, IPHONEOSFILE)
    _systemCommand(command)
    command = "rm -rf build/"
    _systemCommand(command)
    
def _buildMSBAVMedia():
    _buildProj("MSBAVMedia/MSBAVMedia.xcodeproj")

def _buildProj(proj, sdk="iphoneos"):
    command = "xcodebuild clean -project %s -sdk %s -configuration Release" % (proj, sdk)
    _systemCommand(command)
    command = "xcodebuild -project %s -sdk %s -configuration Release" % (proj, sdk)
    _systemCommand(command)

def _systemCommand(command):
    if os.system(command) != 0:
        print('Error: ' + command)
        sys.exit(0)


def main():
    argvs = len(sys.argv)
    if argvs == 1:
        _buildMSBPlayer()
    else:
        _buildMSBAVMedia()
        _buildMSBPlayer()
    return 0


if __name__ == '__main__':
    sys.exit(main())
