//
//  ViewController.m
//  百度地图demo
//
//  Created by zx_05 on 15/9/23.
//  Copyright (c) 2015年 zx_05. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMapKit.h>
@interface ViewController ()<BMKGeneralDelegate,BMKMapViewDelegate>{
    
    BMKMapView *mapView ;
}
@property(strong,nonatomic)BMKMapManager *mgr;
//@property(strong,nonatomic)BMKPoiSearch *search;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mgr = [[BMKMapManager alloc] init];
    [self.mgr start:@"rdNZx5XmxxaImUL95MMWbQta" generalDelegate:self];
    mapView = [[BMKMapView alloc] init];
    mapView.showsUserLocation = YES;
    mapView.frame = self.view.bounds;
    [mapView setMapType:BMKMapTypeStandard];
    [self.view addSubview:mapView];
//    [mapView setTrafficEnabled:YES];
//    [mapView setBaiduHeatMapEnabled:YES];
//    self.search =[[BMKPoiSearch alloc]init];
//    self.search.delegate = self;
//    [self.search poiSearchInCity:<#(BMKCitySearchOption *)#>]
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
}
- (void) viewDidAppear:(BOOL)animated {
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"这里是北京";
    [mapView addAnnotation:annotation];
    //构建顶点数组
    CLLocationCoordinate2D coords[5] = {0};
    coords[0].latitude = 39.965;
    coords[0].longitude = 116.404;
    coords[1].latitude = 39.925;
    coords[1].longitude = 116.454;
    coords[2].latitude = 39.955;
    coords[2].longitude = 116.494;
    coords[3].latitude = 39.905;
    coords[3].longitude = 116.654;
    coords[4].latitude = 39.965;
    coords[4].longitude = 116.704;
    //构建分段纹理索引数组
    NSArray *textureIndex = [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:0],
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:2],
                             [NSNumber numberWithInt:1], nil];
    
    //构建BMKPolyline,使用分段纹理
    BMKPolyline* polyLine = [BMKPolyline polylineWithCoordinates:coords count:5 textureIndex:textureIndex];
    //添加分段纹理绘制折线覆盖物
    [mapView addOverlay:polyLine];
}
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 5;
        polylineView.isFocus = YES;// 是否分段纹理绘制（突出显示），默认YES
        //加载分段纹理图片，必须否则不能进行分段纹理绘制
        [polylineView loadStrokeTextureImages:
         [NSArray arrayWithObjects:[UIImage imageNamed:@"road_blue_arrow.png"],
          [UIImage imageNamed:@"road_green_arrow.png"],
          [UIImage imageNamed:@"road_red_arrow.png"],nil]];
        return polylineView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --百度地图联网 授权 代理
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark -- BMKPoiSearchDelegate

/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
//- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
//    for (BMKPoiInfo *info in poiResult.poiInfoList) {
//        
//    }
//    
//    
//}

@end
