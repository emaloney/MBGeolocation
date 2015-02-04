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

+ (MBGeolocationPoint*) pointWithLatitude:(id)lat longitude:(id)lng;
+ (MBGeolocationPoint*) pointWithCoordinate:(CLLocationCoordinate2D)coord;
+ (MBGeolocationPoint*) pointWithString:(NSString*)location;

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord;
- (id) initWithString:(NSString*)location;

- (double) distanceFrom:(MBGeolocationPoint*)otherLocation;

- (NSString*) asString;

@end
