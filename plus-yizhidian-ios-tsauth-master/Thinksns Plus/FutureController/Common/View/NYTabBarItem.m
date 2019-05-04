//
//  NYTabBarItem.m
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/3.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

#import "NYTabBarItem.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import <objc/runtime.h>
#define WeakSelf                __weak __typeof(&*self)WSelf = self
#define WeakObjc(objc,WObjc)    __weak __typeof(&*objc)WObjc = objc
#define RotateAngle(angle)      ((angle) * M_PI / 180)


@interface NYTabBarItem ()
{
    UIImageView *   _barItemImageView;
    UILabel *       _barItemTitleLabel;
    UILabel *       _badgeView;
    
    UIImageView *   _nobelHeader;
}

@end

@implementation NYTabBarItem

#pragma mark - Override

- (instancetype)initWithTabBarItem:(UITabBarItem *)barItem {
    if (self = [super init]) {
        _barItem = barItem;
        _barItem.barItem = self;
        
        _barItemImageView = [[UIImageView alloc] init];
        _barItemImageView.image = barItem.image;
        _barItemImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_barItemImageView];
        [_barItemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-6);
        }];

        _barItemTitleLabel = [[UILabel alloc] init];
        _barItemTitleLabel.text = barItem.title;
        _barItemTitleLabel.textColor = [UIColor whiteColor];
        _barItemTitleLabel.font = [UIFont systemFontOfSize:10.0f];
        _barItemTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_barItemTitleLabel];
        [_barItemTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_barItemImageView.mas_bottom).offset(2);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(14);
        }];
        
        _badgeView = [[UILabel alloc] init];
        _badgeView.hidden = YES;
        _badgeView.backgroundColor = UIColor.redColor;
        _badgeView.textAlignment = NSTextAlignmentCenter;
        _badgeView.clipsToBounds = YES;
        _badgeView.textColor = UIColor.whiteColor;
        _badgeView.font = [UIFont systemFontOfSize:11.0f];
        [self addSubview:_badgeView];
    }
    return self;
}

- (CGFloat)barItemTitleLabelWidth
{
    CGSize sizeToFit = [_barItemTitleLabel.text sizeWithFont:_barItemTitleLabel.font constrainedToSize:CGSizeMake(CGFLOAT_MAX, _barItemTitleLabel.height)];
    return sizeToFit.width;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.barItem.badgeValue) {
        [self showBadgeValue:self.barItem.badgeValue];
    } else {
        //        [self hideBadge]; 不知道为什么这个要隐藏掉，zjy先把这个注释了
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
//    _barItemTitleLabel.textColor = UIColor.HexStr(selected ? @"#4E4B4B" : @"#A2A2AF");
    if (!_isLoading) {
        _barItemImageView.image = selected ? self.barItem.selectedImage : self.barItem.image;
    }
}

#pragma mark - Badge Value

- (void)showBadgeDot {
    _badgeView.hidden = NO;
    _badgeView.text = nil;
    _badgeView.frame = CGRectMake(_barItemImageView.origin.x, _barItemImageView.origin.y, 10, 10);
    _badgeView.layer.cornerRadius = 5.0f;
}

- (void)showBadgeValue:(NSString *)badgeValue {
    _badgeView.hidden = NO;
    _badgeView.text = badgeValue;
    _badgeView.layer.cornerRadius = 8.0f;
    
    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:_badgeView.font}];
    _badgeView.size = CGSizeMake(MAX(16,ceil(size.width) + 8), 16);
    _badgeView.center = CGPointMake(_barItemImageView.origin.x+5, _barItemImageView.origin.y+5);
}

- (void)hideBadge {
    _badgeView.hidden = YES;
}

#pragma mark - Loading Animation

- (void)startLoadingAnimation {
    if (_isLoading) {
        return;
    }
    
    _isLoading = YES;
    _barItemImageView.image = [UIImage imageNamed:@"tabbar_item_loading"];
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue   = @(RotateAngle(0));
    rotateAnimation.toValue     = @(RotateAngle(360));
    rotateAnimation.repeatCount = HUGE_VALF;
    rotateAnimation.duration    = 1.2;
    [_barItemImageView.layer addAnimation:rotateAnimation forKey:nil];
}

- (void)stopLoadingAnimation {
    [_barItemImageView.layer removeAllAnimations];
    
    _isLoading = NO;
    _barItemImageView.image = self.selected ? self.barItem.selectedImage : self.barItem.image;
}

@end


@implementation UITabBarItem (NYTabBarItem)

- (NYTabBarItem *)barItem {
    return objc_getAssociatedObject(self, @selector(barItem));
}

- (void)setBarItem:(NYTabBarItem *)barItem {
    objc_setAssociatedObject(self, @selector(barItem), barItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setXyBadgeValue:(NSString *)xyBadgeValue {
    self.badgeValue = xyBadgeValue;
    if (xyBadgeValue) {
        [self.barItem showBadgeValue:xyBadgeValue];
    } else {
        [self.barItem hideBadge];
    }
}

@end
