//
//  TCBStickerView.h
//
//  Created by TCB on 5/29/13.
//  Copyright (c) 2013 tcb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBGripViewBorderView.h"

@protocol TCBStickerViewDelegate;

@interface TCBStickerView : UIView
{
    TCBGripViewBorderView *borderView;
}

@property (assign, nonatomic) UIView *contentView;
@property (nonatomic) BOOL preventsPositionOutsideSuperview; //default = YES
@property (nonatomic) BOOL preventsResizing; //default = NO
@property (nonatomic) BOOL preventsDeleting; //default = NO
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat minHeight;

@property (nonatomic) CGFloat tcbGesture;

@property (strong, nonatomic) id <TCBStickerViewDelegate> delegate;

- (void)hideEditingHandles;
- (void)showEditingHandles;

@end

@protocol TCBStickerViewDelegate <NSObject>
@required
@optional
- (void)stickerViewDidBeginEditing:(TCBStickerView *)sticker;
- (void)stickerViewDidEndEditing:(TCBStickerView *)sticker;
- (void)stickerViewDidCancelEditing:(TCBStickerView *)sticker;
- (void)stickerViewDidClose:(TCBStickerView *)sticker;
@end


