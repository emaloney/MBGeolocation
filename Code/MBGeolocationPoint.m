//
//  MBGeolocationPoint.m
//  Mockingbird Geolocation
//
//  Created by Jesse Boyes on 7/13/09.
//  Copyright (c) 2009 Gilt Groupe. All rights reserved.
//

#import <math.h>
#import <MBToolbox/MBDebug.h>

#import "MBGeolocationPoint.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBGeolocationPoint implementation
/******************************************************************************/

@implementation MBGeolocationPoint

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

+ (MBGeolocationPoint*) pointWithLatitude:(id)lat longitude:(id)lng 
{
    MBLogDebugTrace();

    MBGeolocationPoint* l = [MBGeolocationPoint new];
    l.latitude = (CLLocationDegrees)[lat doubleValue];
    l.longitude = (CLLocationDegrees)[lng doubleValue];
    return l;
}

+ (MBGeolocationPoint*) pointWithCoordinate:(CLLocationCoordinate2D)coord 
{
    MBLogDebugTrace();

    return [[MBGeolocationPoint alloc] initWithCoordinate:coord];
}

+ (MBGeolocationPoint*) pointWithString:(NSString*)location
{
    return [[self alloc] initWithString:location];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord 
{
    MBLogDebugTrace();

    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}

- (id) initWithString:(NSString*)location 
{
    MBLogDebugTrace();

    self = [super init];
    if (self) {
        NSArray* coords = [location componentsSeparatedByString:@","];
        if (coords.count != 2) {
            MBLogError(@"Could not parse string \"%@\" into an %@ instance", location, [self class]);
            return nil;
        }
        else {
            self.latitude = [coords[0] doubleValue];
            self.longitude = [coords[1] doubleValue];
        }
    }
    return self;
}

- (id) copyWithZone:(NSZone*)zone
{
    MBGeolocationPoint* copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        copy->_coordinate.latitude = _coordinate.latitude;
        copy->_coordinate.longitude = _coordinate.longitude;
    }
    return copy;
}

/******************************************************************************/
#pragma mark Equality & hashing
/******************************************************************************/

- (BOOL) isEqual:(id)testObj
{
    MBLogDebugTrace();
    
    if (testObj == self) {
        return YES;
    }
    if (![testObj isKindOfClass:[self class]]) {
        return NO;
    }
    
    MBGeolocationPoint* test = testObj;
    return ((test.coordinate.latitude == _coordinate.latitude) && (test.coordinate.longitude == _coordinate.longitude));
}

- (NSUInteger) hash
{
    MBLogDebugTrace();
    
    return ((NSUInteger)_coordinate.latitude ^ (NSUInteger)_coordinate.longitude);
}

/******************************************************************************/
#pragma mark Accessing location data
/******************************************************************************/

- (double) distanceFrom:(MBGeolocationPoint*)otherLocation 
{
    MBLogDebugTrace();

    double la1 = otherLocation.latitude * M_PI / 180.0;
    double lo1 = otherLocation.longitude * M_PI / 180.0;
    double la2 = self.latitude * M_PI / 180.0;
    double lo2 = self.longitude * M_PI / 180.0;
    
    double dist = acos(cos(la1)*cos(lo1)*cos(la2)*cos(lo2) +
                       cos(la1)*sin(lo1)*cos(la2)*sin(lo2) +
                       sin(la1)*sin(la2)) * 3963.1924; // Circumference of the earth in miles.
    return dist;
}    


- (CLLocationDegrees) latitude 
{ 
    MBLogDebugTrace();

    return _coordinate.latitude; 
}

- (CLLocationDegrees) longitude 
{ 
    MBLogDebugTrace();

    return _coordinate.longitude; 
}

- (void) setLatitude:(CLLocationDegrees)lat 
{ 
    MBLogDebugTrace();

    _coordinate.latitude = lat;
}

- (void) setLongitude:(CLLocationDegrees)lng 
{ 
    MBLogDebugTrace();

    _coordinate.longitude = lng;
}

- (NSString*) asString
{
    return [NSString stringWithFormat:@"%0.8f,%0.8f", _coordinate.latitude, _coordinate.longitude];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@: %@>", [self class], [self asString]];
}

@end
