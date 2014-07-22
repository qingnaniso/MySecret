//
//  SecretNavigationController.m
//  私人相册
//
//  Created by Qiqingnan on 14-7-18.
//  Copyright (c) 2014年 qingnan qi. All rights reserved.
//

#import "SecretNavigationController.h"

@interface SecretNavigationController ()

@end

@implementation SecretNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setAlpha:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resginActive:) name:UIApplicationWillResignActiveNotification object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Active:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)resginActive:(NSNotification *)notification
{
    [self.view setAlpha:0.5];
}

- (void)Active:(NSNotification *)notification
{
    [self.view setAlpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
