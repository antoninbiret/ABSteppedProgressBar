# ABSteppedProgressBar 

[![Build Status](https://travis-ci.org/antoninbiret/ABSteppedProgressBar.svg?branch=master)](https://travis-ci.org/antoninbiret/ABSteppedProgressBar)
[![Version](https://img.shields.io/badge/Version-0.2.3-orange.svg?style=flat)](http://cocoapods.org/pods/ABSteppedProgressBar)
[![License](https://img.shields.io/badge/License-MIT-orange.svg?style=flat)](http://cocoapods.org/pods/ABSteppedProgressBar)
[![Platform](https://img.shields.io/badge/platform-iOS_9.0-orange.svg?style=flat)](http://cocoapods.org/pods/ABSteppedProgressBar)
![](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)
![](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange.svg?style=flat)

![ABSteppedProgressBar](https://raw.githubusercontent.com/antoninbiret/ABSteppedProgressBar/master/screenshot.gif)

ABSteppedProgressBar is animated and customisable stepped progress bar for iOS written in Swift.

## Example

First thing is to import the framework. See the Installation instructions, on how to add the framework to your project.

Run the Exemple project to see it in action !

## Requirements

ABSteppedProgressBar requires at least iOS 9 or above.

## Installation

### CocoaPods

### [CocoaPods](http://cocoapods.org/)
At this time, CocoaPods support for Swift frameworks is supported in a [pre-release](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/).

To use ABSteppedProgressBar in your project add the following 'Podfile' to your project

```
source 'https://github.com/CocoaPods/Specs.git'

pod 'ABSteppedProgressBar'
```

Run:

pod install

Then, import the module :

```swift
import ABSteppedProgressBar
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding Device as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/antoninbiret/ABSteppedProgressBar.git", from: "0.2.3")
]
```

## License

ABSteppedProgressBar is licensed under the MIT License.

## Contact

### Antonin Biret
* https://github.com/antoninbiret
* https://twitter.com/antonin_brt

## Maintenance

### Pran Kishore
* https://github.com/kishorepran
* https://www.linkedin.com/in/pran-kishore/

## Coming soon

* Carthage Support
