//
//  MLVGradientCircleLayer.h
//  MLVComic
//
//  Created by Melvyn on 5/6/16.
//  Copyright © 2016 MLV-Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLVGradientCircleLayer : CALayer

@property (nonatomic, assign) CGFloat strokeEnd;

@property (nonatomic, assign) CGFloat strokeLineWidth;

- (instancetype)initWithBounds:(CGRect)bounds position:(CGPoint)position color:(UIColor *)color;

@end
