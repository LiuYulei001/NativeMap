//
//  ViewController.m
//  MapKitTest
//
//  Created by Rainy on 2017/12/1.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#import "ViewController.h"

#import "MyAnnotation.h"
#import "YGMapManagerView.h"

@interface ViewController ()

@property(nonatomic,strong)YGMapManagerView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *LatitudeAndLongitude;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MyAnnotation *annotation = [[MyAnnotation alloc] init];
    CLLocationCoordinate2D location1 = CLLocationCoordinate2DMake(40, 116);
    annotation.coordinate = location1;
    annotation.title = @"BeiJing";
    annotation.subtitle = @"Myhome";
    annotation.image = [UIImage imageNamed:@"test"];
    
    MyAnnotation *annotation2 = [[MyAnnotation alloc] init];
    CLLocationCoordinate2D location2 = CLLocationCoordinate2DMake(39, 121);
    annotation2.coordinate = location2;
    annotation2.title = @"DaLian";
    annotation2.subtitle = @"Hishome";
    annotation2.image = [UIImage imageNamed:@"test"];
    
    MyAnnotation *annotation3 = [[MyAnnotation alloc] init];
    CLLocationCoordinate2D location3 = CLLocationCoordinate2DMake(34, 113);
    annotation3.coordinate = location3;
    annotation3.title = @"zhengzhou";
    annotation3.subtitle = @"herhome";
    annotation3.image = [UIImage imageNamed:@"test"];
    
    self.mapView.annotationPins = @[annotation,annotation2,annotation3];
    
}
- (IBAction)GPS:(id)sender {
    
    [YGMapManagerView navigateTolatitude:40 longitude:116];
}
- (IBAction)getLacation:(id)sender {
    
    self.LatitudeAndLongitude.text = nil;
    self.address.text = nil;
    
    [self.mapView getCurrentLocation:^(CLLocationDegrees latitude, CLLocationDegrees longitude) {
        
        self.LatitudeAndLongitude.text = [NSString stringWithFormat:@"经度：%.3f，纬度：%.3f",longitude,latitude];
        
    } address:^(NSString *address) {
        self.address.text = address;
        
    } failure:^(NSError *error) {
        
    }];
}

- (YGMapManagerView *)mapView
{
    if (!_mapView) {
        
        _mapView = [[YGMapManagerView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 230)];
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

@end
