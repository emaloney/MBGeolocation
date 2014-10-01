//
//  MBGeolocation.m
//  Mockingbird Geolocation
//
//  Created by Jesse Boyes on 7/13/09.
//  Copyright (c) 2009 Gilt Groupe. All rights reserved.
//

#import <math.h>
#import <MBToolbox/MBDebug.h>

#import "MBGeolocation.h"

#define DEBUG_LOCAL         0

/******************************************************************************/
#pragma mark -
#pragma mark MBGeolocation implementation
/******************************************************************************/

@implementation MBGeolocation

/******************************************************************************/
#pragma mark Object lifecycle
/******************************************************************************/

+ (MBGeolocation*) locationWithLatitude:(id)lat longitude:(id)lng 
{
    debugTrace();

    MBGeolocation* l = [MBGeolocation new];
    l.latitude = (CLLocationDegrees)[lat doubleValue];
    l.longitude = (CLLocationDegrees)[lng doubleValue];
    return l;
}

+ (MBGeolocation*) locationWithCoordinate:(CLLocationCoordinate2D)coord 
{
    debugTrace();

    return [[MBGeolocation alloc] initWithCoordinate:coord];
}

+ (MBGeolocation*) locationWithString:(NSString*)location
{
    return [[self alloc] initWithString:location];
}

+ (id) fromStringValue:(NSString*)str
{
    return [self locationWithString:str];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord 
{
    debugTrace();

    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}

- (id) initWithString:(NSString*)location 
{
    debugTrace();

    self = [super init];
    if (self) {
        NSArray* coords = [location componentsSeparatedByString:@","];
        if (coords.count != 2) {
            errorLog(@"Could not parse string \"%@\" into an %@ instance", location, [self class]);
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
    MBGeolocation* copy = [[[self class] allocWithZone:zone] init];
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
    debugTrace();
    
    if (testObj == self) {
        return YES;
    }
    if (![testObj isKindOfClass:[self class]]) {
        return NO;
    }
    
    MBGeolocation* test = testObj;
    return ((test.coordinate.latitude == _coordinate.latitude) && (test.coordinate.longitude == _coordinate.longitude));
}

- (NSUInteger) hash
{
    debugTrace();
    
    return ((NSUInteger)_coordinate.latitude ^ (NSUInteger)_coordinate.longitude);
}

/******************************************************************************/
#pragma mark Accessing location data
/******************************************************************************/

- (double) distanceFrom:(MBGeolocation*)otherLocation 
{
    debugTrace();

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
    debugTrace();

    return _coordinate.latitude; 
}

- (CLLocationDegrees) longitude 
{ 
    debugTrace();

    return _coordinate.longitude; 
}

- (void) setLatitude:(CLLocationDegrees)lat 
{ 
    debugTrace();

    _coordinate.latitude = lat;
}

- (void) setLongitude:(CLLocationDegrees)lng 
{ 
    debugTrace();

    _coordinate.longitude = lng;
}

- (NSString*) stringValue 
{
    return [NSString stringWithFormat:@"%0.8f,%0.8f", _coordinate.latitude, _coordinate.longitude];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@: %@>", [self class], [self stringValue]];
}

@end
