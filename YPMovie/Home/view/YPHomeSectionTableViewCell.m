//
//  YPHomeSectionTableViewCell.m
//  YPMovie
//
//  Created by apple on 2017/5/1.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPHomeSectionTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

@interface YPHomeSectionTableViewCell()

@property(nonatomic,strong) UIImageView * imageview;

@property(nonatomic,strong) UILabel     * title;

@property(nonatomic,strong) UIImageView     * topic;
@end

@implementation YPHomeSectionTableViewCell

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
            make.edges.equalTo(backView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        //3.标题
        UILabel * title = [[UILabel alloc]init];
        self.title=title;
        [imageview addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(imageview);
        }];
        //4.专题
        UIImageView * topic = [[UIImageView alloc]init];
        self.topic=topic;
        [imageview addSubview:topic];
        [topic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageview.mas_left).offset(5);
            make.top.equalTo(imageview.mas_top).offset(5);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
        }];
    }
    return self;
}
#pragma mark - setHome
-(void)setHome:(YPHome *)home{
    _home=home;
    
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:home.cover] placeholderImage:[UIImage imageNamed:BACKGROUNDIMAGE]];
    
    self.title.text=home.title;
    self.title.textColor=YPSYSTEMCOLOR(whiteColor);
    self.title.font=[UIFont fontWithName:@"Futura-CondensedExtraBold" size:30];
    self.title.textAlignment=NSTextAlignmentCenter;
    
    [self.topic setImage:[UIImage imageNamed:@"topic.png"]];
}
@end
