//
//  TCBStickerView.m
//
//  Created by TCB on 5/29/13.
//  Copyright (c) 2013 tcb. All rights reserved.
//

#import "TCBStickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kTCBUserResizableViewGlobalInset 5.0
#define kTCBUserResizableViewDefaultMinWidth 50.0
#define kTCBUserResizableViewDefaultMinHeight 80.0
#define kTCBUserResizableViewInteractiveBorderSize 10.0
#define kTCBStickerViewControlSize 25.0


@interface TCBStickerView ()

@property (strong, nonatomic) UIImageView *zoomControl;
@property (strong, nonatomic) UIImageView *deleteControl;
@property (strong, nonatomic) UIImageView *rotateControl;
@property (strong, nonatomic) UIImageView *editControl;

@property (nonatomic) BOOL preventsLayoutWhileResizing;

@property (nonatomic) CGFloat deltaAngle;
@property (nonatomic) CGPoint prevPoint;
@property (nonatomic) CGAffineTransform startTransform;

@property (nonatomic) CGPoint touchStart;

@property (nonatomic) BOOL isTransform;

@end

@implementation TCBStickerView

@synthesize contentView, touchStart;

@synthesize prevPoint;
@synthesize deltaAngle, startTransform; //rotation
@synthesize zoomControl, deleteControl,rotateControl, editControl;
@synthesize preventsPositionOutsideSuperview;
@synthesize preventsResizing;
@synthesize preventsDeleting;
@synthesize minWidth, minHeight;
@synthesize isTransform;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)singleDeleteTap:(UITapGestureRecognizer *)recognizer {
    if (NO == self.preventsDeleting) {
        UIView * close = (UIView *)[recognizer view];
        [close.superview removeFromSuperview];
    }
    if([_delegate respondsToSelector:@selector(stickerViewDidClose:)]) {
        [_delegate stickerViewDidClose:self];
    }
}
-(void)singleEditTap:(UITapGestureRecognizer *)recognizer {
}

- (void)panTranslate:(UIPanGestureRecognizer *)recognizer {
    CGPoint curP = [recognizer translationInView:self.contentView.superview];
    self.contentView.superview.transform = CGAffineTransformTranslate(self.contentView.superview.transform, curP.x, curP.y);
    // 复位,一定要复位
    [recognizer setTranslation:CGPointZero inView:self.contentView.superview];
//    if (recognizer.state==UIGestureRecognizerStateBegan) {
//        touchStart = [recognizer translationInView:self.superview];
//    }else if (recognizer.state==UIGestureRecognizerStateChanged) {
//        CGPoint touch = [recognizer translationInView:self.superview];
//        [self translateUsingTouchLocation:touch];
//    }else if (recognizer.state==UIGestureRecognizerStateEnded) {
//        touchStart = [recognizer translationInView:self.superview];
//    }
}

- (void)zoom:(UIPanGestureRecognizer *)recognizer {
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x);
    self.tcbGesture = 1;
    [self zoomRotate:recognizer];
}
- (void)rotate:(UIPanGestureRecognizer *)recognizer {
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x - self.center.x);
    self.tcbGesture = 2;
    isTransform = NO;
    [self zoomRotate:recognizer];
}

-(void)zoomRotate:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
//        NSLog(@"--------prevPoint-x-%f \n---------prevPoint--y-%f",prevPoint.x,prevPoint.y);
    }else if (recognizer.state==UIGestureRecognizerStateChanged) {
        
//        CGPoint centerPoint = self.superview.center;
//        NSLog(@"--------centerPoint--x-%f \n---------centerPoint--y-%f",prevPoint.x,prevPoint.y);
        CGFloat wChange = 0.0, hChange = 0.0;
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight) {
            self.bounds = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,minWidth,minHeight);
            if (!isTransform) {
                editControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize, self.bounds.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                zoomControl.frame = CGRectMake(0, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                rotateControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                deleteControl.frame = CGRectMake(0 ,self.bounds.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
//                self.contentView.transform = CGAffineTransformMakeRotation(M_PI);
                self.transform = CGAffineTransformMakeRotation(M_PI);
            }else{
                zoomControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize, self.bounds.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                editControl.frame = CGRectMake(0, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                deleteControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                rotateControl.frame = CGRectMake(0 ,self.bounds.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
//                self.contentView.transform = CGAffineTransformMakeRotation(0.0);
                self.transform = CGAffineTransformMakeRotation(0.0);
            }
            isTransform=!isTransform;
            prevPoint = [recognizer locationInView:self];
            [self setNeedsDisplay];
        }else {
            CGPoint point = [recognizer locationInView:self];
            wChange = (point.x - prevPoint.x);
            hChange = (point.y - prevPoint.y);
            if (ABS(wChange) > 20.0f || ABS(hChange) > 20.0f) {
                prevPoint = [recognizer locationInView:self];
                [self setNeedsDisplay];
                return;
            }
            if (wChange < 0.0f && hChange < 0.0f) {
                CGFloat change = MIN(wChange, hChange);
                wChange = change;
                hChange = change;
            }else if (wChange < 0.0f) {
                hChange = wChange;
            }else if (hChange < 0.0f) {
                wChange = hChange;
            }else {
                CGFloat change = MAX(wChange, hChange);
                wChange = change;
                hChange = change;
            }
            if (self.tcbGesture == 2) {
                wChange = 0.0;
                hChange = 0.0;
            }
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width + (wChange), self.bounds.size.height + (hChange));
//            if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight) {
//                self.bounds = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,minWidth,minHeight);
//            }
            if (!isTransform) {
                zoomControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize,self.bounds.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                editControl.frame = CGRectMake(0, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                deleteControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                rotateControl.frame = CGRectMake(0, self.bounds.size.height-kTCBStickerViewControlSize,kTCBStickerViewControlSize, kTCBStickerViewControlSize);
//                self.contentView.transform = CGAffineTransformMakeRotation(0.0);
            }else{
                editControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize, self.bounds.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                zoomControl.frame = CGRectMake(0, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                rotateControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
                deleteControl.frame = CGRectMake(0 ,self.bounds.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize);
//                self.contentView.transform = CGAffineTransformMakeRotation(M_PI);
            }
            
            prevPoint = [recognizer locationInView:self];
            [self setNeedsDisplay];
        }
    
        /* Rotation */
        if (self.tcbGesture == 2) {
            CGFloat ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                                [recognizer locationInView:self.superview].x - self.center.x);
            CGFloat angleDiff = deltaAngle - ang;
            if (NO == preventsResizing) {
                self.transform = CGAffineTransformMakeRotation(-angleDiff);
            }
        }
        borderView.frame = CGRectInset(self.bounds, kTCBUserResizableViewGlobalInset, kTCBUserResizableViewGlobalInset);
        [borderView setNeedsDisplay];
        [self setNeedsDisplay];
    }else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        prevPoint = [recognizer locationInView:self];
        self.tcbGesture = 3;
        [self setNeedsDisplay];
    }
}

- (void)setupDefaultAttributes {
    borderView = [[TCBGripViewBorderView alloc] initWithFrame:CGRectInset(self.bounds, kTCBUserResizableViewGlobalInset, kTCBUserResizableViewGlobalInset)];
    [borderView setHidden:YES];
    [self addSubview:borderView];
    
    if (kTCBUserResizableViewDefaultMinWidth > self.bounds.size.width*0.3||kTCBUserResizableViewDefaultMinHeight > self.bounds.size.height*0.3) {
        self.minWidth = kTCBUserResizableViewDefaultMinWidth;
        self.minHeight = kTCBUserResizableViewDefaultMinHeight;
    } else {
        self.minWidth = self.bounds.size.width*0.3;
        self.minHeight = self.bounds.size.height*0.3;
    }
    self.preventsPositionOutsideSuperview = YES;
    self.preventsLayoutWhileResizing = YES;
    self.preventsResizing = NO;
    self.preventsDeleting = NO;
    
    editControl = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize)];
    editControl.backgroundColor = [UIColor clearColor];
    editControl.image = [UIImage imageNamed:@"icon_edit"];
    editControl.userInteractionEnabled = YES;
    [editControl sizeThatFits:CGSizeMake(25.0, 25.0)];
    UITapGestureRecognizer *singleEditTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleEditTap:)];
    [editControl addGestureRecognizer:singleEditTap];
    [self addSubview:editControl];
    
    deleteControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kTCBStickerViewControlSize, 0, kTCBStickerViewControlSize, kTCBStickerViewControlSize)];
    deleteControl.backgroundColor = [UIColor clearColor];
    deleteControl.image = [UIImage imageNamed:@"icon_delete"];
    deleteControl.userInteractionEnabled = YES;
    [deleteControl sizeThatFits:CGSizeMake(25.0, 25.0)];
    UITapGestureRecognizer *singleDeleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleDeleteTap:)];
    [deleteControl addGestureRecognizer:singleDeleteTap];
    [self addSubview:deleteControl];
    
    
    rotateControl = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize)];
    rotateControl.backgroundColor = [UIColor clearColor];
    rotateControl.userInteractionEnabled = YES;
    rotateControl.image = [UIImage imageNamed:@"icon_rotate"];
    [rotateControl sizeThatFits:CGSizeMake(25.0, 25.0)];
    UIPanGestureRecognizer *panZoomResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    [rotateControl addGestureRecognizer:panZoomResizeGesture];
    [self addSubview:rotateControl];
    
    zoomControl = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-kTCBStickerViewControlSize,self.frame.size.height-kTCBStickerViewControlSize, kTCBStickerViewControlSize, kTCBStickerViewControlSize)];
    zoomControl.backgroundColor = [UIColor clearColor];
    zoomControl.userInteractionEnabled = YES;
    zoomControl.image = [UIImage imageNamed:@"icon_zoom"];
    [zoomControl sizeThatFits:CGSizeMake(25.0, 25.0)];
    UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    [zoomControl addGestureRecognizer:panResizeGesture];
    [self addSubview:zoomControl];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupDefaultAttributes];
    }
    return self;
}

- (void)setContentView:(UIView *)newContentView {
    [contentView removeFromSuperview];
    contentView = newContentView;
    contentView.frame = CGRectInset(self.bounds, kTCBUserResizableViewGlobalInset + kTCBUserResizableViewInteractiveBorderSize/2, kTCBUserResizableViewGlobalInset + kTCBUserResizableViewInteractiveBorderSize/2);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
    contentView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTranslate:)];
    [self addGestureRecognizer:panResizeGesture];
    
    [self bringSubviewToFront:borderView];
    [self bringSubviewToFront:zoomControl];
    [self bringSubviewToFront:deleteControl];
    [self bringSubviewToFront:editControl];
    [self bringSubviewToFront:rotateControl];
}

- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    contentView.frame = CGRectInset(self.bounds, kTCBUserResizableViewGlobalInset + kTCBUserResizableViewInteractiveBorderSize/2, kTCBUserResizableViewGlobalInset + kTCBUserResizableViewInteractiveBorderSize/2);
    
    borderView.frame = CGRectInset(self.bounds, kTCBUserResizableViewGlobalInset, kTCBUserResizableViewGlobalInset);
    zoomControl.frame =CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize,
                                      self.bounds.size.height-kTCBStickerViewControlSize,
                                      kTCBStickerViewControlSize,
                                      kTCBStickerViewControlSize);
    editControl.frame = CGRectMake(0, 0,
                                     kTCBStickerViewControlSize, kTCBStickerViewControlSize);
    deleteControl.frame = CGRectMake(self.bounds.size.width-kTCBStickerViewControlSize, 0,
                                     kTCBStickerViewControlSize, kTCBStickerViewControlSize);
    rotateControl.frame = CGRectMake(0, self.bounds.size.height-kTCBStickerViewControlSize,
                                   kTCBStickerViewControlSize, kTCBStickerViewControlSize);
    [borderView setNeedsDisplay];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    touchStart = [touch locationInView:self.superview];
//    if([_delegate respondsToSelector:@selector(stickerViewDidBeginEditing:)]) {
//        [_delegate stickerViewDidBeginEditing:self];
//    }
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint touch = [[touches anyObject] locationInView:self.superview];
//    if (self.tcbGesture==3) {
////        [self translateUsingTouchLocation:touch];
//    }
//    touchStart = touch;
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    // Notify the delegate we've ended our editing session.
//    if([_delegate respondsToSelector:@selector(stickerViewDidEndEditing:)]) {
//        [_delegate stickerViewDidEndEditing:self];
//    }
//}
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    // Notify the delegate we've ended our editing session.
//    if([_delegate respondsToSelector:@selector(stickerViewDidCancelEditing:)]) {
//        [_delegate stickerViewDidCancelEditing:self];
//    }
//}
//移动
//- (void)translateUsingTouchLocation:(CGPoint)touchPoint {
//    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
//                                    self.center.y + touchPoint.y - touchStart.y);
//    if (self.preventsPositionOutsideSuperview) {
//        // Ensure the translation won't cause the view to move offscreen.
//        CGFloat midPointX = CGRectGetMidX(self.bounds);
//        if (newCenter.x > self.superview.bounds.size.width - midPointX) {
//            newCenter.x = self.superview.bounds.size.width - midPointX;
//        }
//        if (newCenter.x < midPointX) {
//            newCenter.x = midPointX;
//        }
//        CGFloat midPointY = CGRectGetMidY(self.bounds);
//        if (newCenter.y > self.superview.bounds.size.height - midPointY) {
//            newCenter.y = self.superview.bounds.size.height - midPointY;
//        }
//        if (newCenter.y < midPointY) {
//            newCenter.y = midPointY;
//        }
//    }
//    self.center = newCenter;
//}

- (void)setTcbGesture:(CGFloat)tcbGesture {
    _tcbGesture = tcbGesture;
}


- (void)hideEditingHandles
{
    zoomControl.hidden = YES;
    deleteControl.hidden = YES;
    editControl.hidden = YES;
    rotateControl.hidden = YES;
    [borderView setHidden:YES];
}

- (void)showEditingHandles
{
    zoomControl.hidden = NO;
    deleteControl.hidden = NO;
    editControl.hidden = NO;
    rotateControl.hidden = NO;
    [borderView setHidden:NO];
}

@end
