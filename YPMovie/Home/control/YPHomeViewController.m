//
//  YPHomeViewController.m
//  YPMovie
//
//  Created by apple on 2017/4/21.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPHomeViewController.h"
#import "TLCityPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <MJExtension/MJExtension.h>
#import "YPHomeModel.h"
#import "YPHomeBannerView.h"
#import "YPHomeTableViewCell.h"
#import "YPHomeSectionTableViewCell.h"

@interface YPHomeViewController ()<TLCityPickerDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIButton * location;

@property(nonatomic,strong) CLLocationManager * locationManager;

@property(nonatomic,strong) CLGeocoder * geocoder;

@property(nonatomic,strong) TLCityPickerController * city;

@property(nonatomic,strong) NSMutableArray * bannerArray;

@property(nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation YPHomeViewController
-(NSMutableArray *)bannerArray{
    if (_bannerArray==nil) {
        _bannerArray=[NSMutableArray array];
    }
    return _bannerArray;
}
-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self setSubViews];
    
    
    // Do any additional setup after loading the view.
}
#pragma initData
- (void)initData{
    //获取地理位置
    CLLocationManager * locationManager = [[CLLocationManager alloc]init];
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    self.locationManager=locationManager;
    self.geocoder=geocoder;
    locationManager.delegate=self;
    
    //加载数据
    NSString * dataPath = [[NSBundle mainBundle]pathForResource:@"YPData" ofType:@"json"];
    NSData * data = [NSData dataWithContentsOfFile:dataPath];
    id  responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    YPHomeModel * homeModel = [YPHomeModel mj_objectWithKeyValues:responseObject];
    NSMutableArray * noneArray = [NSMutableArray array];
    NSMutableArray * playArray = [NSMutableArray array];
    for (int i=0; i<homeModel.result.count; i++) {
        YPHome * home = homeModel.result[i];
        if ([home.vdo_status isEqualToString:@"none"]) {
            [self.bannerArray addObject:home];
            [noneArray addObject:home];
        }else{
            [playArray addObject:home];
        }
    }
    [self.dataArray addObject:noneArray];
    [self.dataArray addObject:playArray];
}
#pragma mark - setSubViews
- (void)setSubViews{
    self.view.backgroundColor=YPSYSTEMCOLOR(whiteColor);
    //自定义导航栏
    [self customNavgation];
    
    //设置主视图
    [self setTableView];
}
#pragma mark - 监听用户授权状态
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined://用户未决定
            NSLog(@"用户未决定");
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
            break;
        case kCLAuthorizationStatusRestricted://访问受限
            NSLog(@"访问受限，苹果预留选项");
            break;
        case kCLAuthorizationStatusDenied://定位关闭时调用
            
            //定位是否开启
            if (![CLLocationManager locationServicesEnabled]) {
                NSLog(@"拒绝定位开启");
                //跳转设置开启定位
                NSURL * settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:settingURL]) {
                    [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:nil];
                }
            }
            else{
                NSLog(@"定位关闭");
            }
            break;
        case kCLAuthorizationStatusAuthorizedAlways://获取前后台定位授权
            NSLog(@"用户已授权");
            //开启定位
            [self.locationManager startUpdatingLocation];
            break;
            
        default:
            break;
    }
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation * location = [locations firstObject];
    //地理反编译
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//此处有placemarks为nil的bug  先用西安作为定位城市
//        if (placemarks.count>0) {
            CLPlacemark * placemark = [placemarks firstObject];
            //获取城市
            NSString * cityStr = placemark.locality;
            if (!cityStr) {
                //直辖市无法通过locality获得，通过省份获取
                cityStr = placemark.administrativeArea;
            }            
            //显示定位城市
            [self.location setTitle:@"西安" forState:UIControlStateNormal];
            //遍历城市名plist
            NSArray * cityPlistArray = [NSArray arrayWithContentsOfFile:@"CityData.plist"];
            for (NSDictionary * itemDic in cityPlistArray) {
                NSArray * citysArray = itemDic[@"citys"];
                for (NSDictionary * cityDic in citysArray) {
                    if ([cityStr isEqualToString:cityDic[@"city_name"]]) {
                        //设置定位城市
                        self.city.locationCityID=cityDic[@"city_key"];
                    }
                }
            }

//        }
    }];
    //关闭定位
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - setTableView
- (void)setTableView{
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    tableview.showsVerticalScrollIndicator=NO;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;//去除分割线
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    
    //设置banner视图
    YPHomeBannerView * bannerView = [[YPHomeBannerView alloc]init];
    bannerView.bannerArray=self.bannerArray;
    tableview.tableHeaderView=bannerView;

}
#pragma mark - UITableViewDelegate and UITableViewDataSource

#pragma mark - 设置分组内单元高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 150;
    }else{
        return 250;
    }
}
#pragma mark - 返回的分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
#pragma mark - 返回每组的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * array = self.dataArray[section];
    return array.count;
}
#pragma mark - 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * firstCell = @"firstCell";
    static NSString * secondCell = @"secondCell";
    
    if (indexPath.section==0) {
        YPHomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:firstCell];
        if (cell==nil) {
            cell=[[YPHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstCell];
        }
        YPHome * home = self.dataArray[indexPath.section][indexPath.row];
        cell.home=home;
        return cell;
    }else{
        YPHomeSectionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:secondCell];
        if (cell==nil) {
            cell=[[YPHomeSectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondCell];
        }
        YPHome * home = self.dataArray[indexPath.section][indexPath.row];
        cell.home=home;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    //textColor
    UITableViewHeaderFooterView * header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:YPSYSTEMCOLOR(blackColor)];
    header.textLabel.font=[UIFont systemFontOfSize:14];
    //backgroundColor
    header.contentView.backgroundColor=YPCOLOR(242, 238, 219);
}
#pragma mark - 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        NSString * one = @"热门电影";
        return one;
    }else{
        NSString * two = @"本周精选";
        return two;
    }
}
#pragma mark - 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
#pragma  mark - customNavgation
- (void)customNavgation{
    self.navigationController.navigationBar.hidden=YES;
    //自定义导航栏
    UIView * nav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    nav.backgroundColor=YPCOLOR(123, 19, 29);
    [self.view addSubview:nav];
    //设置标题
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH/2 -50, 20, 100, 44)];
    title.text=@"影院通";
    title.textColor=YPSYSTEMCOLOR(whiteColor);
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:18];
    [nav addSubview:title];
    //设置定位
    UIButton * location = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 80, 44)];
    self.location=location;
    location.titleLabel.textAlignment=NSTextAlignmentRight;
    location.titleLabel.textColor=YPSYSTEMCOLOR(whiteColor);
    [location addTarget:self action:@selector(locationTouch) forControlEvents:UIControlEventTouchUpInside];
    [nav addSubview:location];
    
    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(location.frame.origin.x+location.frame.size.width, 0, 15, location.frame.size.height)];
    arrow.center=CGPointMake(arrow.center.x, location.center.y);
    arrow.image=[UIImage imageNamed:@"location_arrow"];
    arrow.contentMode=UIViewContentModeCenter;
    [nav addSubview:arrow];
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    tap.numberOfTapsRequired=1;//点击次数
    tap.numberOfTouchesRequired=1;//手指个数
    arrow.userInteractionEnabled=YES;//交互
    [arrow addGestureRecognizer:tap];
    
}
#pragma mark - 定位按钮实现方法
- (void)locationTouch{
    TLCityPickerController * city = [[TLCityPickerController alloc]init];
    self.city=city;
    city.delegate=self;
    city.locationCityID = @"1400010000";
    city.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:city] animated:YES completion:^{
        
    }];
}
#pragma mark - TLCityDelegate
- (void) cityPickerController:(TLCityPickerController *)cityPickerViewController didSelectCity:(TLCity *)city
{
    [self.location setTitle:city.cityName forState:UIControlStateNormal];
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cityPickerControllerDidCancel:(TLCityPickerController *)cityPickerViewController
{
    [cityPickerViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 箭头点击手势
- (void)tap{
    [self locationTouch];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
