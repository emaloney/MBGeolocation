//
//  MBGeolocationPoint.h
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
#pragma mark MBGeolocationPoint class
/******************************************************************************/

/*!
 Each instance of this class represents a point on Earth.
 */
@interface MBGeolocationPoint : NSObject < NSCopying >

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, assign) CLLocationDegrees latitude;
@property(nonatomic, assign) CLLocationDegrees longitude;

+ (nonnull instancetype) pointWithLatitude:(nonnull id)lat longitude:(nonnull id)lng;
+ (nonnull instancetype) pointWithCoordinate:(CLLocationCoordinate2D)coord;
+ (nullable instancetype) pointWithString:(nonnull NSString*)location;

- (nonnull instancetype) initWithCoordinate:(CLLocationCoordinate2D)coord;
- (nullable instancetype) initWithString:(nonnull NSString*)location;

- (double) distanceFrom:(nonnull MBGeolocationPoint*)otherLocation;

- (nonnull NSString*) asString;

@end
