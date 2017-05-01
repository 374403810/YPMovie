//
//  YPHomeModel.m
//  YPMovie
//
//  Created by apple on 2017/4/30.
//  Copyright © 2017年 SP. All rights reserved.
//

#import "YPHomeModel.h"
#import <MJExtension/MJExtension.h>
@implementation YPHomeModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"result":@"YPHome"};
}

+(NSDictionary *)mj_objectVideoClassInArray{
    return @{@"video_rec":@"YPHomeVideo_rec"};
}

+(NSDictionary *)mj_objectActClassInArray{
    return @{@"act_s":@"YPHomeAct_s"};
}
@end


@implementation YPHome

@end

@implementation YPHomeVideo_rec

@end

@implementation YPHomeAct_s

@end
