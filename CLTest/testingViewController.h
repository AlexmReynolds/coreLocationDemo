//
//  testingViewController.h
//  CLTest
//
//  Created by Alex Reynolds on 5/1/13.
//  Copyright (c) 2013 Alex Reynolds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface testingViewController : UIViewController<CLLocationManagerDelegate>{
    @private
    NSMutableArray *_locationPoints;
    float _totalDistance;

}
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocation *previousLocation;
@property (nonatomic, strong) CLLocation *startLocation;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)startLocation:(id)sender;

- (IBAction)stopLocation:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *diffLabel;
@end
