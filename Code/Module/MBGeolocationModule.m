//
//  MBGeolocationModule.m
//  Mockingbird Geolocation
//
//  Created by Evan Coyne Maloney on 10/1/14.
//  Copyright (c) 2014 Gilt Groupe. All rights reserved.
//

#import "MBGeolocationModule.h"

#define DEBUG_LOCAL     0

/******************************************************************************/
#pragma mark -
#pragma mark MBGeolocationModule implementation
/******************************************************************************/

@implementation MBGeolocationModule

+ (NSString*) moduleEnvironmentFilename
{
    return [[self description] stringByAppendingPathExtension:@"xml"];
}

@end
