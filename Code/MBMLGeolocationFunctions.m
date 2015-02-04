//
//  MBMLGeolocationFunctions.m
//  Mockingbird Geolocation
//
//  Created by Evan Coyne Maloney on 8/30/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

#import <MBDataEnvironment/MBDataEnvironment.h>

#import "MBMLGeolocationFunctions.h"
#import "MBGeolocationPoint.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGeolocationFunctions implementation
/******************************************************************************/

@implementation MBMLGeolocationFunctions

/******************************************************************************/
#pragma mark Private methods
/******************************************************************************/

+ (BOOL) _coordinate:(CLLocationCoordinate2D*)coordPtr
          fromString:(NSString*)coordStr
         acceptPipes:(BOOL)acceptPipes
{
    assert(coordPtr != nil);
    NSArray* coords = [coordStr componentsSeparatedByString:@","];
    if (coords.count != 2) {
        if (acceptPipes) {
            coords = [coordStr componentsSeparatedByString:@"|"];
            if (coords.count != 2) return NO;
        }
        else return NO;
    }
    *coordPtr = CLLocationCoordinate2DMake([coords[0] doubleValue], [coords[1] doubleValue]);
    return YES;
}

+ (BOOL) _coordinate:(CLLocationCoordinate2D*)coordPtr
       fromParameter:(NSString*)coordStr
             atIndex:(NSUInteger)index
               error:(MBMLFunctionError**)errPtr
{
    if (![self _coordinate:coordPtr fromString:coordStr acceptPipes:NO]) {
        [[MBMLFunctionError errorWithFormat:@"expected parameter at index %u to be in the format \"<latitude>,<longitude>\", but instead got: \"%@\"", index, coordStr] reportErrorTo:errPtr];
        return NO;
    }
    return YES;
}

+ (NSNumber*) _distanceInMilesFromArrayObjects:(NSArray*)array
                                       atIndex:(NSUInteger)indexOfPointA
                                         error:(MBMLFunctionError**)errPtr
{
    NSArray* acceptedParameterClasses = @[[NSString class], [MBGeolocationPoint class]];

    
    MBMLFunctionError* err = nil;
    Class classOfPointA = [MBMLFunction validateParameter:array 
                                            objectAtIndex:indexOfPointA
                                         isOneKindOfClass:acceptedParameterClasses
                                                    error:&err];
    
    Class classOfPointB = [MBMLFunction validateParameter:array 
                                            objectAtIndex:indexOfPointA+1
                                         isOneKindOfClass:acceptedParameterClasses
                                                    error:&err];
    if (err) {
        [err reportErrorTo:errPtr];
        return nil;
    }

    id paramA = array[indexOfPointA];
    id paramB = array[indexOfPointA+1];
    MBGeolocationPoint* pointA = nil;
    MBGeolocationPoint* pointB = nil;
    if (classOfPointA == [NSString class]) {
        CLLocationCoordinate2D clCoord;
        [self _coordinate:&clCoord fromParameter:paramA atIndex:indexOfPointA error:&err];
        if (err) {
            [err reportErrorTo:errPtr];
            return nil;
        }
        pointA = [MBGeolocationPoint pointWithCoordinate:clCoord];
    }
    // if it isn't a string it must be an MBGeolocation
    else {
        pointA = paramA;
    }
    
    if (classOfPointB == [NSString class]) {
        CLLocationCoordinate2D clCoord;
        [self _coordinate:&clCoord fromParameter:paramB atIndex:indexOfPointA+1 error:&err];
        if (err) {
            [err reportErrorTo:errPtr];
            return nil;
        }
        pointB = [MBGeolocationPoint pointWithCoordinate:clCoord];
    }
    // if it isn't a string it must be an MBGeolocation
    else {
        pointB = paramB;
    }
    
    double distanceInMiles = [pointA distanceFrom:pointB];
    return @(distanceInMiles);
}

/******************************************************************************/
#pragma mark Public API
/******************************************************************************/

+ (id) distance:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:2 error:&err];
    if (err) return err;
    
    NSNumber* dist = [self _distanceInMilesFromArrayObjects:params atIndex:0 error:&err];
    if (err) return err;

    return dist;
}

+ (id) formatDistance:(NSArray*)params
{
    debugTrace();
    
    MBMLFunctionError* err = nil;
    [MBMLFunction validateParameter:params countIs:3 error:&err];
    [MBMLFunction validateParameter:params isStringAtIndex:0 error:&err];
    if (err) return err;
    
    NSNumber* dist = [self _distanceInMilesFromArrayObjects:params atIndex:1 error:&err];
    if (err) return err;
        
    NSString* formatStr = [MBExpression asString:params[0] error:&err];
    if (err) return err;
    
    return [NSString stringWithFormat:formatStr, [dist doubleValue]];
}

+ (id) parseLocation:(NSString*)locStr
{
    debugTrace();
    
    CLLocationCoordinate2D coord;
    if (![self _coordinate:&coord fromString:locStr acceptPipes:YES]) {
        return [MBMLFunctionError errorWithFormat:@"expected parameter in the format \"<latitude>,<longitude>\" or \"<latitude>|<longitude>\", but instead got: \"%@\"", locStr];
    }
    return [MBGeolocationPoint pointWithCoordinate:coord];
}

@end
