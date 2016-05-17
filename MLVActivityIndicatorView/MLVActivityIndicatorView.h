//
//  MLVActivityIndicatorView.h
//  MLVActivityIndicatorView
//
//  Created by Melvyn on 5/11/16.
//  Copyright © 2016 Melvyn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLVActivityIndicatorView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic) CGFloat strokeEnd;                        // 0.0 .. 1.0, default is 0.0. values outside are pinned.

@property (nonatomic, readonly) BOOL isAnimating;       //Property indicating whether the view is currently animating.

@property(nonatomic) BOOL hidesWhenStopped;           // default is YES. calls -setHidden when animating gets set to NO

@property (nullable, readwrite, nonatomic, strong) UIColor *color UI_APPEARANCE_SELECTOR;


- (void)startAnimating;
- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END