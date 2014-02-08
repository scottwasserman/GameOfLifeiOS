/*
 *  LocationHelper.m
 *  ArtisanDemo
 *
 *  Created by Scott Wasserman on 10/8/13.
 *  Copyright (c) 2013 Artisan Mobile, Inc. All rights reserved.
 */

#import "LocationHelper.h"
#import <CoreLocation/CoreLocation.h>

@implementation LocationHelper

+ (LocationHelper *)sharedInstance
{
	static LocationHelper *locationHelper = nil;
	if (!locationHelper)
    {
		locationHelper = [[LocationHelper alloc] init];
	}
	return locationHelper;
}

#pragma mark -
#pragma mark NSObject

- (id)init {
	if (self = [super init])
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        foundLocation = NO;
        locationUpdating = NO;
        locationUpdatingFailed = NO;
        getOneLocation = NO;
    }
	return self;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy
{
    locationManager.desiredAccuracy = desiredAccuracy;
}

- (void)setDistanceFilter:(CLLocationDistance)distanceFilter
{
    locationManager.distanceFilter = distanceFilter;
}

- (void)startUpdatingLocationAndStopWhenFound
{
    getOneLocation = YES;
    [locationManager startUpdatingLocation];
    foundLocation = NO;
    locationUpdating = YES;
}

- (void)startUpdatingLocation
{
    if (!locationUpdating)
    {
        getOneLocation = YES;
        [locationManager startUpdatingLocation];
        foundLocation = NO;
        locationUpdating = YES;
    }
}

- (void)stopUpdatingLocation
{
    if (locationUpdating)
    {
        [locationManager stopUpdatingLocation];
        locationUpdating = NO;
    }
}

- (BOOL)isUpdatingLocation
{
    return locationUpdating;
}

- (BOOL)hasLocation
{
    return foundLocation;
}

- (BOOL)failedToGetLocation
{
    return locationUpdatingFailed;
}

- (BOOL)userHasAuthorizedLocationServices
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

- (CLLocation *)getCurrentLocationAsCLLocation
{
    return lastKnownLocation;
}

- (CLLocationCoordinate2D)getCurrentLocationAsCLLocationCoordinate2D
{
    return [lastKnownLocation coordinate];
}

- (NSString *)getCurrentLocationAsNSString
{
    NSNumber *latitude = [[NSNumber alloc] initWithDouble:lastKnownLocation.coordinate.latitude];
    NSNumber *longitude = [[NSNumber alloc] initWithDouble:lastKnownLocation.coordinate.longitude];
    return [NSString stringWithFormat:@"%@,%@",latitude,longitude];
}

- (NSDate *)getLastUpdatedTimestamp
{
    return locationLastUpdated;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    foundLocation = YES;
    lastKnownLocation = [locations lastObject];
    locationLastUpdated = [NSDate date];
    locationUpdatingFailed = NO;
    if (getOneLocation)
    {
        [self stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    lastError = error;
    NSLog(@"%@",[error localizedDescription]);
    [self stopUpdatingLocation];
    locationUpdatingFailed = YES;
}

@end
