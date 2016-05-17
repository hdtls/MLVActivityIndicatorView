//
//  MLVActivityIndicatorView.m
//  MLVActivityIndicatorView
//
//  Created by Melvyn on 5/11/16.
//  Copyright © 2016 Melvyn. All rights reserved.
//

#import "MLVActivityIndicatorView.h"
#import "MLVGradientCircleLayer.h"

#define kMLVActivityIndicatorViewColor [UIColor colorWithWhite:0.6 alpha:1.0]
#define kMLVActivityIndicatorViewBounds  CGRectMake(0.0, 0.0, 100.0, 100.0)

static NSString *const kMLVStrokeEndAnimationKey = @"MLVActivityIndicatorView.strokeEnd";
static NSString *const kMLVRotationAnimationKey = @"MLVActivityIndicatorView.transform.rotation";

static CGFloat const kMLVStrokeWidth = 2.0;
static CFTimeInterval const kMLVAnimationTimeInterval = 1.0;

@interface MLVActivityIndicatorView ()

@property (nonatomic, readonly) CAShapeLayer *trackLayer;
@property (nonatomic, readonly) MLVGradientCircleLayer *gradientLayer;

@property (nonatomic, readonly) UIBezierPath *bezierPath;

@property (nonatomic, readwrite) BOOL isAnimating;

@end

@implementation MLVActivityIndicatorView

@synthesize trackLayer = _trackLayer;
@synthesize gradientLayer = _gradientLayer;
@synthesize bezierPath = _bezierPath;

+ (void)initialize {
    [[[self class] appearance] setColor:kMLVActivityIndicatorViewColor];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];
}

- (void)initialize {
    self.color = [[[self class] appearance] color];
    self.hidesWhenStopped = YES;
    self.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    [self.layer addSublayer:self.trackLayer];
    [self.layer addSublayer:self.gradientLayer];
    
    // See comment in resetAnimations on why this notification is used.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (CALayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [[MLVGradientCircleLayer alloc] initWithBounds:kMLVActivityIndicatorViewBounds
                                                             position:CGPointZero
                                                                color:kMLVActivityIndicatorViewColor];
        _gradientLayer.strokeLineWidth = kMLVStrokeWidth;
    }
    
    return _gradientLayer;
}

- (void)setStrokeEnd:(CGFloat)strokeEnd {
    if (_strokeEnd != strokeEnd) {
        _strokeEnd = strokeEnd;
        self.gradientLayer.strokeEnd = _strokeEnd;
    }
}

- (void)startAnimating {
    if (self.isAnimating) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = kMLVAnimationTimeInterval;
    animation.fromValue = @(0.0);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    [self.gradientLayer addAnimation:animation forKey:kMLVRotationAnimationKey];
    
    self.isAnimating = YES;
    
    if (self.hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    if (!self.isAnimating) {
        return;
    }
    
    [self.gradientLayer removeAnimationForKey:kMLVRotationAnimationKey];
    self.isAnimating = NO;
    
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (void)resetAnimations {
    if (self.isAnimating) {
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.trackLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.gradientLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end
