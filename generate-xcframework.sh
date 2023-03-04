#!/bin/bash

# To create a xcframework out of a SPM project.
# 1. Create a xcode proj out it. by using the commnd swift package generate-xcodeproj
# 2. Open the xcode project and check locally if the project is building.
# 3. You might need to add the iOS plaform as target and validate scheme name.
# 4. Ensure that in build settings "Build Libraries for Distribution" is set to Yes, "Skip Install" is set to Yes
# 5. In the next scripts we build the xcarchive from the project. once for simulator and another time for real device
# 6. Finally run the create xcframework command to create a universally distributed binary for our project.


xcodebuild archive -project ABSteppedProgressBar.xcodeproj -scheme ABSteppedProgressBar -destination "generic/platform=iOS" -archivePath "build/ABSteppedProgressBar-iOS"

xcodebuild archive -project ABSteppedProgressBar.xcodeproj -scheme ABSteppedProgressBar -destination "generic/platform=iOS Simulator" -archivePath "build/ABSteppedProgressBar-iOS_Simulator"

xcodebuild -create-xcframework -archive build/ABSteppedProgressBar-iOS.xcarchive -framework ABSteppedProgressBar.framework -archive build/ABSteppedProgressBar-iOS_Simulator.xcarchive -framework ABSteppedProgressBar.framework -output build/ABSteppedProgressBar.xcframework