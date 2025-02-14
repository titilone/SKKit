//
//  OleGDMap.h
//  OleApp
//
//  Created by zen on 2021/9/2.
//  Copyright © 2021 crv.jp007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKLocation : NSObject

+(instancetype)defaultAInit:(NSString*)apiKey;
//先调用shareInstance，再调用createAMapLocationServices传入apiKey初始化
//-(void)createAMapLocationServices:(NSString*)apiKey;

-(void)startMap;
-(void)endMap;

@property (nonatomic,copy)void(^getAuthorizationStatus)(CLAuthorizationStatus status);
@property (nonatomic,copy)void(^getLatitudeAndLongitude)(NSString *err,NSDictionary *dic);
@property (nonatomic,copy)void(^getNearByAddrInfo)(NSDictionary *addrInfo);
@property (nonatomic,copy)void(^getWeizhi)(NSString *err,NSString *province,NSString *name,NSString *district,NSString *address, CLLocationCoordinate2D location);
@property (nonatomic,copy)void(^getLatitudeAndLongitudeFail)(void);

//+(MAMapView *)mapView;
@end

NS_ASSUME_NONNULL_END
