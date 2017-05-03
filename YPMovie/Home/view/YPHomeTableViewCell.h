//
//  YPHomeTableViewCell.h
//  YPMovie
//
//  Created by apple on 2017/5/1.
//  Copyright © 2017年 SP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPHomeModel.h"

@protocol turnToReserve <NSObject>

-(void)turnToReservePage:(id)obj;

@end

@interface YPHomeTableViewCell : UITableViewCell
//模型
@property(nonatomic,strong) YPHome * home;

@property(nonatomic,strong) id<turnToReserve>delegate;

@end
