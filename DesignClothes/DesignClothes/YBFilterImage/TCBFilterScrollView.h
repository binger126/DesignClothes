//
//  TCBFilterScrollView.h
//  TCBFilterScrollView
//
//  Created by TCB on 16/9/27.
//  Copyright © 2016年 TCB. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCBFilterScrollViewDelegate <NSObject>
@required;
- (void)filterImage:(UIImage *)editedImage;
@optional;
// 测试有返回值的代理
- (NSString *)deliverStr:(NSString *)originalStr;
@end


@interface TCBFilterScrollView : UIScrollView

/**滤镜scrollView的高*/
@property (nonatomic, assign) CGFloat filterScrollViewW;
/**内切间距*/
@property (nonatomic, assign) CGFloat insert_space;
/**名字数组*/
@property (nonatomic, copy) NSArray *titleArray;
/**label的高*/
@property (nonatomic, assign) CGFloat labelH;
/**每个小方图的宽和高*/
@property (nonatomic, assign) CGFloat perButtonW_H;
/**原始图片*/
@property (nonatomic, strong) UIImage *originImage;
/**TCBFilterScrollViewDelegate*/
@property (nonatomic,weak) id<TCBFilterScrollViewDelegate> filterDelegate;

/**
 *  开始加载滤镜的scrollView
 */
- (void)loadScrollView;


@end
