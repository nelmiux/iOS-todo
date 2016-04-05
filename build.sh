#!/bin/bash

# **** Update me when new Xcode versions are released! ****
PLATFORM="platform=iOS Simulator,OS=9.3,name=iPhone 6"
SDK="iphonesimulator9.3"

# It is pitch black.
set -e
function trap_handler() {
    echo -e "\n\nOh no! You walked directly into the slavering fangs of a lurking grue!"
    echo "**** You have died ****"
    exit 255
}
trap trap_handler INT TERM EXIT

MODE="$1"

if [ "$MODE" = "run" ]; then
    echo "Building and testing all todo"
    echo "Building todo"
    xcodebuild \
      -project Pods/Charts/Charts.xcodeproj
      -workspace "todo.xcworkspace" \
      -scheme todo-scheme \
      -sdk "$SDK" \
      -destination "$PLATFORM" \
    trap - EXIT
    exit 0
fi

if [ "$MODE" = "test" ]; then
    trap - EXIT
    exit 0
fi

echo "Unrecognised mode '$MODE'."
