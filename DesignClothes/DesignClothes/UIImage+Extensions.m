//
//  UIImage+Extensions.m
//  DesignClothes
//
//  Created by WebUser on 17/7/24.
//  Copyright © 2017年 yswl. All rights reserved.
//

#import "UIImage+Extensions.h"


CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
};
CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180/M_PI;
};


@implementation UIImage (Extensions)

@dynamic assetsLibrary;

-(UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

// Combine two UIImages

//[objc] view plaincopyprint?
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image2.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
//[objc] view plaincopyprint?
- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor
                           shadeAlpha1:(CGFloat)alpha1
                           shadeAlpha2:(CGFloat)alpha2
                           shadeAlpha3:(CGFloat)alpha3
                           shadowColor:(UIColor *)shadowColor
                          shadowOffset:(CGSize)shadowOffset
                            shadowBlur:(CGFloat)shadowBlur {
    UIImage *image = self;
    CGColorRef cgColor = [bgColor CGColor];
    CGColorRef cgShadowColor = [shadowColor CGColor];
    CGFloat components[16] = {1,1,1,alpha1,1,1,1,alpha1,1,1,1,alpha2,1,1,1,alpha3};
    CGFloat locations[4] = {0,0.5,0.6,1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, (size_t)4);
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [image size];
    //contextRect.size = CGSizeMake([image size].width+5,[image size].height+5);
    // Retrieve source image and begin image context
    UIImage *itemImage = image;
    CGSize itemImageSize = [itemImage size];
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) / 2);
    UIGraphicsBeginImageContext(contextRect.size);
    CGContextRef c = UIGraphicsGetCurrentContext();
    // Setup shadow
    CGContextSetShadowWithColor(c, shadowOffset, shadowBlur, cgShadowColor);
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [itemImage CGImage]);
    // Fill and end the transparency layer
    CGContextSetFillColorWithColor(c, cgColor);
    contextRect.size.height = -contextRect.size.height;
    CGContextFillRect(c, contextRect);
    CGContextDrawLinearGradient(c, colorGradient,CGPointZero,CGPointMake(contextRect.size.width*1.0/4.0,contextRect.size.height),0);
    CGContextEndTransparencyLayer(c);
    //CGPointMake(contextRect.size.width*3.0/4.0, 0)
    // Set selected image and end context
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(colorGradient);
    return resultImage;
}

- (UIImage *)imageWithShadowColor:(UIColor *)shadowColor
                     shadowOffset:(CGSize)shadowOffset
                       shadowBlur:(CGFloat)shadowBlur
{
    CGColorRef cgShadowColor = [shadowColor CGColor];
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef shadowContext = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                                       CGImageGetBitsPerComponent(self.CGImage), 0,
                                                       colourSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colourSpace);
    
    // Setup shadow
    CGContextSetShadowWithColor(shadowContext, shadowOffset, shadowBlur, cgShadowColor);
    CGRect drawRect = CGRectMake(-shadowBlur, -shadowBlur, self.size.width + shadowBlur, self.size.height + shadowBlur);
    CGContextDrawImage(shadowContext, drawRect, self.CGImage);
    
    CGImageRef shadowedCGImage = CGBitmapContextCreateImage(shadowContext);
    CGContextRelease(shadowContext);
    
    UIImage * shadowedImage = [UIImage imageWithCGImage:shadowedCGImage];
    CGImageRelease(shadowedCGImage);
    
    return shadowedImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                   customAlbumName:(NSString *)customAlbumName
                   completionBlock:(void(^)(void))completionBlock
                      failureBlock:(void(^)(NSError *error))failureBlock
{
    NSData *imageData = UIImagePNGRepresentation(self);
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak __typeof(&*self)weakSelf = self;
    void (^AddAsset)(ALAssetsLibrary *,NSURL *) = ^(ALAssetsLibrary *assetsLibrary,NSURL *assetURL) {
        [weakSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^( ALAssetsGroup *group ,BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            }failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        }failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [self.assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL,NSError *error) {
        if (customAlbumName) {
            [weakSelf.assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    }failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                }else{
                    AddAsset(weakSelf.assetsLibrary, assetURL);
                }
            }failureBlock:^(NSError *error) {
                AddAsset(weakSelf.assetsLibrary ,assetURL);
            }];
        }else{
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}


-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint shoulderPoint = [self getNewPoint:point SetImage:self.shouldImage];
    if(CGRectContainsPoint(self.shouldImage.bounds,shoulderPoint)) {
        if ([self isAplphaSetPoint:shoulderPoint andSetImage:self.shouldImage]) {
            self.shouldImage.image = [UIImage imageNamed:@"man_shoulder_pressed"];
            return YES;
        }
    }
    return YES;
}

#pragma mark --  point点转换
-(CGPoint)getNewPoint:(CGPoint)point SetImage:(UIImageView *)iv {
    return  CGPointMake(point.x - iv.frame.origin.x,
                        point.y - iv.frame.origin.y);
}

-(BOOL)isAplphaSetPoint:(CGPoint)point andSetImage:(UIImageView *)iv {
    NSLog(@"point: %f", point.y);
    UIColor *uColor = [self colorAtPixel: point setImage: iv];
    const CGFloat *components = CGColorGetComponents(uColor.CGColor);
    if (NULL != components) {
        NSLog(@"Red: %f Green: %f Blue: %f alpha: %f", components[0], components[1], components[2], components[3]);
        float aplphaF = components[3];
        if ((aplphaF >= 0.5)) {
            return YES;
        }
    }
    return NO;
}
#pragma mark -- 点击时间结束 逻辑处理
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (UIColor *)colorAtPixel:(CGPoint)point setImage:(UIImageView *)iv {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, iv.frame.size.width, iv.frame.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = iv.image.CGImage;
    NSUInteger width = iv.frame.size.width;
    NSUInteger height = iv.frame.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
