//
//  YPHomeTableViewCell.m
//  YPMovie
//
//  Created by apple on 2017/5/1.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPHomeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
@end

@implementation YPHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellEditingStyleNone;
        self.backgroundColor=YPCOLOR(242, 238, 219);
        //1.背景
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 150-20)];
        backView.backgroundColor=YPSYSTEMCOLOR(whiteColor);
        [self addSubview:backView];
        //2.图片
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, backView.frame.size.height-20)];
        self.imageview=imageview;
        [backView addSubview:imageview];
        //3.标题
        UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(imageview.frame.origin.x+imageview.frame.size.width+10, imageview.frame.origin.y, backView.frame.size.width-(imageview.frame.origin.x+imageview.frame.size.width+10+30), 30)];
        self.title=title;
        [backView addSubview:title];
        //4.标签
        UILabel * tags = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+title.frame.size.height+5, title.frame.size.width, 20)];
        self.tags=tags;
        [backView addSubview:tags];
        //5.日期
        UILabel * year = [[UILabel alloc]initWithFrame:CGRectMake(tags.frame.origin.x, tags.frame.origin.y+tags.frame.size.height, tags.frame.size.width, 20)];
        self.year=year;
        [backView addSubview:year];
        //6.导演
        UILabel * dir = [[UILabel alloc]initWithFrame:CGRectMake(year.frame.origin.x, year.frame.origin.y+year.frame.size.height+10, backView.frame.size.width-(imageview.frame.origin.x+imageview.frame.size.width+5), 30)];
        self.dir=dir;
        [backView addSubview:dir];
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
    
    self.dir.text=home.dir;
    self.dir.textColor=YPSYSTEMCOLOR(lightGrayColor);
    self.dir.font=[UIFont systemFontOfSize:14];
}
@end
