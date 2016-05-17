//
//  MLVGradientCircleLayer.m
//  MLVComic
//
//  Created by Melvyn on 5/6/16.
//  Copyright © 2016 MLV-Technology. All rights reserved.
//

#import "MLVGradientCircleLayer.h"

@interface MLVGradientCircleLayer ()

@property (nonatomic, readonly) CAShapeLayer *shapeLayer;
@property (nonatomic, readonly) CAShapeLayer *trackLayer;
@end

@implementation MLVGradientCircleLayer
@synthesize shapeLayer = _shapeLayer;
@synthesize trackLayer = _trackLayer;

- (instancetype)initWithBounds:(CGRect)bounds position:(CGPoint)position color:(UIColor *)color {
    self = [super init];
    if (self) {
        self.bounds = bounds;
        self.position = position;
        self.strokeLineWidth = 2.0;
        
        NSArray * colors = [self graintFromColor:UIColor.clearColor ToColor:color Count:4.0];
        for (int i = 0; i < colors.count -1; i++) {
            CAGradientLayer * graint = [CAGradientLayer layer];
            graint.bounds = CGRectMake(0,0,CGRectGetWidth(self.bounds)/2,CGRectGetHeight(self.bounds)/2);
            NSValue * valuePoint = [[self positionArrayWithMainBounds:self.bounds] objectAtIndex:i];
            graint.position = valuePoint.CGPointValue;
            UIColor * fromColor = colors[i];
            UIColor * toColor = colors[i+1];
            NSArray *colors = [NSArray arrayWithObjects:(id)fromColor.CGColor, toColor.CGColor, nil];
            NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
            NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
            NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
            graint.colors = colors;
            graint.locations = locations;
            graint.startPoint = ((NSValue *)[[self startPoints] objectAtIndex:i]).CGPointValue;
            graint.endPoint = ((NSValue *)[[self endPoints] objectAtIndex:i]).CGPointValue;
            [self addSublayer:graint];
        }
        
        //Set mask
        [self setMask:self.shapeLayer];
    }
    return self;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 2 * self.strokeLineWidth, CGRectGetHeight(self.bounds) - 2 * self.strokeLineWidth);
        _shapeLayer.bounds = rect;
        _shapeLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        _shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeEnd = 0.985;
        _shapeLayer.strokeStart = 0.015;
    }
    return _shapeLayer;
}

- (CAShapeLayer *)trackLayer {
    if (!_trackLayer) {
        _trackLayer = [CAShapeLayer layer];
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 2 * self.strokeLineWidth, CGRectGetHeight(self.bounds) - 2 * self.strokeLineWidth);
        _trackLayer.bounds = rect;
        _trackLayer.fillColor = UIColor.clearColor.CGColor;
        _trackLayer.strokeColor = [[UIColor colorWithWhite:0.6 alpha:1.0] CGColor];
        _trackLayer.opacity = 0.25;
        _trackLayer.lineWidth = self.strokeLineWidth;
        _trackLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect)/2].CGPath;
    }
    return _trackLayer;
}

- (void)setStrokeEnd:(CGFloat)strokeEnd {
    if (_strokeEnd != strokeEnd) {
        _strokeEnd = strokeEnd;
        self.shapeLayer.strokeEnd = _strokeEnd;
    }
}

- (void)setStrokeLineWidth:(CGFloat)strokeLineWidth {
    if (_strokeLineWidth != strokeLineWidth) {
        _strokeLineWidth = strokeLineWidth;
        
        self.shapeLayer.lineWidth = _strokeLineWidth;
        self.trackLayer.lineWidth = _strokeLineWidth;
        
        [self setNeedsLayout];
    }
}


- (void)layoutSublayers {
    [super layoutSublayers];
    
    [self.sublayers enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:CAGradientLayer.class]) {
            CAGradientLayer *gradientLayer = (CAGradientLayer *)obj;
            gradientLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
            NSValue * valuePoint = [[self positionArrayWithMainBounds:self.bounds] objectAtIndex:idx];
            gradientLayer.position = valuePoint.CGPointValue;
        }
    }];
    
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 2 * self.strokeLineWidth, CGRectGetHeight(self.bounds) - 2 * self.strokeLineWidth);

    self.shapeLayer.bounds = rect;
    self.shapeLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetWidth(rect) / 2].CGPath;

    self.trackLayer.bounds = rect;
    self.trackLayer.path = self.shapeLayer.path;
}


-(NSArray *)positionArrayWithMainBounds:(CGRect)bounds{
    CGPoint first = CGPointMake(CGRectGetWidth(bounds)/4 *3, CGRectGetHeight(bounds)/4 *1);
    CGPoint second = CGPointMake(CGRectGetWidth(bounds)/4 *3, CGRectGetHeight(bounds)/4 *3);
    CGPoint thrid = CGPointMake(CGRectGetWidth(bounds)/4 *1, CGRectGetHeight(bounds)/4 *3);
    CGPoint fourth = CGPointMake(CGRectGetWidth(bounds)/4 *1, CGRectGetHeight(bounds)/4 *1);
    return @[[NSValue valueWithCGPoint:first],
             [NSValue valueWithCGPoint:second],
             [NSValue valueWithCGPoint:thrid],
             [NSValue valueWithCGPoint:fourth]];
}

-(NSArray *)startPoints{
    return @[[NSValue valueWithCGPoint:CGPointMake(0,0)],
             [NSValue valueWithCGPoint:CGPointMake(1,0)],
             [NSValue valueWithCGPoint:CGPointMake(1,1)],
             [NSValue valueWithCGPoint:CGPointMake(0,1)]];
}

-(NSArray *)endPoints{
    return @[[NSValue valueWithCGPoint:CGPointMake(1,1)],
             [NSValue valueWithCGPoint:CGPointMake(0,1)],
             [NSValue valueWithCGPoint:CGPointMake(0,0)],
             [NSValue valueWithCGPoint:CGPointMake(1,0)]];
}

-(NSArray *)graintFromColor:(UIColor *)fromColor ToColor:(UIColor *)toColor Count:(NSInteger)count{
    CGFloat fromR = 0.0,fromG = 0.0,fromB = 0.0,fromAlpha = 0.0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromAlpha];
    CGFloat toR = 0.0,toG = 0.0,toB = 0.0,toAlpha = 0.0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toAlpha];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    for (int i = 0; i <= count; i++) {
        CGFloat oneR = fromR + (toR - fromR)/count * i;
        CGFloat oneG = fromG + (toG - fromG)/count * i;
        CGFloat oneB = fromB + (toB - fromB)/count * i;
        CGFloat oneAlpha = fromAlpha + (toAlpha - fromAlpha)/count * i;
        UIColor * onecolor = [UIColor colorWithRed:oneR green:oneG blue:oneB alpha:oneAlpha];
        [result addObject:onecolor];
    }
    
    return result;
}

-(UIColor *)midColorWithFromColor:(UIColor *)fromColor ToColor:(UIColor*)toColor Progress:(CGFloat)progress{
    CGFloat fromR = 0.0,fromG = 0.0,fromB = 0.0,fromAlpha = 0.0;
    [fromColor getRed:&fromR green:&fromG blue:&fromB alpha:&fromAlpha];
    CGFloat toR = 0.0,toG = 0.0,toB = 0.0,toAlpha = 0.0;
    [toColor getRed:&toR green:&toG blue:&toB alpha:&toAlpha];
    CGFloat oneR = fromR + (toR - fromR) * progress;
    CGFloat oneG = fromG + (toG - fromG) * progress;
    CGFloat oneB = fromB + (toB - fromB) * progress;
    CGFloat oneAlpha = fromAlpha + (toAlpha - fromAlpha) * progress;
    UIColor * onecolor = [UIColor colorWithRed:oneR green:oneG blue:oneB alpha:oneAlpha];
    return onecolor;
}

@end
