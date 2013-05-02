//
//  testingViewController.m
//  CLTest
//
//  Created by Alex Reynolds on 5/1/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import "testingViewController.h"

@interface testingViewController ()

@end

@implementation testingViewController
@synthesize locationManager, currentLocation, previousLocation, startLocation, locationLabel, dateLabel,diffLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 50.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// updateView updates the labels with the new location information
-(void) updateView:(CLLocation *)location{
    locationLabel.text = [NSString stringWithFormat:@"position: \nlat:%f \nlong:%f \nspeed:%f \nCourse:%f" ,location.coordinate.latitude, location.coordinate.longitude,location.speed, location.course];
    dateLabel.text = [NSString stringWithFormat:@"%@", location.timestamp ];
    
    float deltaDistance =  [currentLocation distanceFromLocation:previousLocation];
    _totalDistance += deltaDistance;

    diffLabel.text = [NSString stringWithFormat:@"horizAcc:%f \vertAcc:%f  \nDist:%f", location.horizontalAccuracy, location.verticalAccuracy,
                      _totalDistance];
}
// startLocation is fired by the user. It clears our variables and restarts the location polling
- (IBAction)startLocation:(id)sender {
    [_locationPoints removeAllObjects];
    _totalDistance  = 0;
    [locationManager stopUpdatingLocation];
    startLocation = nil;
    [locationManager startUpdatingLocation];
    
}

- (IBAction)stopLocation:(id)sender {
    [locationManager stopUpdatingLocation];
    locationLabel.text = @"Stopped";
}


#pragma mark - Location Delegate
// FOR IOS 6
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{

    previousLocation = currentLocation;
    currentLocation = [locations lastObject];
    [_locationPoints addObject:currentLocation];
    if(currentLocation.horizontalAccuracy <= 100.0f){
        if (!startLocation){
            startLocation = currentLocation;
        }
    }
    [self updateView:currentLocation];
}
// IOS 5
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if(newLocation.horizontalAccuracy <= 100.0f){
        if (!startLocation){
            startLocation = newLocation;
        }
    }
    previousLocation = currentLocation;
    currentLocation = newLocation;
    [_locationPoints addObject:currentLocation];
    [self updateView:currentLocation];
}


-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == kCLErrorDenied){
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown){
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error retrieving location"
                                                        message:@"sorry"
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void)viewDidUnload {
    [self setDateLabel:nil];
    [self setDiffLabel:nil];
    [super viewDidUnload];
}
@end
