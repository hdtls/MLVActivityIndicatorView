//
//  ViewController.m
//  MLVActivityIndicatorView
//
//  Created by Melvyn on 5/17/16.
//  Copyright © 2016 Melvyn. All rights reserved.
//

#import "ViewController.h"
#import "MLVActivityIndicatorView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MLVActivityIndicatorView *activityIndicatorView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.activityIndicatorView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
