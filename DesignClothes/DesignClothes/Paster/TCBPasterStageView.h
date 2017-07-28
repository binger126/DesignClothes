//
//  TCBPasterStageView.h
//  TCBPasterStageView
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBPasterView.h"

@class TCBPasterView;
//@class TCBPasterStageView;

@protocol TCBPasterStageViewDelegate <NSObject>

- (void)stickerTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)m_filterPaster:(TCBPasterView *)m_filterPaster;

@end
@interface TCBPasterStageView : UIView

@property (nonatomic,strong) UIImage       *originImage;
@property (nonatomic,strong) TCBPasterView *m_filterPaster;
@property (nonatomic,weak) id<TCBPasterStageViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addPasterWithImg:(UIImage *)imgP;
- (UIImage *)doneEdit;

@end
