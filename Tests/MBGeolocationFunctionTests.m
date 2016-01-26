//
//  MBGeolocationFunctionTests.m
//  MockingbirdTests
//
//  Created by Evan Coyne Maloney on 1/25/12.
//  Copyright (c) 2012 Gilt Groupe. All rights reserved.
//

@import MBDataEnvironment;

#import "MBDataEnvironmentTestSuite.h"
#import "MBGeolocationPoint.h"
#import "MBGeolocationModule.h"

#define TEST_EXPECTED_FAILURES      1
#define TEST_UPDATED_TRANSFORMERS   1

/******************************************************************************/
#pragma mark -
#pragma mark MBGeolocationFunctionTests class
/******************************************************************************/

@interface MBGeolocationFunctionTests : MBDataEnvironmentTestSuite
@end

@implementation MBGeolocationFunctionTests

/******************************************************************************/
#pragma mark MBMLGeolocationFunctions tests
/******************************************************************************/

/*
<Function class="MBMLGeolocationFunctions" name="distance" input="pipedObjects"/>
<Function class="MBMLGeolocationFunctions" name="formatDistance" input="pipedObjects"/>
<Function class="MBMLGeolocationFunctions" name="parseLocation" input="string"/>
 */

- (void) willLoadEnvironment
{
    [super willLoadEnvironment];
    
    [MBEnvironment enableModuleClass:[MBGeolocationModule class]];
}

- (void) setUpVariableSpace:(MBVariableSpace*)vars
{
    [super setUpVariableSpace:vars];
}

- (void) _setupMapVariables
{
    MBVariableSpace* vars = [MBVariableSpace instance];
    MBGeolocationPoint* apple = [MBGeolocationPoint pointWithCoordinate:CLLocationCoordinate2DMake(37.3316872, -122.0305188)];
    MBGeolocationPoint* oneMad = [MBGeolocationPoint pointWithCoordinate:CLLocationCoordinate2DMake(40.741284, -73.987383)];
    vars[@"appleLoc"] = apple;
    vars[@"giltMobileLoc"] = oneMad;
}

- (void) testMapFunctions
{
    [self _setupMapVariables];

    //
    // test of ^distance()
    //
    NSNumber* dist = [MBExpression asObject:@"^distance($appleLoc|$giltMobileLoc)"];
    XCTAssertTrue([dist isKindOfClass:[NSNumber class]], @"expected result of ^distance() to return an NSNumber");
    // TODO: not 100% sure this value is valid; need to double-check our algo
    XCTAssertEqualWithAccuracy([dist doubleValue], 2559.8, 0.1, @"expected resulting distance of about 2559 miles");
    
    //
    // test of ^formatDistance()
    //
    NSString* distMsg = [MBExpression asObject:@"^formatDistance(%0.1f miles|$appleLoc|$giltMobileLoc)"];
    XCTAssertTrue([distMsg isKindOfClass:[NSString class]], @"expected result of ^formatDistance() to return an NSString");
    XCTAssertEqualObjects(distMsg, @"2559.8 miles", @"expected result of ^formatDistance() to be the string \"2559.8 miles\"");
    
    //
    // test of ^parseLocation()
    //
    MBGeolocationPoint* locWithPipe     = [MBExpression asObject:@"^parseLocation(40.741284,-73.987383)"];
    MBGeolocationPoint* locWithComma    = [MBExpression asObject:@"^parseLocation(40.741284|-73.987383)"];
    XCTAssertTrue([locWithPipe isKindOfClass:[MBGeolocationPoint class]], @"expected result of ^parseLocation() to return an MBGeolocationPoint");
    XCTAssertTrue([locWithComma isKindOfClass:[MBGeolocationPoint class]], @"expected result of ^parseLocation() to return an MBGeolocationPoint");
    XCTAssertEqualObjects(locWithPipe, locWithComma, @"expected ^parseLocation(40.741284,-73.987383) and ^parseLocation(40.741284|-73.987383) to return the same value");
}

#if TEST_EXPECTED_FAILURES
- (void) testMapFunctionFailures
{
    [self _setupMapVariables];

    //
    // test of ^distance()
    //
    MBExpressionError* err = nil;
    [MBExpression asString:@"^distance()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^distance() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^distance($giltMobileLoc)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^distance() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^distance($appleLoc|$giltMobileLoc|extraneous parameter)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^distance() with three parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^distance(hello|is it me you're looking for?)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^distance() with values that can't be interpreted as map coordinates");
    logExpectedError(err);

    //
    // test of ^formatDistance()
    //
    err = nil;
    [MBExpression asString:@"^formatDistance()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^formatDistance() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^formatDistance(%0.1f miles)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^formatDistance() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^formatDistance(%0.1f miles|$appleLoc)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^formatDistance() with two parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^formatDistance(%0.1f miles|$appleLoc|$giltMobileLoc|extraneous parameter)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^formatDistance() with four parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^formatDistance(%0.1f miles|hello|is it me you're looking for?)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^formatDistance() with values that can't be interpreted as map coordinates");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^formatDistance($emptyArray|$appleLoc|$giltMobileLoc)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^formatDistance() with a format string that isn't a string");
    logExpectedError(err);
    
    //
    // test of ^parseLocation()
    //
    [MBExpression asString:@"^parseLocation()" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseLocation() with no parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseLocation(40.741284)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseLocation() with one parameter");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseLocation(40.741284,-73.987383,-73.987383)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseLocation() with three parameters");
    logExpectedError(err);
    err = nil;
    [MBExpression asString:@"^parseLocation(40.741284|-73.987383|-73.987383)" error:&err];
    XCTAssertNotNil(err, @"Expected to get error for calling ^parseLocation() with three parameters");
    logExpectedError(err);
}
#endif

@end
