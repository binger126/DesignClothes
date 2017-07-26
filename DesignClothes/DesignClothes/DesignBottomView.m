//
//  DesignBottomView.m
//  DesignClothes
//
//  Created by WebUser on 17/7/21.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import "DesignBottomView.h"


@interface DesignBottomView ()

@property(nonatomic, strong) UIButton *styleBtn;
@property(nonatomic, strong) UIButton *printBtn;
@property(nonatomic, strong) UIButton *imageBtn;
@property(nonatomic, strong) UIButton *textBtn;

@property(nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation DesignBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        MyRelativeLayout *rootLayout = [[MyRelativeLayout alloc] init];
        rootLayout.myMargin = 0;
        rootLayout.topBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
        [self addSubview:rootLayout];
        [rootLayout addSubview:self.styleBtn];
        [rootLayout addSubview:self.printBtn];
        [rootLayout addSubview:self.imageBtn];
        [rootLayout addSubview:self.textBtn];
        [self.btnArray addObject:self.styleBtn];
        [self.btnArray addObject:self.printBtn];
        [self.btnArray addObject:self.imageBtn];
        [self.btnArray addObject:self.textBtn];
        self.styleBtn.myHeight = self.printBtn.myHeight = frame.size.height;
        self.imageBtn.myHeight = self.textBtn.myHeight = frame.size.height;
        self.styleBtn.myLeftMargin = 0;
        self.printBtn.leftPos.equalTo(self.styleBtn.rightPos);
        self.textBtn.myRightMargin = 0;
        self.imageBtn.rightPos.equalTo(self.textBtn.leftPos);
        self.styleBtn.myWidth = self.printBtn.myWidth = frame.size.width/4;
        self.imageBtn.myWidth = self.textBtn.myWidth = frame.size.width/4;
        self.styleBtn.myBottomMargin = self.printBtn.myBottomMargin = 0;
        self.imageBtn.myBottomMargin = self.textBtn.myBottomMargin = 0;
    }
    return self;
}


- (void)showSourceClick:(UIButton *)sender
{
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton*)obj;
        if (sender!=btn) {
            [btn setSelected:NO];
        }
    }];
    if (self.showSourceBlock) {
        self.showSourceBlock(sender);
    }
}

- (void)setDefaultState
{
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton*)obj;
        [btn setSelected:NO];
    }];
}

- (UIButton *)styleBtn
{
    if (!_styleBtn) {
        _styleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_styleBtn setImage:[UIImage imageNamed:@"icon_style_n"] forState:UIControlStateNormal];
        _styleBtn.tag = 1;
        [_styleBtn addTarget:self action:@selector(showSourceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _styleBtn;
}
- (UIButton *)printBtn
{
    if (!_printBtn) {
        _printBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_printBtn setImage:[UIImage imageNamed:@"icon_print_n"] forState:UIControlStateNormal];
        _printBtn.tag = 2;
        [_printBtn addTarget:self action:@selector(showSourceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _printBtn;
}
- (UIButton *)imageBtn
{
    if (!_imageBtn) {
        _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageBtn setImage:[UIImage imageNamed:@"icon_image_n"] forState:UIControlStateNormal];
        _imageBtn.tag = 3;
        [_imageBtn addTarget:self action:@selector(showSourceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}
- (UIButton *)textBtn
{
    if (!_textBtn) {
        _textBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textBtn setImage:[UIImage imageNamed:@"icon_text_n"] forState:UIControlStateNormal];
        _textBtn.tag = 4;
        [_textBtn addTarget:self action:@selector(showSourceClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textBtn;
}
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
