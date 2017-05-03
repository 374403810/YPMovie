//
//  ZFSeatButton.m


#import "ZFSeatButton.h"
#import "UIView+Extension.h"
#import "ZFSeatSelectionConfig.h"
@implementation ZFSeatButton
-(void)setHighlighted:(BOOL)highlighted{}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat btnScale = ZFSeatBtnScale;
    CGFloat btnX = (self.width - self.width * btnScale) * 0.5;
    CGFloat btnY = (self.height - self.height * btnScale) * 0.5;
    CGFloat btnW = self.width * btnScale;
    CGFloat btnH = self.height * btnScale;
    self.imageView.frame = CGRectMake(btnX, btnY, btnW, btnH);
}
-(BOOL)isSeatAvailable{
    return [self.seatmodel.st isEqualToString:@"N"];
}
@end
