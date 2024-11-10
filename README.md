# Test App

## Overview
The main goal for me was to make use as much as possible of newer Swift and Xcode features such as structured concurrency and the String Catalog, while also avoiding huge dependencies like RxSwift or TCA (The Composable Architecture).

Strict concurrency and new Swift 6 features should all be enabled.

I've left comments throughout the code with things I would do differently given more time or a different goal, and references to external sources.

## Development environment

### Versions
* Xcode 16.1
* Swift 6
* macOS 14.7.1

### First run
* You'll need to build the version of the Wikipedia app contained in this repo so:
    * `cd Wikipedia` - open the Wikipedia folder on Terminal
    * `./scripts/setup` - run the Wikipedia setup script
    * For more info, check Wikipedia's README
* Run the Wikipedia app to install the app into a simulator
* Run the TestApp app to install the app on the same simulator used above

## Architecture
### MVVM
* I picked MVVM simply because it's the one I think it's most commonly used for SwiftUI
* I do think the way I built MVVM may result in complex ViewModels for more complex screens. However, for the size and complexity of the app, this MVVM approach seems to be fine
* If the app was more complex or had the expectation of growing more I believe I would look into TCA or something in that style. The goal would be to keep state mutation and side effects handling separate and as clear as possible, in order to avoid bugs from state being mutated when not desired and/or side effects being triggered unncessarily. This should help as well with testing.

### Modularisation
* I used SPM to modularise the app in a similar style shown in this [video by Pointfree]("https://www.pointfree.co/episodes/ep171-modularization-part-1")
* The main reason I used SPM instead of Tuist (or something else) is due to the higher chance of the SPM approach being buildable on other Macs. Since SPM comes bundled with Xcode, as long as you have that (and a compatible version), you should be able to build this project
* Tuist does provide ways to make reproducible builds easier however I decided it was best not to assume the level of control of the development environment you may have (i.e. can you even install Tuist on your Mac?)

### Testing
* I opted for XCTest instead of Swift Testing due to being far more familiar with the former
* I've worked with Quick and Nimble in the past and do like their approach to building tests but I'd rather avoid such a big dependency
* Snapshot tests were done using Pointfree's Snapshot Testing library

Snapshots were recorded on iPhone 16 Pro iOS 18.1.

Please, use the main target (`TestApp`) to run all tests. 

## Dependencies
* [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing)

## References
* [Pointfree](https://www.pointfree.co)
* [Hacking with Swift](https://www.hackingwithswift.com)
