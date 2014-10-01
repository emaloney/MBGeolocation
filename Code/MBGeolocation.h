//
//  MBGeolocation.h
//  Mockingbird Geolocation
//
//  Created by Jesse Boyes on 7/13/09.
//  Copyright (c) 2009 Gilt Groupe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <MBDataEnvironment/MBVariableDeclaration.h>

/******************************************************************************/
#pragma mark -
#pragma mark MBGeolocation class
/******************************************************************************/

@interface MBGeolocation : NSObject < NSCopying, MBStringValueCoding >

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, assign) CLLocationDegrees latitude;
@property(nonatomic, assign) CLLocationDegrees longitude;
@property(nonatomic, readonly) NSString* stringValue;

+ (id) fromStringValue:(NSString*)str;

+ (MBGeolocation*) locationWithLatitude:(id)lat longitude:(id)lng;
+ (MBGeolocation*) locationWithCoordinate:(CLLocationCoordinate2D)coord;
+ (MBGeolocation*) locationWithString:(NSString*)location;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;
- (id) initWithString:(NSString*)location;

- (double) distanceFrom:(MBGeolocation*)otherLocation;

@end
