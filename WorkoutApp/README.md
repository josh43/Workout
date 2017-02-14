# Installing

Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

$ brew update
$ brew install carthage
To integrate Alamofire into your Xcode project using Carthage, specify it in your Cartfile:

github "Alamofire/Alamofire" ~> 4.3
Run carthage update to build the framework and drag the built Alamofire.framework into your Xcode project.


## Dificulties

For some reason I cannot contact the server curl/xcode which leads me to believe there is something wrong with my ssl certificate
