//
//  YPHomeSectionTableViewCell.m
//  YPMovie
//
//  Created by apple on 2017/5/1.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPHomeSectionTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
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
        self.backgroundColor=YPCOLOR(242, 238, 219);
        //1.背景
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 250-20)];
        backView.backgroundColor=YPSYSTEMCOLOR(whiteColor);
        [self addSubview:backView];
        //2.图片
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, backView.frame.size.width-20, backView.frame.size.height-20)];
        self.imageview=imageview;
        [backView addSubview:imageview];
        //3.标题
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.frame.size.height/2-20, imageview.frame.size.width, 50)];
        self.title=title;
        [imageview addSubview:title];
        //4.专题
        UIImageView * topic = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 100, 40)];
        self.topic=topic;
        [imageview addSubview:topic];
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
