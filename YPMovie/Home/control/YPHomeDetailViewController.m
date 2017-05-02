//
//  YPHomeDetailViewController.m
//  YPMovie
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPHomeDetailViewController.h"
#import "YPMainTabbarViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface YPHomeDetailViewController ()

@end

@implementation YPHomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=YPCOLOR(248, 243, 253);
    
    [self initData];
    
    [self setSubViews];
}
#pragma mark - 加载数据
-(void)initData{
    
}
#pragma mark - 设置视图
-(void)setSubViews{
    __weak typeof(self) weakSelf = self;
    //1.背景图片
    UIImageView * backImageView = [[UIImageView alloc]init];
    [backImageView sd_setImageWithURL:[NSURL URLWithString:self.home.cover] placeholderImage:[UIImage imageNamed:BACKGROUNDIMAGE]];
    backImageView.userInteractionEnabled=YES;
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(300);
    }];
    //2.背景
    UIView * backView = [[UIView alloc]init];
    backView.backgroundColor=YPSYSTEMCOLOR(whiteColor);
    backView.clipsToBounds=YES;
    backView.layer.cornerRadius=6;
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(200, 10, 0, 10));
        make.height.mas_equalTo(weakSelf.view.frame.size.height-200-20);
    }];
    //3.海报
    UIImageView * imageview = [[UIImageView alloc]init];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.home.cover] placeholderImage:[UIImage imageNamed:BACKGROUNDIMAGE]];
    [self.view addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(160, 30, 0, 0));
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(180);
    }];
    //4.标题
    UILabel * title = [[UILabel alloc]init];
    title.text=self.home.title;
    [backView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview.mas_right).offset(10);
        make.top.equalTo(backView.mas_top).offset(10);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    title.font=[UIFont systemFontOfSize:16];
    //5.标签
    UILabel * tags = [[UILabel alloc]init];
    tags.text=self.home.tag;
    [backView addSubview:tags];
    [tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview.mas_right).offset(10);
        make.top.equalTo(title.mas_bottom).offset(20);
        make.right.equalTo(backView.mas_right).offset(-50);
        make.height.mas_equalTo(20);
    }];
    tags.font=[UIFont systemFontOfSize:12];
    tags.textColor=YPSYSTEMCOLOR(lightGrayColor);
    //6.评分
    UILabel * rating = [[UILabel alloc]init];
    rating.text=[NSString stringWithFormat:@"评分: %@",self.home.rating];
    [backView addSubview:rating];
    [rating mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageview.mas_right).offset(10);
        make.top.equalTo(tags.mas_bottom).offset(20);
        make.right.equalTo(backView.mas_right).offset(-50);
        make.height.mas_equalTo(20);
    }];
    rating.font=[UIFont systemFontOfSize:12];
    rating.textColor=YPSYSTEMCOLOR(lightGrayColor);
    //7.价格
    UILabel * price = [[UILabel alloc]init];
    price.text=@"49元";
    [backView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_top).offset(60);
        make.right.equalTo(backView.mas_right).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    price.textColor=YPSYSTEMCOLOR(redColor);
    price.textAlignment=NSTextAlignmentCenter;
    price.font=[UIFont systemFontOfSize:30];
    //8.简介
    UILabel * intro = [[UILabel alloc]init];
    intro.text=[NSString stringWithFormat:@"简介: %@",self.home.desc];
    [backView addSubview:intro];
    intro.font=[UIFont systemFontOfSize:14];
    intro.textColor=YPSYSTEMCOLOR(lightGrayColor);
    intro.numberOfLines=0;
    CGRect rect = [self calculateText:self.home.desc withSize:14];
    [intro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageview.mas_bottom).offset(20);
        make.left.equalTo(backView.mas_left).offset(20);
        make.right.equalTo(backView.mas_right).offset(-20);
        make.height.mas_equalTo(rect.size.height);
    }];
    //9.立即预约
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [backView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(backView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        make.height.mas_equalTo(40);
    }];
    button.backgroundColor=YPCOLOR(123, 19, 29);
    [button setTitle:@"立即预定" forState:UIControlStateNormal];
    [button setTitleColor:YPSYSTEMCOLOR(whiteColor) forState:UIControlStateNormal];
    //10.返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImageView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(backImageView).insets(UIEdgeInsetsMake(10, 10, 0, 0));
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [backButton setImage:[UIImage imageNamed:@"arrow1.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 返回按钮
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 计算文本frame
-(CGRect)calculateText:(NSString *)string withSize:(NSInteger)size{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.view.frame.size.width-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;//隐藏tabbar
}








@end
