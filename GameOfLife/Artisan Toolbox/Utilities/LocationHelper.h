/*
 *  LocationHelper.h
 *  ArtisanDemo
 *

 *  
 *  Created by Scott Wasserman on 10/8/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */


#import <CoreLocation/CoreLocation.h>

/*
 *  Helper module to manage location services
 *  Particularly, LocationHelper determines current location
 *  and how accurate the location is, based on if information
 *  about location was received or not.
 */

@interface LocationHelper : NSObject<CLLocationManagerDelegate>
{

	/* 
	 *  LocationHelper attributes, named accordingly
	 *  In particular, CLLocationManager *locationManger handles
	 *  all location related services.
	 */

    BOOL foundLocation;
    BOOL locationUpdating;
    BOOL locationUpdatingFailed;
    CLLocation *lastKnownLocation;
    NSDate *locationLastUpdated;
    CLLocationManager *locationManager;
    NSError *lastError;
    BOOL getOneLocation;
}

+ (LocationHelper *)sharedInstance;


/*
 *  Starts updating location using CLLocationManager
 *  as well as sets the boolean values of LocationHelper
 */
- (void)startUpdatingLocationAndStopWhenFound;
- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

/*
 *  isUpdatingLocation and hasLocation will return boolean attributes
 *  foundLocation and locationUpdating. Initially false, these will be set 
 *  when startUpdatingLocationAndStopWhenFound terminates. (when location
 *  is still updating, and when location is found)
 */
- (BOOL)isUpdatingLocation;
- (BOOL)hasLocation;


/*
 *  desiredAccuracy and distanceFilter will be passed to 
 *  CLLocaionManager *locationManager.
 */
- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy;
- (void)setDistanceFilter:(CLLocationDistance)distanceFilter;

/*
 *  Returns true when device (CLLocationManager) has failed to 
 *  retrieve its location
 */
- (BOOL)failedToGetLocation;

/*
 *  Returns the authorization status of the device (through
 *  CLLocationManager
 */
- (BOOL)userHasAuthorizedLocationServices;

/*
 *  Returns the LocationHelper attributes timestamp and currentLocation
 *  in string, CLLocation, and CLLocationCoordinate2D
 */
- (NSDate *)getLastUpdatedTimestamp;
- (CLLocation *)getCurrentLocationAsCLLocation;
- (CLLocationCoordinate2D)getCurrentLocationAsCLLocationCoordinate2D;
- (NSString *)getCurrentLocationAsNSString;
@end
