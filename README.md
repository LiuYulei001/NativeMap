# NativeMap
原生地图封装

1.MKMapView地图展示创建及封装；


- (instancetype)initWithFrame:(CGRect)frame；

2.获取当前地理位置；

- (void)getCurrentLocation:(LatitudeAndLongitude)latitudeAndLongitude
                   address:(Address)address
                   failure:(Failure)failure；
                   
3.跳到本机自带地图app导航到目的地；

+ (void)navigateTolatitude:(CLLocationDegrees)latitude
                 longitude:(CLLocationDegrees)longitude;
                 
                 
还包含权限检测、自定义大头针等等.......
