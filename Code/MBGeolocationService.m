//
//  MBGeolocationService.m
//  Mockingbird Geolocation
//
//  Created by Evan Coyne Maloney on 7/13/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <MBDataEnvironment/MBDataEnvironment.h>

#import "MBGeolocationService.h"
#import "MBGeolocationPoint.h"

#define DEBUG_LOCAL                 0

/******************************************************************************/
#pragma mark Constants -- public
/******************************************************************************/

NSString* const kMBGeolocationRequestLocationEvent      = @"GeolocationService:requestLocation";
NSString* const kMBGeolocationUpdatedEvent              = @"GeolocationService:locationUpdated";
NSString* const kMBGeolocationUpdateTimeoutEvent        = @"GeolocationService:timeout";
NSString* const kMBGeolocationAwaitingUpdateEvent       = @"GeolocationService:pending";
NSString* const kMBGeolocationUpdateDeniedEvent         = @"GeolocationService:deniedByUser";
NSString* const kMBGeolocationUpdateErrorEvent          = @"GeolocationService:error";
NSString* const kMBGeolocationIsDisabledVariable        = @"GeolocationService:isDisabled";
NSString* const kMBGeolocationLatestLocationVariable    = @"GeolocationService:latestLocation";
NSString* const kMBGeolocationUpdateTimeVariable        = @"GeolocationService:locationUpdateTime";
NSString* const kMBGeolocationMaxAgeVariable            = @"GeolocationService:maxLocationAge";

/******************************************************************************/
#pragma mark Constants -- private
/******************************************************************************/

const NSTimeInterval kMBGeolocationDetectionTimeout     = 10.0;         // seconds to wait for location before giving up
const NSTimeInterval kMBGeolocationMinimumAge           = -600.0;       // Minimum acceptable location age, in seconds
const CLLocationAccuracy kMBGeolocationMinimumRadius    = 500;          // Maximum acceptable resolution radius, in meters

/******************************************************************************/
#pragma mark -
#pragma mark MBGeolocationService implementation
/******************************************************************************/

@implementation MBGeolocationService
{
    CLLocation* _lastLocation;
    CLLocationManager* _locationManager;
    NSTimer* _locationTimeout;
}

MBImplementSingleton();

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_locationTimeout invalidate];
}

/******************************************************************************/
#pragma mark Service API
/******************************************************************************/

- (void) startService
{
    debugTrace();
    
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLocation)
                                                     name:kMBGeolocationRequestLocationEvent
                                                   object:nil];
    }
}

- (void) stopService
{
    debugTrace();
    
    if (_locationManager) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        _lastLocation = nil;
        
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
        
        [_locationTimeout invalidate], _locationTimeout = nil;
    }
}

/******************************************************************************/
#pragma mark Requesting location updates
/******************************************************************************/

- (void) updateLocation
{
    debugTrace();

    MBVariableSpace* vars = [MBVariableSpace instance];
    [vars unsetVariable:kMBGeolocationIsDisabledVariable];

    NSTimeInterval maxAgeSec = [vars[kMBGeolocationMaxAgeVariable] doubleValue];
    if (maxAgeSec > 0 && _lastLocation) {
        if (([_lastLocation.timestamp timeIntervalSinceNow] * -1) < maxAgeSec) {
            [MBEvents postEvent:kMBGeolocationUpdatedEvent fromSender:self];
            return;
        }
    }
    
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    [_locationTimeout invalidate];
    _locationTimeout = [NSTimer scheduledTimerWithTimeInterval:kMBGeolocationDetectionTimeout 
                                                        target:self 
                                                      selector:@selector(locationDetectionTimeout:)
                                                      userInfo:nil
                                                       repeats:NO];
}

/******************************************************************************/
#pragma mark Status updating
/******************************************************************************/

- (void) locationUpdated:(CLLocation*)location
{
    debugTrace();
    
    MBVariableSpace* vars = [MBVariableSpace instance];
    vars[kMBGeolocationLatestLocationVariable] = [MBGeolocationPoint pointWithCoordinate:location.coordinate];
    vars[kMBGeolocationUpdateTimeVariable] = [NSDate date];
    [MBEvents postEvent:kMBGeolocationUpdatedEvent fromSender:self];
}

- (void) locationDetectionTimeout:(id)sender
{
    debugTrace();
    
    _locationTimeout = nil;
    [_locationManager stopUpdatingLocation];
    
    if (!_lastLocation) {
        [MBEvents postEvent:kMBGeolocationUpdateTimeoutEvent fromSender:self];
    } else {
        [self locationUpdated:_lastLocation];
    }
}

/******************************************************************************/
#pragma mark CLLocationManagerDelegate methods
/******************************************************************************/

- (void) locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error
{
    NSInteger errCode = [error code];
    switch (errCode) {
        case kCLErrorLocationUnknown:
            [MBEvents postEvent:kMBGeolocationAwaitingUpdateEvent fromSender:self];
            return;     // deliberate, so as not to turn off updates or timeout
            
        case kCLErrorDenied:
            [MBVariableSpace instance][kMBGeolocationIsDisabledVariable] = @YES;
            [MBEvents postEvent:kMBGeolocationUpdateDeniedEvent fromSender:self];
            break;
            
        default:
            [MBEvents postEvent:kMBGeolocationUpdateErrorEvent withObject:error];
            break;
    }
    
    errorLog(@"Failed to determine location: %@", error);

    [_locationTimeout invalidate], _locationTimeout = nil;
    
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
}

- (void) locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
    debugTrace();
    
    _lastLocation = newLocation;
    
    if ([newLocation.timestamp timeIntervalSinceNow] > kMBGeolocationMinimumAge && newLocation.horizontalAccuracy <= kMBGeolocationMinimumRadius) {
        [self locationUpdated:_lastLocation];
        
        [_locationManager stopUpdatingLocation];
        _locationManager.delegate = nil;
        
        [_locationTimeout invalidate], _locationTimeout = nil;
    }
}

@end
