//
//  SKLocation.m
//
//  Created by zen on 2021/9/2.
//  Copyright © 2021 crv.jp007. All rights reserved.
//

#import "SKLocation.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface SKLocation()<AMapSearchDelegate,AMapLocationManagerDelegate>{
    NSString * _address;
    BOOL _isMaping;
    
    //GD NEW
    AMapLocationManager *_AMapLocationManager;
    AMapSearchAPI *_AMapSearchAPI;
    CLLocationManager *_locationManager;
}
@end

@implementation SKLocation

+(instancetype)defaultAInit:(NSString*)apiKey{
    
    SKLocation* instance = [[[self class] alloc] init:apiKey];
    return instance;
}

-(id)init:(NSString*)apiKey{
        
    
    if (self=[super init]) {
        
        //GD NEW
//        [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
//        [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
//        _AMapLocationManager = [[AMapLocationManager alloc] init];
//        [_AMapLocationManager setDelegate:self];
//        [_AMapLocationManager setPausesLocationUpdatesAutomatically:NO];
//        [_AMapLocationManager setAllowsBackgroundLocationUpdates:NO];
//        // 带逆地理信息的一次定位（返回坐标和地址信息）
//        [_AMapLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
//        // 定位超时时间，最低2s，此处设置为2s
//        _AMapLocationManager.locationTimeout =60;
//        // 逆地理请求超时时间，最低2s，此处设置为2s
//        _AMapLocationManager.reGeocodeTimeout = 60;
//
//        [AMapServices sharedServices].apiKey = GAODEKEY;
//        _AMapSearchAPI = [[AMapSearchAPI alloc]init];
//        _AMapSearchAPI.delegate = self;
        
        
        [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
        [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
        _AMapLocationManager = [[AMapLocationManager alloc] init];
        [AMapServices sharedServices].apiKey = apiKey;
        [_AMapLocationManager setPausesLocationUpdatesAutomatically:NO];
        [_AMapLocationManager setAllowsBackgroundLocationUpdates:NO];
        [_AMapLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _AMapLocationManager.locationTimeout =60;
        _AMapLocationManager.reGeocodeTimeout = 60;
        
        _locationManager = [[CLLocationManager alloc] init];
    }
    
    return self;
    
}

-(void)startMap{
    CLAuthorizationStatus status = [_locationManager authorizationStatus];
    
    if (self.getAuthorizationStatus){
        self.getAuthorizationStatus(status);
    }
    
    [_AMapLocationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            //NSLog(@"高德01-locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (self.getWeizhi) {
                struct CLLocationCoordinate2D center = {0,0};
                self.getWeizhi(@"定位失败",nil,nil,nil,nil,center);
            }
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                NSString *latitudestr = @"";
                NSString *longitudestr = @"";
                if(self.getLatitudeAndLongitudeFail){
                    self.getLatitudeAndLongitudeFail();
                }
                return;
            }
        }
        //NSLog(@"高德01-location:%@", location);
        
        CLLocationCoordinate2D coordinate = location.coordinate;
        //NSLog(@"高德01-您的当前位置:经度：%f,纬度：%f,海拔：%f,航向：%f,速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
        [self searchReGeocodeWithCoorDinate:coordinate];
        CLLocationDegrees latitude = coordinate.latitude;
        CLLocationDegrees longitude = coordinate.longitude;
        NSString *latitudestr = [NSString stringWithFormat:@"%lf",latitude];
        NSString *longitudestr = [NSString stringWithFormat:@"%lf",longitude];

        //ghj do 这两行代码可在下面的block中执行
//        [NSUserDefaults saveLatitudestr:latitudestr];
//        [NSUserDefaults saveLongitudestr:longitudestr];
        
        NSDictionary *dic = @{@"latitude":latitudestr,@"longitude":longitudestr};
        if (self.getLatitudeAndLongitude) {
            self.getLatitudeAndLongitude(@"",dic);
        }
        
        
        if (regeocode)
        {
            NSString *str = @"";
            
            if ([[regeocode AOIName] length]>0) {
                str =[regeocode AOIName];
            }else{
                if ([[regeocode POIName] length]>0) {
                    str =[regeocode POIName];
                }else{
                    if ([[regeocode street] length]>0) {
                        str =[regeocode street];
                    }
                }
            }
            


            NSDictionary *ttDic =@{@"address":[NSString stringWithFormat:@"%@",str],
                                   @"address_longitude":[NSString stringWithFormat:@"%@,%@",longitudestr,latitudestr],
                                   @"city":[regeocode city],
                                   @"district":[regeocode district],
                                   @"location_name":[NSString stringWithFormat:@"%@",str],
                                   @"province":[regeocode province],
                                   @"number":[regeocode number],
                                   @"street":[regeocode street]

            };
            //下面两行代码可在getNearByAddrInfo block中执行
//            [NSUserDefaults saveFuJinDic:ttDic];
//            [NSUserDefaults saveOneNearByAddressName:[NSString stringWithFormat:@"%@",str]];
            if (self.getNearByAddrInfo){
                self.getNearByAddrInfo(ttDic);
            }
            
            if (self.getWeizhi) {
                self.getWeizhi(nil,regeocode.province,
                               regeocode.city,
                               regeocode.district,
                               regeocode.street,
                               location.coordinate);
            }
        }
    }];
}

-(void)endMap{
    [_AMapLocationManager stopUpdatingLocation];
}

-(void)searchReGeocodeWithCoorDinate:(CLLocationCoordinate2D)coordinate{
    AMapSearchAPI*search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
    NSArray*searchTypes = @[@"住宅", @"学校", @"楼宇", @"商场"];
    NSString*currentType = searchTypes.firstObject;
    
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude  longitude:coordinate.longitude];
    
    request.radius = 5000;             /// 搜索范围
    request.types = currentType;   ///搜索类型
    request.sortrule = 0;               ///排序规则
    [search AMapPOIAroundSearch:request];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
}


- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    //NSLog(@"高德01-错误%@",error.description);
}

- (void)dealloc{
    NSLog(@"SKKit SKLocation dealloc");
}
@end

