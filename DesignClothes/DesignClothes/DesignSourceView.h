//
//  DesignSourceView.h
//  DesignClothes
//
//  Created by WebUser on 17/7/21.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayout.h"

@interface DesignSourceView : UIView

@property(nonatomic, strong) NSArray *pasterList;

@property(nonatomic) NSInteger type;

@property(nonatomic, copy) void(^changePasterStageBlock)(UIImage *image);
@property(nonatomic, copy) void(^addPasterImageBlock)(UIImage *image);

@property(nonatomic, copy) void(^filterPasterStageBlock)(UIImage *image);

- (void)cancelFilter;
- (void)setFilter:(UIImage *)originalImage;

@end
