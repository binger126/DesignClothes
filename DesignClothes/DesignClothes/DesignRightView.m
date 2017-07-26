//
//  DesignRightView.m
//  DesignClothes
//
//  Created by WebUser on 17/7/21.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import "DesignRightView.h"

@interface DesignRightView ()

@property(nonatomic, strong) UIButton *styleBtn;
@property(nonatomic, strong) UIButton *printBtn;
@property(nonatomic, strong) UIButton *imageBtn;
@property(nonatomic, strong) UIButton *textBtn;

@end

@implementation DesignRightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        MyRelativeLayout *rootLayout = [[MyRelativeLayout alloc] init];
        rootLayout.myMargin = 0;
        [self addSubview:rootLayout];
        [rootLayout addSubview:self.styleBtn];
        [rootLayout addSubview:self.printBtn];
        [rootLayout addSubview:self.imageBtn];
        [rootLayout addSubview:self.textBtn];
        self.styleBtn.myWidth = self.printBtn.myWidth = frame.size.width;
        self.imageBtn.myWidth = self.textBtn.myWidth = frame.size.width;
        self.styleBtn.myTopMargin = 0;
        self.printBtn.topPos.equalTo(self.styleBtn.bottomPos);
        self.textBtn.myBottomMargin = 0;
        self.imageBtn.bottomPos.equalTo(self.textBtn.topPos);
        self.styleBtn.myHeight = self.printBtn.myHeight = frame.size.height/4;
        self.imageBtn.myHeight = self.textBtn.myHeight = frame.size.height/4;
        self.styleBtn.myLeftMargin = self.printBtn.myLeftMargin = 0;
        self.imageBtn.myLeftMargin = self.textBtn.myLeftMargin = 0;
    }
    return self;
}

- (void)openPriceClick:(UIButton *)sender
{
    
}

- (void)bigSmallClick:(UIButton *)sender
{
//    [sender setSelected:!sender.isSelected];
    if (self.zoomImageBGBlock) {
        self.zoomImageBGBlock(sender);
    }
}

- (void)unStartClick:(UIButton *)sender
{
    
}

- (void)showSourceClick:(UIButton *)sender
{
    if (self.showSourceBlock) {
        self.showSourceBlock(sender);
    }
}


- (void)setDefaultState:(BOOL)state
{
    [self.textBtn setSelected:state];
}

- (UIButton *)styleBtn
{
    if (!_styleBtn) {
        _styleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_styleBtn setImage:[UIImage imageNamed:@"icon_order_n"] forState:UIControlStateNormal];
        _styleBtn.tag = 1;
        [_styleBtn addTarget:self action:@selector(openPriceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _styleBtn;
}
- (UIButton *)printBtn
{
    if (!_printBtn) {
        _printBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_printBtn setImage:[UIImage imageNamed:@"icon_big_n"] forState:UIControlStateNormal];
        [_printBtn setImage:[UIImage imageNamed:@"icon_small_s"] forState:UIControlStateSelected];
        _printBtn.tag = 2;
        [_printBtn addTarget:self action:@selector(bigSmallClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _printBtn;
}
- (UIButton *)imageBtn
{
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn setImage:[UIImage imageNamed:@"icon_load_ln"] forState:UIControlStateNormal];
        _imageBtn.tag = 3;
        [_imageBtn addTarget:self action:@selector(unStartClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}
- (UIButton *)textBtn
{
    if (!_textBtn) {
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textBtn setImage:[UIImage imageNamed:@"icon_arrow_n"] forState:UIControlStateNormal];
        [_textBtn setImage:[UIImage imageNamed:@"icon_arrow_s"] forState:UIControlStateSelected];
        _textBtn.tag = 4;
        [_textBtn addTarget:self action:@selector(showSourceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
