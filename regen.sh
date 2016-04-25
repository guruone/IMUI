#!/bin/sh

rm -rf Sherlock.xcworkspace Pods Podfile.lock

echo "start reinstall========== "
env PODFILE_TYPE=development pod install --no-repo-update

echo "opening workspace========== "
# sleep 1s
open Sherlock.xcworkspace
