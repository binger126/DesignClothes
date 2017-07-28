//
//  DesignSourceView.m
//  DesignClothes
//
//  Created by WebUser on 17/7/21.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import "DesignSourceView.h"
#import "PasterChooseView.h"
///// View 圆角
//#define ViewRadius(View, Radius)\
//\
//[View.layer setCornerRadius:(Radius)];\
//[View.layer setMasksToBounds:YES]
//
///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;

static const CGFloat width_pasterChoose = 110.0f;

@interface DesignSourceView ()<PasterChooseViewDelegate>

@property(nonatomic, strong) UIScrollView *topScrollView;
@property(nonatomic, strong) UIButton     *addScrollItem;

@property(nonatomic, strong) NSMutableArray *topTitleArray;

@property(nonatomic, strong) UIScrollView   *pasterScrollView;

@end

@implementation DesignSourceView

@synthesize type;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        MyRelativeLayout *rootLayout = [[MyRelativeLayout alloc] init];
        rootLayout.myLeftMargin = rootLayout.myRightMargin = rootLayout.myTopMargin = 0;
        rootLayout.myHeight = 40;
//        rootLayout.topBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
//        rootLayout.bottomBorderLine = [[MyBorderLineDraw alloc] initWithColor:[UIColor lightGrayColor]];
        [self addSubview:rootLayout];
        [rootLayout addSubview:self.topScrollView];
        [rootLayout addSubview:self.addScrollItem];
        self.addScrollItem.rightPos.equalTo(rootLayout.rightPos);
        self.addScrollItem.topPos.equalTo(rootLayout.topPos);
        self.addScrollItem.bottomPos.equalTo(rootLayout.bottomPos);
        self.addScrollItem.widthDime.equalTo(rootLayout.heightDime);
        self.topScrollView.leftPos.equalTo(rootLayout.leftPos);
        self.topScrollView.topPos.equalTo(rootLayout.topPos);
        self.topScrollView.bottomPos.equalTo(rootLayout.bottomPos);
        self.topScrollView.rightPos.equalTo(self.addScrollItem.leftPos).offset(-1.0);
        [self addScrollItemArray];
        [self addSubview:self.pasterScrollView];
    }
    return self;
}

#pragma mark --  private 方法

- (void)addScrollItemClick:(UIButton *)sender
{
    static NSInteger index = 1;
    [self.topTitleArray insertObject:[NSString stringWithFormat:@"添加item%ld",(long)index] atIndex:0];
    index++;
    for (UIView *subView in self.topScrollView.subviews) {
        [subView removeFromSuperview];
    }
    [self addScrollItemArray];
}

- (void)addScrollItemArray
{
    [self.topTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = (NSString *)obj;
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitle:title forState:UIControlStateNormal];
        titleButton.tag = idx+1;
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleButton.frame = CGRectMake(idx*100, 0, 100, 40);
        titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        ViewBorder(titleButton, [UIColor lightGrayColor], 0.25);
        self.topScrollView.contentSize = CGSizeMake((idx+1)*100, 40);
        [self.topScrollView addSubview:titleButton];
    }];
}



- (void)titleButtonClick:(UIButton *)sender
{
    CGFloat offsetX = 0.0;
    if (sender.tag>2&&sender.tag<self.topTitleArray.count) {
        offsetX = 65.0+(sender.tag-3)*100;
    }
    if (sender.tag<=2) {
        offsetX = 0.0;
    }
    if (sender.tag==self.topTitleArray.count) {
        offsetX = 100*sender.tag-335;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.topScrollView.contentOffset = CGPointMake(offsetX, 0);
    [UIView commitAnimations];
    
    
}

#pragma mark - PasterChooseViewDelegate
- (void)pasterClick:(NSString *)paster
{
    UIImage *image = [UIImage imageNamed:paster];
    
    if (!image) return;
    
    
    if (type==1) {
        if (self.changePasterStageBlock) {
            self.changePasterStageBlock(image);
        }
    }else if (type==2) {
        if (self.addPasterImageBlock) {
            self.addPasterImageBlock(image);
        }
    }else if (type==3) {
       
    }else if (type==4) {
        
    }
    
    //在这里 添加 贴纸
//    [_stageView addPasterWithImg:image];
}

- (UIScrollView *)topScrollView
{
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] init];
        _topScrollView.showsHorizontalScrollIndicator = NO;
        ViewBorder(_topScrollView, [UIColor lightGrayColor], 0.5);
    }
    return _topScrollView;
}
- (UIButton *)addScrollItem
{
    if (!_addScrollItem) {
        _addScrollItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addScrollItem setImage:[UIImage imageNamed:@"icon_add_source"] forState:UIControlStateNormal];
        ViewBorder(_addScrollItem, [UIColor lightGrayColor], 0.5);
        [_addScrollItem addTarget:self action:@selector(addScrollItemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addScrollItem;
}
- (NSMutableArray *)topTitleArray
{
    if (!_topTitleArray) {
        _topTitleArray = [NSMutableArray array];
        [_topTitleArray addObject:@"T恤"];
        [_topTitleArray addObject:@"Polo衫"];
        [_topTitleArray addObject:@"圆领卫衣"];
        [_topTitleArray addObject:@"运动套装定制"];
        [_topTitleArray addObject:@"帽衫"];
        [_topTitleArray addObject:@"外套"];
    }
    return _topTitleArray;
}

#pragma mark - Property
- (UIScrollView *)pasterScrollView
{
    if (!_pasterScrollView) {
        _pasterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, 375, 160)];
        _pasterScrollView.pagingEnabled = NO;
        _pasterScrollView.showsVerticalScrollIndicator = NO;
        _pasterScrollView.showsHorizontalScrollIndicator = NO;
        _pasterScrollView.bounces = YES;
//        _pasterScrollView.contentSize = CGSizeMake(width_pasterChoose*self.pasterList.count,
//                                               _pasterScrollView.frame.size.height);
//        int _x = 0;
//        for (int i = 0; i < self.pasterList.count; i++) {
//            CGRect rect = CGRectMake(_x, 0, width_pasterChoose, _pasterScrollView.frame.size.height);
//            PasterChooseView *pView = (PasterChooseView *)[[[NSBundle mainBundle] loadNibNamed:@"PasterChooseView" owner:self options:nil] lastObject];
//            pView.frame = rect;
//            pView.aPaster = self.pasterList[i];
//            pView.delegate = self;
//            [_pasterScrollView addSubview:pView];
//            _x += width_pasterChoose;
//        }
    }
    return _pasterScrollView;
}
- (void)setPasterList:(NSArray *)pasterList
{
    _pasterList = [pasterList copy];
    _pasterScrollView.contentSize = CGSizeMake(width_pasterChoose*_pasterList.count,
                                               _pasterScrollView.frame.size.height);
    for (UIView *view in _pasterScrollView.subviews) {
        [view removeFromSuperview];
    }
    int _x = 0;
    for (int i = 0; i < _pasterList.count; i++) {
        CGRect rect = CGRectMake(_x, 0, width_pasterChoose, _pasterScrollView.frame.size.height);
        PasterChooseView *pView = (PasterChooseView *)[[[NSBundle mainBundle] loadNibNamed:@"PasterChooseView" owner:self options:nil] lastObject];
        pView.frame = rect;
        pView.aPaster = _pasterList[i];
        pView.delegate = self;
        [_pasterScrollView addSubview:pView];
        _x += width_pasterChoose;
    }
}
//- (NSArray *)pasterList
//{
//    if (!_pasterList) {
//        _pasterList = @[@"1",@"2",@"3",@"4",@"5"];
//    }
//    
//    return _pasterList;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
