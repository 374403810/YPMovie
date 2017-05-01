

#import "YPHomeBannerView.h"
#import "YPHomeModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YPHomeBannerView()<UIScrollViewDelegate>
//滑动视图
@property(nonatomic,strong) UIScrollView    * scrollview;
//定时器
@property(nonatomic,strong) NSTimer         * timer;
//页控制器
@property(nonatomic,strong) UIPageControl   * pageControl;
//模型
@property(nonatomic,strong) YPHome          * home;

@property(nonatomic,assign) BOOL              flag;

@property(nonatomic,assign) NSInteger         location;
@end

@implementation YPHomeBannerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame=CGRectMake(0, 0, SCREENWIDTH, 200);
        //1
        UIScrollView * scrollview = [[UIScrollView alloc]init];
        self.scrollview=scrollview;
        [self addSubview:scrollview];
        //2
        UIPageControl * pageControl = [[UIPageControl alloc]init];
        self.pageControl=pageControl;
        [self addSubview:pageControl];
    }
    return self;
}
-(void)setBannerArray:(NSMutableArray *)bannerArray{
    _bannerArray=bannerArray;
    
    self.flag=NO;
    self.location=self.frame.size.width;
    //    判断图片数量
    if (bannerArray.count>1) {
        self.scrollview.contentSize=CGSizeMake((bannerArray.count+2)*self.frame.size.width, 0);
    }else{
        self.scrollview.contentSize=CGSizeMake((bannerArray.count)*self.frame.size.width, 0);
    }
    self.scrollview.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollview.showsHorizontalScrollIndicator=NO;
    self.scrollview.bounces=NO;
    self.scrollview.delegate=self;
    self.scrollview.pagingEnabled=YES;
    self.scrollview.contentOffset=CGPointMake(self.frame.size.width, 0);
    
    //  添加pageControl
    self.pageControl.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
    self.pageControl.numberOfPages=self.bannerArray.count;
    self.pageControl.currentPage=1;
    self.pageControl.currentPageIndicatorTintColor=YPSYSTEMCOLOR(redColor);
    self.pageControl.pageIndicatorTintColor=YPSYSTEMCOLOR(grayColor);
    
    if (bannerArray.count>1) {
        for (int i=0; i<bannerArray.count+2; i++) {
            UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            
            if (i==0) {                         //  添加第一张图（数组最后一张）
                self.home = bannerArray[bannerArray.count-1];
            }else if (i==bannerArray.count+1){  //  添加最后一张图（数组第一张）
                self.home = bannerArray[0];
            }else{
                self.home = bannerArray[i-1];
            }
            
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            [imageview sd_setImageWithURL:[NSURL URLWithString:self.home.cover] placeholderImage:[UIImage imageNamed:BACKGROUNDIMAGE]];
            [self.scrollview addSubview:imageview];
            
            //  添加点击手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
            imageview.userInteractionEnabled=YES;
            [imageview addGestureRecognizer:tap];
        }
    }else{
        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        imageview.image=[UIImage imageNamed:bannerArray[0]];
        [self.scrollview addSubview:imageview];
        
        //  添加点击手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        imageview.userInteractionEnabled=YES;
        [imageview addGestureRecognizer:tap];
    }
    //    延迟0.5添加定时器
    [self performSelector:@selector(createTimer) withObject:nil afterDelay:0.50];
}
-(void)createTimer{
    self.flag=NO;
    //  添加定时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(time) userInfo:nil repeats:YES];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.flag) {
        if (self.scrollview.contentOffset.x<self.location) {//    向右滑
            if (self.scrollview.contentOffset.x<=0) {
                self.location = self.bannerArray.count * self.frame.size.width;
                [self.scrollview setContentOffset:CGPointMake(self.bannerArray.count * self.frame.size.width, 0) animated:NO];
            }
        }else if (self.scrollview.contentOffset.x>self.location){//     向左滑
            if (self.scrollview.contentOffset.x>=(self.bannerArray.count+1) * self.frame.size.width) {
                [self.scrollview setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
            }
        }
    }
    int page = self.scrollview.contentOffset.x/self.frame.size.width;
    self.pageControl.currentPage=page%self.bannerArray.count;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{//    开始拖拽
    self.flag=YES;
    [self.timer invalidate];
    self.timer=nil;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{//将要停止拖拽
    

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{//停止拖拽
    self.location=self.scrollview.contentOffset.x;
    [self createTimer];
}
#pragma mark - time
-(void)time{
    
    NSInteger page = self.scrollview.contentOffset.x/self.frame.size.width;
    
    [self.scrollview setContentOffset:CGPointMake((page+1)*self.frame.size.width, 0) animated:YES];
    if (page==self.bannerArray.count) {
        self.scrollview.contentOffset=CGPointMake(0, 0);
    }
    // 重新寻找坐标
    self.location=self.scrollview.contentOffset.x;
}
//页面退出清除timer
-(void)dealloc{
    [self.timer invalidate];
    self.timer=nil;
}

#pragma mark 点击手势
-(void)tap{
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
