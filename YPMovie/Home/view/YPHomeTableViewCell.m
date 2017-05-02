//
//  YPHomeTableViewCell.m
//  YPMovie
//
//  Created by apple on 2017/5/1.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPHomeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
@interface YPHomeTableViewCell()
//图片
@property(nonatomic,strong) UIImageView * imageview;
//标题
@property(nonatomic,strong) UILabel     * title;
//标签
@property(nonatomic,strong) UILabel     * tags;
//日期
@property(nonatomic,strong) UILabel     * year;
//导演
@property(nonatomic,strong) UILabel     * dir;
//按钮
@property(nonatomic,strong) UIButton    * button;
//预定
@property(nonatomic,strong) UIButton    * resever;
@end

@implementation YPHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellEditingStyleNone;
        self.backgroundColor=YPCOLOR(248, 243, 253);
        __weak typeof(self) weakSelf = self;
        //1.背景
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor=YPSYSTEMCOLOR(whiteColor);
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(10, 10, 10, 10));
        }];
        //2.图片
        UIImageView * imageview = [[UIImageView alloc]init];
        self.imageview=imageview;
        [backView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.bottom.equalTo(backView).insets(UIEdgeInsetsMake(10, 10, 10, 0));
            make.width.mas_equalTo(80);
            
        }];
        //3.标题
        UILabel * title = [[UILabel alloc]init];
        self.title=title;
        [backView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageview.mas_right).offset(10);
            make.top.equalTo(backView.mas_top).offset(10);
            make.right.equalTo(backView.mas_right).offset(-35);
            make.height.mas_equalTo(30);
        }];
        //4.标签
        UILabel * tags = [[UILabel alloc]init];
        self.tags=tags;
        [backView addSubview:tags];
        [tags mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageview.mas_right).offset(10);
            make.top.equalTo(title.mas_bottom).offset(5);
            make.right.equalTo(backView.mas_right).offset(-60);
            make.height.mas_equalTo(20);
        }];
        //5.日期
        UILabel * year = [[UILabel alloc]init];
        self.year=year;
        [backView addSubview:year];
        [year mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageview.mas_right).offset(10);
            make.top.equalTo(tags.mas_bottom).offset(0);
            make.right.equalTo(backView.mas_right).offset(-60);
            make.height.mas_equalTo(20);
        }];
        //6.导演
        UILabel * dir = [[UILabel alloc]init];
        self.dir=dir;
        [backView addSubview:dir];
        [dir mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageview.mas_right).offset(10);
            make.bottom.equalTo(backView.mas_bottom).offset(-10);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.height.mas_equalTo(30);
        }];
        //7.箭头按钮
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button=button;
        [backView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView.mas_top).offset(10);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        //8.预定按钮
        UIButton * resever = [UIButton buttonWithType:UIButtonTypeCustom];
        self.resever=resever;
        [backView addSubview:resever];
        [resever mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(20);
            make.right.equalTo(backView.mas_right).offset(-10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(25);
        }];
        resever.layer.borderWidth=0.5;
        resever.layer.borderColor=YPSYSTEMCOLOR(redColor).CGColor;
    }
    return self;
}
#pragma mark - setHome
-(void)setHome:(YPHome *)home{
    _home=home;
    
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:home.cover] placeholderImage:[UIImage imageNamed:BACKGROUNDIMAGE]];
    
    self.title.text=home.title;
    self.title.font=[UIFont systemFontOfSize:16];
    
    self.tags.text=home.tag;
    self.tags.textColor=YPSYSTEMCOLOR(lightGrayColor);
    self.tags.font=[UIFont systemFontOfSize:12];
    
    self.year.text=home.year;
    self.year.textColor=YPSYSTEMCOLOR(lightGrayColor);
    self.year.font=[UIFont systemFontOfSize:12];
    
    self.dir.text=[NSString stringWithFormat:@"导演:%@",home.dir];
    self.dir.textColor=YPSYSTEMCOLOR(lightGrayColor);
    self.dir.font=[UIFont systemFontOfSize:14];
    
    [self.button setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
    
    [self.resever setTitle:@"预定" forState:UIControlStateNormal];
    [self.resever setTitleColor:YPSYSTEMCOLOR(redColor) forState:UIControlStateNormal];
    self.resever.titleLabel.font=[UIFont systemFontOfSize:14];
}
@end
