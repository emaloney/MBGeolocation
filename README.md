![HBC Digital logo](https://raw.githubusercontent.com/gilt/Cleanroom/master/Assets/hbc-digital-logo.png)     
![Gilt Tech logo](https://raw.githubusercontent.com/gilt/Cleanroom/master/Assets/gilt-tech-logo.png)

# MBGeolocation

The Mockingbird Geolocation Module adds geolocation functionality to [the Mockingbird Data Environment](https://github.com/emaloney/MBDataEnvironment).

MBGeolocation is part of the Mockingbird Library from [Gilt Tech](http://tech.gilt.com).


### Xcode compatibility

This is the `master` branch. It **requires Xcode 9.0** to compile.


#### Current status

Branch|Build status
--------|------------------------
[`master`](https://github.com/emaloney/MBGeolocation)|[![Build status: master branch](https://travis-ci.org/emaloney/MBGeolocation.svg?branch=master)](https://travis-ci.org/emaloney/MBGeolocation)


### License

MBGeolocation is distributed under [the MIT license](https://github.com/emaloney/MBGeolocation/blob/master/LICENSE).

MBGeolocation is provided for your use—free-of-charge—on an as-is basis. We make no guarantees, promises or apologies. *Caveat developer.*


### Adding MBGeolocation to your project

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

The simplest way to integrate MBGeolocation is with the [Carthage](https://github.com/Carthage/Carthage) dependency manager.

First, add this line to your [`Cartfile`](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile):

```
github "emaloney/MBGeolocation" ~> 3.0.0
```

Then, use the `carthage` command to [update your dependencies](https://github.com/Carthage/Carthage#upgrading-frameworks).

Finally, you’ll need to [integrate MBGeolocation into your project](https://github.com/emaloney/MBGeolocation/blob/master/INTEGRATION.md) in order to use [the API](https://rawgit.com/emaloney/MBGeolocation/master/Documentation/API/index.html) it provides.

Once successfully integrated, just add the following statement to any Objective-C file where you want to use MBGeolocation:

```objc
@import MBGeolocation;
```

See [the Integration document](https://github.com/emaloney/MBGeolocation/blob/master/INTEGRATION.md) for additional details on integrating MBGeolocation into your project.

### API documentation

For detailed information on using MBGeolocation, [API documentation](https://rawgit.com/emaloney/MBGeolocation/master/Documentation/API/index.html) is available.


## About

Over the years, Gilt Groupe has used and refined Mockingbird Library as the base for its various Apple Platform projects.

Mockingbird began life as AppFramework, created by Jesse Boyes.

AppFramework found a home at Gilt Groupe and eventually became Mockingbird Library.

In recent years, Mockingbird Library has been developed and maintained by Evan Maloney.


### Acknowledgements

API documentation is generated using [appledoc](http://gentlebytes.com/appledoc/) from [Gentle Bytes](http://gentlebytes.com/).
