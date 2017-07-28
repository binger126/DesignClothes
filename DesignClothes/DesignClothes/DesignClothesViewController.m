//
//  DesignClothesViewController.m
//  DesignClothes
//
//  Created by WebUser on 17/7/21.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import "DesignClothesViewController.h"
#import "DesignBottomView.h"
#import "DesignRightView.h"
#import "TCBStickerView.h"
#import "DesignSourceView.h"

#import "TCBPasterStageView.h"

#import "UIImage+AddFunction.h"

#define APPFRAME        [UIScreen mainScreen].bounds

@interface DesignClothesViewController ()<TCBPasterStageViewDelegate>

@property(nonatomic, strong) UIImageView *imageBG;
@property(nonatomic, strong) UIView      *contentBG;
@property(nonatomic, strong) UIView      *contentView;

@property(nonatomic, strong) DesignRightView    *rightView;
@property(nonatomic, strong) DesignBottomView   *bottomView;
@property(nonatomic, strong) TCBStickerView     *contentSubView;
@property(nonatomic, strong) TCBPasterStageView *stageView;
@property(nonatomic, strong) DesignSourceView   *sourceView;

@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic, strong) UIRotationGestureRecognizer *rotateGesture;
@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;


@end

@implementation DesignClothesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildView];
    [self setTouchEvent];
    
}
- (void)rightClick:(UIButton *)sender {
//    UIImage *image = [UIImage getImageFromView:self.imageBG];
}

- (void)addChildView
{
    [self.view addSubview:self.imageBG];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(375-55, 20, 50, 44);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
//    [self.imageBG addSubview:self.contentView];
    _stageView = [[TCBPasterStageView alloc] initWithFrame:CGRectMake((375-220)/2, 150, 220, 260)] ;
    _stageView.originImage = [UIImage imageNamed:@"sampleImage.jpg"];
    _stageView.backgroundColor = [UIColor redColor];
    _stageView.delegate = self;
    
    [self.imageBG addSubview:_stageView];
    [self.imageBG addSubview:self.contentBG];
    [self.view addSubview:self.rightView];
    [self.view addSubview:self.sourceView];
    [self.view addSubview:self.bottomView];
//    [self.contentView addSubview:self.contentSubView];
    
    
    
}
- (void)setTouchEvent
{
    __weak __typeof(&*self)weakSelf = self;
    //缩放
    self.rightView.zoomImageBGBlock = ^(UIButton *sender) {
        if (sender.isSelected) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.imageBG.transform = CGAffineTransformIdentity;
//                weakSelf.contentBG.transform = CGAffineTransformIdentity;
//                weakSelf.contentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [sender setSelected:!sender.isSelected];
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.imageBG.transform = CGAffineTransformScale(weakSelf.view.transform, 1.5, 1.5);
//                weakSelf.contentBG.transform = CGAffineTransformScale(weakSelf.view.transform, 1.5, 1.5);
//                weakSelf.contentView.transform = CGAffineTransformScale(weakSelf.view.transform, 1.5, 1.5);
            } completion:^(BOOL finished) {
                [sender setSelected:!sender.isSelected];
            }];
        }
    };
    //上下
    self.rightView.showSourceBlock = ^(UIButton *sender) {
        [weakSelf.bottomView setDefaultState];
        [weakSelf showAnimateView:sender];
    };
    
    self.bottomView.showSourceBlock = ^(UIButton *sender) {
        [weakSelf showAnimateView:sender];
        [weakSelf.rightView setDefaultState:!sender.isSelected];
    };
    self.sourceView.changePasterStageBlock = ^(UIImage *image) {
        weakSelf.stageView.originImage = image;
    };
    self.sourceView.addPasterImageBlock = ^(UIImage *image) {
        [weakSelf.stageView addPasterWithImg:image];
    };
}

#pragma mark -- TCBPasterStageViewDelegate

- (void)stickerTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.contentBG setHidden:NO];
    _stageView.clipsToBounds = NO;
}
- (void)stickerTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.contentBG setHidden:NO];
    _stageView.clipsToBounds = NO;
}
- (void)stickerTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.contentBG setHidden:YES];
    _stageView.clipsToBounds = YES;
}
- (void)stickerTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)showAnimateView:(UIButton *)sender {
    if (sender.isSelected) {
        [UIView animateWithDuration:0.5 animations:^{
            self.rightView.frame = CGRectMake(375-45, 418, 40, 200);
            self.sourceView.frame = CGRectMake(0, 628, 375, 200);
        } completion:^(BOOL finished) {
            [sender setSelected:!sender.isSelected];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.rightView.frame = CGRectMake(375-45, 418-200, 40, 200);
            self.sourceView.frame = CGRectMake(0, 428, 375, 200);
        } completion:^(BOOL finished) {
            [sender setSelected:!sender.isSelected];
        }];
        self.sourceView.pasterList = nil;
        self.sourceView.type = sender.tag;
        switch (sender.tag) {
            case 1:
                self.sourceView.pasterList = @[@"gaoyuanyuan1",@"gaoyuanyuan2.jpg",@"sampleImage.jpg",@"gaoyuanyuan1",@"gaoyuanyuan2.jpg"];
                break;
            case 2:
                self.sourceView.pasterList = @[@"1",@"2",@"3",@"4",@"5"];
                break;
            case 3:
                
                break;
            case 4:
                
                break;
            default:
                break;
        }
    }
}

- (UIImageView *)imageBG
{
    if (!_imageBG) {
        _imageBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 627)];
        _imageBG.backgroundColor = [UIColor lightGrayColor];
        _imageBG.userInteractionEnabled = YES;
    }
    return _imageBG;
}

- (DesignBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[DesignBottomView alloc] initWithFrame:CGRectMake(0, 627, 375, 40)];
    }
    return _bottomView;
}
- (DesignRightView *)rightView
{
    if (!_rightView) {
        _rightView = [[DesignRightView alloc] initWithFrame:CGRectMake(375-45, 417, 40, 200)];
    }
    return _rightView;
}
- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((375-220)/2, 150, 220, 260)];
        _contentView.clipsToBounds = YES;
        _contentView.userInteractionEnabled = YES;
    }
    return _contentView;
}
- (TCBStickerView *)contentSubView
{
    if (!_contentSubView) {
        _contentSubView = [[TCBStickerView alloc] initWithFrame:CGRectMake(10, 10, 200, 240)];
        _contentSubView.clipsToBounds = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sampleImage.jpg"]];
        _contentSubView.contentView = imageView;
        _contentSubView.preventsPositionOutsideSuperview = NO;
        [_contentSubView showEditingHandles];
        _contentSubView.tcbGesture = 3;
    }
    return _contentSubView;
}
- (UIView *)contentBG
{
    if (!_contentBG) {
        _contentBG = [[UIView alloc] initWithFrame:CGRectMake((375-220)/2, 150, 220, 260)];
        _contentBG.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        _contentBG.userInteractionEnabled = YES;
        [_contentBG setHidden:YES];
    }
    return _contentBG;
}
- (DesignSourceView *)sourceView
{
    if (!_sourceView) {
        _sourceView = [[DesignSourceView alloc] initWithFrame:CGRectMake(0, 627, 375, 200)];
    }
    return _sourceView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
