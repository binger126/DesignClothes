//
//  TCBGripViewBorderView.m
//
//  Created by TCB on 6/3/13.
//  Copyright (c) 2013 tcb. All rights reserved.
//

#import "TCBGripViewBorderView.h"

@implementation TCBGripViewBorderView

#define kTCBUserResizableViewGlobalInset 5.0
#define kTCBUserResizableViewDefaultMinWidth 48.0
#define kTCBUserResizableViewDefaultMinHeight 48.0
#define kTCBUserResizableViewInteractiveBorderSize 10.0

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Clear background to ensure the content view shows through.
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextAddRect(context, CGRectInset(self.bounds, kTCBUserResizableViewInteractiveBorderSize/2, kTCBUserResizableViewInteractiveBorderSize/2));
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

@end
