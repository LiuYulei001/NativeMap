//
//  YGMapManagerView.m
//  MapKitTest
//
//  Created by Rainy on 2017/12/4.
//  Copyright © 2017年 Rainy. All rights reserved.
//
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

#import "YGMapManagerView.h"

@interface YGMapManagerView ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    LatitudeAndLongitude _latitudeAndLongitude;
    Address _address;
    Failure _failure;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation YGMapManagerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self createMapView];
    }
    return self;
}
- (void)createMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    _mapView.delegate = self;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.mapType = MKMapTypeStandard;
    [self addSubview:_mapView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    WS(weakSelf)
    [self openLocationServiceWithBlock:^(BOOL locationIsOpen) {
        if (!locationIsOpen) {
            
            [weakSelf.locationManager requestWhenInUseAuthorization];
        }
    }];
}
- (void)setAnnotationPins:(NSArray *)annotationPins
{
    _annotationPins = annotationPins;
    [self.mapView addAnnotations:annotationPins];
}
#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        
        static NSString *identifier = @"myAnnotation";
        MKAnnotationView *annotationView =[_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = NO;
//            annotationView.calloutOffset = CGPointMake(0, 1);
//            annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"88"]];
            
        }
        annotationView.annotation = annotation;
        annotationView.image = ((MyAnnotation *)annotation).image;
        return annotationView;
        
    } else {
        return nil;
    }
}
- (void)getCurrentLocation:(LatitudeAndLongitude)latitudeAndLongitude
                   address:(Address)address
                   failure:(Failure)failure
{
    _latitudeAndLongitude = latitudeAndLongitude;
    _address = address;
    _failure = failure;
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    WS(weakSelf)
    [self openLocationServiceWithBlock:^(BOOL locationIsOpen) {
        if (!locationIsOpen) {
            
            [weakSelf.locationManager requestWhenInUseAuthorization];
        }
    }];
    [self.locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (error) {
        _failure(error);
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = locations[0];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            CLLocationDegrees latitude=placemark.location.coordinate.latitude;
            CLLocationDegrees longitude=placemark.location.coordinate.longitude;
            
            NSString *city = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea ? placemark.administrativeArea : @"",placemark.locality ? placemark.locality : @""];
            
            NSString *adress = [NSString stringWithFormat:@"%@ %@ %@ %@",placemark.country,city,placemark.name,placemark.thoroughfare];
            
            _latitudeAndLongitude(latitude,longitude);
            _address(adress);
            
        }
        else if (error == nil && [array count] == 0)
        {
            _failure(error);
        }
        else if (error != nil)
        {
            _failure(error);
        }
    }];
    
    [manager stopUpdatingLocation];
    
}
+ (void)navigateTolatitude:(CLLocationDegrees)latitude
                longitude:(CLLocationDegrees)longitude
{
    MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil]];
    [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
}
- (void)openLocationServiceWithBlock:(void(^)(BOOL locationIsOpen))returnBlock
{
    if ([CLLocationManager locationServicesEnabled])
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"定位服务授权状态是:用户没有决定是否使用定位服务");
                returnBlock(NO);
                break;
            case kCLAuthorizationStatusRestricted:
                returnBlock(NO);
                NSLog(@"定位服务授权状态是受限制的");
                break;
            case kCLAuthorizationStatusDenied:
                
                NSLog(@"定位服务授权状态已经被用户明确禁止，或者在设置里的定位服务中关闭");
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                returnBlock(YES);
                NSLog(@"定位服务授权状态已经被用户允许在任何状态下获取位置信息");
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"定位服务授权状态仅被允许在使用应用程序的时候");
                returnBlock(YES);
                break;
                
            default:
                break;
        }
    }else
    {
        NSLog(@"定位服务不可用");
    }
    
}
@end
