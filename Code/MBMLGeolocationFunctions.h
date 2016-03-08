//
//  MBMLGeolocationFunctions.h
//  Mockingbird Geolocation
//
//  Created by Evan Coyne Maloney on 8/30/11.
//  Copyright (c) 2011 Gilt Groupe. All rights reserved.
//

@import Foundation;

/******************************************************************************/
#pragma mark -
#pragma mark MBMLGeolocationFunctions class
/******************************************************************************/

/*!
 Provides a mechanism for parsing geolocations from strings, calculating
 distances between geolocations, and formatting human-readable distances.
 */
@interface MBMLGeolocationFunctions : NSObject

/*!
 Calculates the distance between two map coordinates, in miles.
  
 This function accepts an array of template expressions, and expects
 two objects in the array: <i>point a</i> and <i>point b</b>, both of which
 are expected to evaluate to <code>MBGeolocation</code> instances or 
 <code>NSString</code>s. If either parameter is a string, an attempt is made
 to convert it into an <code>MBGeolocation</code> instance by interpreting it in 
 <code><i>latitude</i>,<i>longitude</i></code> format.
 
 <b>Template example:</b>
 
 <pre>^distance($pointA|$pointB)</pre>
 
 The expression above returns the distance in miles between <code>$pointA</code>
 and <code>$pointB</code>.

 @param     params an array containing the input parameters for the function
 
 @return    An <code>NSNumber</code> instance containing a <code>double</code>
            value representing the distance in miles between the input
            parameters
 */
+ (id) distance:(NSArray*)params;

/*!
 Calculates the distance between two map coordinates, in miles, and formats
 a string to represent that distance.
 
 This function accepts an array of template expressions, and expects
 three objects in the array:
 
 <ul>
 <li>a <i>format string</i>
 
 <li><i>point a</i> and <i>point b</b>, both of which
 are expected to evaluate to <code>MBGeolocation</code> instances or 
 <code>NSString</code>s. If either point is a string, an attempt is made
 to convert it into an <code>MBGeolocation</code> instance by interpreting it in 
 <code><i>latitude</i>,<i>longitude</i></code> format.
 </ul>

 <b>Template example:</b>
 
 <pre>^formatDistance(%0.1f miles|$pointA|$pointB)</pre>
 
 The expression above would determine the miles between <code>$pointA</code>
 and <code>$pointB</code>, and would then format that value into a string
 using <code>[NSString stringWithFormat:@"%0.1f miles", distanceInMiles]</code>.
 
 @param     params an array containing the input parameters for the function
 
 @return    An <code>NSString</code> formatted according to the parameters
 */
+ (id) formatDistance:(NSArray*)params;

/*!
 Attempts to create an <code>MBGeolocation</code> instance by parsing a string
 for decimal latitude and longitude coordinates.
 
 This function accepts a string as input, where the string contains the
 latitude coordinate, followed by a delimiter, followed by the longitude
 coordinate. 
 
 This method accepts either a comma ("<code>,</code>") or a pipe character
 ("<code>|</code>") as the delimiter, meaning that the following expressions
 are equivalent:
 
 <pre>^parseLocation(40.741284|-73.987383)</pre>
 <pre>^parseLocation(40.741284,-73.987383)</pre>
 
 Either expression above would return an <code>MBGeolocation</code> instance
 pointing to the address 1 Madison Avenue in New York City.
 
 @param     a string containing comma-separated or pipe-separated latitude and
            longitude coordinates
 
 @return    An <code>MBGeolocation</code> containing the latitude and longitude
            specified in the input parameter
 */
+ (id) parseLocation:(NSString*)locStr;

@end
