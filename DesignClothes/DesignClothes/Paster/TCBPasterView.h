//
//  TCBPasterView.h
//  TCBPasterView
//
//  Created by apple on 15/7/8.
//  Copyright (c) 2015年 teason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBPasterStageView.h"

//@class TCBPasterView;
@class TCBPasterStageView;

@protocol TCBPasterViewDelegate <NSObject>

- (void)makePasterBecomeFirstRespond:(int)pasterID;
- (void)removePaster:(int)pasterID;

- (void)stickerTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)stickerTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end



@interface TCBPasterView : UIView

@property (nonatomic,strong)    UIImage *imagePaster;
@property (nonatomic)           int     pasterID;
@property (nonatomic)           BOOL    isOnFirst;
@property (nonatomic,weak)    id <TCBPasterViewDelegate> delegate;
- (instancetype)initWithBgView:(TCBPasterStageView *)bgView pasterID:(int)pasterID img:(UIImage *)img;
- (void)remove;

@end
