//
//  NYTabBarItem.h
//  ThinkSNSPlus
//
//  Created by ningye on 2019/5/3.
//  Copyright © 2019 ZhiYiCX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NYTabBarItem : UIButton

@property (nonatomic,readonly) UITabBarItem *barItem;
@property (nonatomic,readonly) BOOL isLoading;

- (instancetype)initWithTabBarItem:(UITabBarItem *)barItem;

- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;

- (void)showBadgeDot;
- (void)showBadgeValue:(NSString *)badgeValue;
- (void)hideBadge;

@end

NS_ASSUME_NONNULL_END
@interface UITabBarItem (NYTabBarItem)

@property (nonatomic,retain) NYTabBarItem *barItem;
@property (nullable, nonatomic, copy) NSString *xyBadgeValue;

@end
