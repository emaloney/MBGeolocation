//
//  MBGeolocationService.h
//  Mockingbird Geolocation
//
//  Created by Evan Coyne Maloney on 7/13/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MBToolbox/MBToolbox.h>

/******************************************************************************/
#pragma mark Constants
/******************************************************************************/

/*! You can post this `NSNotification` event to ask the `MBGeolocationService`
    to determine the current location. Will be ignored if the service is not
    running. */
extern NSString* const kMBGeolocationRequestLocationEvent;      // @"GeolocationService:requestLocation"

/*! One of the following events will be posted as a result of attempting to
    acquire the current location. */
extern NSString* const kMBGeolocationUpdatedEvent;              // @"GeolocationService:locationUpdated" -- fired when the `$GeolocationService:latestLocation` variable is updated
extern NSString* const kMBGeolocationUpdateTimeoutEvent;        // @"GeolocationService:timeout" -- fired when the timeout expires with nothing happening
extern NSString* const kMBGeolocationAwaitingUpdateEvent;       // @"GeolocationService:pending" -- fired when `didFailWithError:` is called with `kCLErrorLocationUnknown`
extern NSString* const kMBGeolocationUpdateDeniedEvent;         // @"GeolocationService:deniedByUser" -- fired when `didFailWithError:` is called with `kCLErrorDenied`
extern NSString* const kMBGeolocationUpdateErrorEvent;          // @"GeolocationService:error" -- fired when `didFailWithError:` is called with something else

/*! If the last attempt to detect the user's location failed due with a
    `kCLErrorDenied` error returned by the OS, this variable will be set
    to boolean true. */
extern NSString* const kMBGeolocationIsDisabledVariable;        // @"GeolocationService:isDisabled"

/*! Name of MBML variable containing an `MBGeolocation` instance representing 
    the user's current location. This will contain a valid value after a
    `GeolocationService:locationUpdated` event is posted. */
extern NSString* const kMBGeolocationLatestLocationVariable;    // @"GeolocationService:latestLocation"

/*! Name of MBML variable containing an `NSDate` instance representing the time
    of the most recent location update. This will contain a valid value after a
    `GeolocationService:locationUpdated` event is posted. */
extern NSString* const kMBGeolocationUpdateTimeVariable;        // @"GeolocationService:locationUpdateTime"

/*! Name of MBML variable that, if set, specifies the number of seconds
    between the `MBGeolocationService`'s use of the CoreLocation framework.
 
    In other words, if the location was last updated less than
    `$GeolocationService:maxLocationAge` seconds ago, CoreLocation will not be
    used when a location update is requested. Instead, a 
    `GeolocationService:locationUpdated` event will be fired, but the
    `$GeolocationService:latestLocation` and
    `$GeolocationService:locationUpdateTime` variables will remain unchanged.
 
    Using CoreLocation can be expensive in terms of battery drain, so this 
    allows the development of code that does not need to include its own
    throttling logic. */
extern NSString* const kMBGeolocationMaxAgeVariable;            // @"GeolocationService:maxLocationAge"

/******************************************************************************/
#pragma mark -
#pragma mark MBGeolocationService interface
/******************************************************************************/

@interface MBGeolocationService : NSObject <MBSingleton, MBService, CLLocationManagerDelegate>

- (void) updateLocation;

@end
