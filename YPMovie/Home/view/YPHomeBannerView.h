//
//  YPHomeBannerView.h
//  YPMovie
//
//  Created by apple on 2017/4/26.
//  Copyright © 2017年 SP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPHomeModel.h"

@protocol turnToDetail<NSObject>

-(void)turnToDetailPage:(id)obj;

@end

@interface YPHomeBannerView : UIView

@property(nonatomic,strong) NSMutableArray * bannerArray;

@property(nonatomic,strong) id<turnToDetail>delegate;

@end
