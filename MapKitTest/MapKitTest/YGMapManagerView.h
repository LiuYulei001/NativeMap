//
//  YGMapManagerView.h
//  MapKitTest
//
//  Created by Rainy on 2017/12/4.
//  Copyright © 2017年 Rainy. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

typedef void(^LatitudeAndLongitude)(CLLocationDegrees latitude,CLLocationDegrees longitude);
typedef void(^Address)(NSString *address);
typedef void(^Failure)(NSError *error);

@interface YGMapManagerView : UIView

@property(nonatomic,strong)NSArray *annotationPins;

- (void)getCurrentLocation:(LatitudeAndLongitude)latitudeAndLongitude
                   address:(Address)address
                   failure:(Failure)failure;

+ (void)navigateTolatitude:(CLLocationDegrees)latitude
                 longitude:(CLLocationDegrees)longitude;

@end
