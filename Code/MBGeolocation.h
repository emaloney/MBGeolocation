//
//  MBGeolocation.h
//  MBGeolocation
//
//  Created by Evan Maloney on 2/4/15.
//  Copyright (c) 2015 Gilt Groupe. All rights reserved.
//

#ifndef __OBJC__

#error Mockingbird Geolocation requires Objective-C

#else

#import <Foundation/Foundation.h>

#import <MBToolbox/MBToolbox.h>

#if MB_BUILD_IOS
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import <MBDataEnvironment/MBDataEnvironment.h>

//! Project version number for MBGeolocation.
FOUNDATION_EXPORT double MBGeolocationVersionNumber;

//! Project version string for MBGeolocation.
FOUNDATION_EXPORT const unsigned char MBGeolocationVersionString[];

//
// NOTE: This header file is indended for external use. It should *not* be
//       included from within code in the Mockingbird Event Handling module.
//
#import <MBGeolocation/MBGeolocationPoint.h>
#import <MBGeolocation/MBGeolocationService.h>
#import <MBGeolocation/MBMLGeolocationFunctions.h>
#import <MBGeolocation/MBGeolocationModule.h>

#endif

