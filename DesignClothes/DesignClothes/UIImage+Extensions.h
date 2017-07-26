//
//  UIImage+Extensions.h
//  DesignClothes
//
//  Created by WebUser on 17/7/24.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

CGFloat DegreesToRadians(CGFloat degrees);
CGFloat RadiansToDegrees(CGFloat radians);

@interface UIImage (Extensions)

@property(nonatomic, strong) UIImageView     *shouldImage;
@property(nonatomic, strong) ALAssetsLibrary *assetsLibrary;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
//[objc] view plaincopyprint?
- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur;
- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                    customAlbumName:(NSString *)customAlbumName
                    completionBlock:(void(^)(void))completionBlock
                       failureBlock:(void(^)(NSError *error))failureBlock;
@end
