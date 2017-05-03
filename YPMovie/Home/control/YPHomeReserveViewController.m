//
//  YPHomeReserveViewController.m
//  YPMovie
//
//  Created by apple on 2017/5/3.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPHomeReserveViewController.h"
#import <Masonry/Masonry.h>
#import "ZFSeatsModel.h"
#import <MJExtension/MJExtension.h>
#import "MBProgressHUD.h"
#import "ZFSeatSelectionView.h"

@interface YPHomeReserveViewController ()

/**按钮数组*/
@property (nonatomic,strong) NSMutableArray         * selecetedSeats;

@property (nonatomic,strong) NSMutableDictionary    *allAvailableSeats;//所有可选的座位

@property (nonatomic,strong) NSMutableArray         *seatsModelArray;

@property (nonatomic,strong) ZFSeatSelectionView    *selectionView;

@property (nonatomic,strong) UILabel                * payLabel;
@end

@implementation YPHomeReserveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=YPCOLOR(248, 243, 253);
    
    [self initData];
    
    [self setSubViews];
}
-(void)initData{
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
    
    HUD.tintColor = [UIColor blackColor];
    [self.view addSubview:HUD];
    [HUD showAnimated:YES];
    __weak typeof(self) weakSelf = self;
    //模拟延迟加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"seats %zd.plist",arc4random_uniform(5)] ofType:nil];
        //模拟网络加载数据
        NSDictionary *seatsDic = [NSDictionary dictionaryWithContentsOfFile:path];
        __block  NSMutableArray *  seatsArray = seatsDic[@"seats"];
        
        __block  NSMutableArray *seatsModelArray = [NSMutableArray array];
        
        [seatsArray enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
            ZFSeatsModel *seatModel = [ZFSeatsModel mj_objectWithKeyValues:obj];
            [seatsModelArray addObject:seatModel];
        }];
        [HUD hideAnimated:YES];
        weakSelf.seatsModelArray = seatsModelArray;
        
        //数据回来初始化选座模块
        [weakSelf initSelectionView:seatsModelArray];
        
    });

}
-(void)setSubViews{
    //1.添加自定义导航栏
    UIView * nav=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    nav.backgroundColor=YPCOLOR(123, 19, 29);
    [self.view addSubview:nav];
    //2.标题
    __weak typeof(self) weakSelf = self;
    
    UILabel * title = [[UILabel alloc]init];
    title.text=self.home.title;
    [nav addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(nav);
        make.width.mas_equalTo(weakSelf.view.frame.size.width-50*2);
        make.height.mas_equalTo(nav.frame.size.height);
    }];
    title.textColor=YPSYSTEMCOLOR(whiteColor);
    title.textAlignment=NSTextAlignmentCenter;
    title.font=[UIFont systemFontOfSize:18];
    //3.返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nav addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nav.mas_left).offset(10);
        make.centerY.equalTo(nav);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [backButton setImage:[UIImage imageNamed:@"arrow1.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //4.电影片信息
    UIView * ticket = [[UIView alloc]init];
    ticket.backgroundColor=YPSYSTEMCOLOR(whiteColor);
    [self.view addSubview:ticket];
    [ticket mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(10+64, 10, 0, 10));
        make.height.mas_equalTo(150);
    }];
    ticket.clipsToBounds=YES;
    ticket.layer.cornerRadius=6;
    //5.影院名称
    UILabel * name = [[UILabel alloc]init];
    name.text=@"金逸国际影城";
    [ticket addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(ticket).insets(UIEdgeInsetsMake(10, 20, 0, 0));
        make.width.mas_equalTo(weakSelf.view.frame.size.width-20*2-50);
        make.height.mas_equalTo(30);
    }];
    name.font=[UIFont systemFontOfSize:16];
    //6.开演时间
    UILabel * intro = [[UILabel alloc]init];
    intro.text=@"今天5月3号   16:40     英语3D";
    [ticket addSubview:intro];
    [intro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name.mas_bottom).offset(10);
        make.left.equalTo(ticket.mas_left).offset(20);
        make.width.mas_equalTo(weakSelf.view.frame.size.width-20*2);
        make.height.mas_equalTo(25);
    }];
    intro.textColor=YPSYSTEMCOLOR(lightGrayColor);
    intro.font=[UIFont systemFontOfSize:14];
    //7.座位信息
    NSMutableArray * hintArray = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        UILabel * hint = [[UILabel alloc]init];
        if (i==0) {
            hint.text=@"白色:可选";
        }else if (i==1){
            hint.text=@"绿色:已选";
        }else{
            hint.text=@"红色:已售";
        }
        hint.textColor=YPSYSTEMCOLOR(lightGrayColor);
        hint.font=[UIFont systemFontOfSize:14];
        [ticket addSubview:hint];
        [hintArray addObject:hint];
    }
    CGFloat padding = ((self.view.frame.size.width-20)-3*80)/4;
    [hintArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80 leadSpacing:padding tailSpacing:padding];
    [hintArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ticket).offset(-20);
        make.height.mas_equalTo(30);
    }];
    //8.
    UIView * payView = [[UIView alloc]init];
    payView.backgroundColor=YPSYSTEMCOLOR(whiteColor);
    [self.view addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(60);
    }];
    //9.
    UIImageView * shopping = [[UIImageView alloc]init];
    shopping.image=[UIImage imageNamed:@"shopping.png"];
    [payView addSubview:shopping];
    [shopping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payView.mas_left).offset(10);
        make.centerY.equalTo(payView);
        make.width.and.height.mas_equalTo(CGSizeMake(25, 25));
    }];
    //10.
    UILabel * payLabel = [[UILabel alloc]init];
    self.payLabel=payLabel;
    payLabel.text=@"已选 0 个座位  共计 0 元";
    payLabel.textColor=YPCOLOR(123, 19, 29);
    payLabel.font=[UIFont systemFontOfSize:16];
    [payView addSubview:payLabel];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopping.mas_right).offset(10);
        make.centerY.equalTo(payView);
        make.right.equalTo(payView.mas_right).offset(-140);
        make.height.mas_equalTo(40);
    }];
    //11.
    UIButton * payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.backgroundColor=YPCOLOR(123, 19, 29);
    [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [payButton setTitleColor:YPSYSTEMCOLOR(whiteColor) forState:UIControlStateNormal];
    payButton.titleLabel.font=[UIFont systemFontOfSize:14];
    payButton.clipsToBounds=YES;
    payButton.layer.cornerRadius=8;
    [payView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.and.bottom.equalTo(payView).insets(UIEdgeInsetsMake(10, 0, 10, 20));
        make.width.mas_equalTo(100);
    }];
    [payButton addTarget:self action:@selector(payButtonTouch) forControlEvents:UIControlEventTouchUpInside];
}
//创建选座模块
-(void)initSelectionView:(NSMutableArray *)seatsModelArray{
    __weak typeof(self) weakSelf = self;
    ZFSeatSelectionView *selectionView = [[ZFSeatSelectionView alloc]initWithFrame:CGRectMake(0, 250,[UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-250-60)
                                                                        SeatsArray:seatsModelArray
                                                                          HallName:@"七号杜比全景声4K厅"
                                                                seatBtnActionBlock:^(NSMutableArray *selecetedSeats, NSMutableDictionary *allAvailableSeats, NSString *errorStr) {
                                                                    self.payLabel.text=[NSString stringWithFormat:@"已选 %zd 个座位  共计 %zd 元",selecetedSeats.count,selecetedSeats.count * 49];
                                                                    NSLog(@"%zd个选中按钮====%zd个可选座位====errorStr====%@",selecetedSeats.count,allAvailableSeats.count,errorStr);
                                                                    if (errorStr) {
                                                                        //错误信息
                                                                        [self showMessage:errorStr];
                                                                    }else{
                                                                        //储存选好的座位及全部可选座位
                                                                        weakSelf.allAvailableSeats = allAvailableSeats;
                                                                        weakSelf.selecetedSeats = selecetedSeats;
                                                                    }
                                                                }];
    self.selectionView=selectionView;
    
    [self.view addSubview:selectionView];
}
#pragma mark - payButton点击
-(void)payButtonTouch{
    if (!self.selecetedSeats.count) {
        [self showMessage:@"您还未选座"];
    }else{
        [self showMessage:@"正在跳转..."];
    }
}
-(void)showMessage:(NSString *)message{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;//隐藏tabbar
}
@end
