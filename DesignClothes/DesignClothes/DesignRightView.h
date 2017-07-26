//
//  DesignRightView.h
//  DesignClothes
//
//  Created by WebUser on 17/7/21.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"

@interface DesignRightView : UIView


@property(nonatomic, copy) void(^zoomImageBGBlock)(UIButton *sender);
@property(nonatomic, copy) void(^showSourceBlock)(UIButton *sender);

- (void)setDefaultState:(BOOL)state;

@end
