//
//  YPHomeModel.h
//  YPMovie
//
//  Created by apple on 2017/4/30.
//  Copyright © 2017年 SP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YPHomeModel : NSObject

@property(nonatomic,strong) NSArray * result;

@end

@interface YPHome : NSObject
//标题
@property(nonatomic,copy) NSString * title;
//标签
@property(nonatomic,copy) NSString * tag;
//出演者
@property(nonatomic,copy) NSString * act;
//年份
@property(nonatomic,copy) NSString * year;
//评分
@property(nonatomic,copy) NSString * rating;
//国家
@property(nonatomic,copy) NSString * area;
//导演
@property(nonatomic,copy) NSString * dir;
//简介
@property(nonatomic,copy) NSString * desc;
//海报
@property(nonatomic,copy) NSString * cover;
//类型
@property(nonatomic,copy) NSString * vdo_status;
//相关作品
@property(nonatomic,strong) NSArray * video_rec;
//主演
@property(nonatomic,strong) NSArray * act_s;

@end


@interface YPHomeVideo_rec : NSObject
//详情
@property(nonatomic,copy) NSString * detail_url;
//海报
@property(nonatomic,copy) NSString * cover;
//作品名称
@property(nonatomic,copy) NSString * title;

@end


@interface YPHomeAct_s : NSObject
//演员名称
@property(nonatomic,copy) NSString * name;
//链接
@property(nonatomic,copy) NSString * url;
//图片
@property(nonatomic,copy) NSString * image;

@end














