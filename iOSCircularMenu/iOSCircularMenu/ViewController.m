//
//  ViewController.m
//  iOSCircularMenu
//
//  Created by Aditya Deshmane on 19/10/14.
//  Copyright (c) 2014 Aditya Deshmane. All rights reserved.
//

#import "ViewController.h"
#import "ADCircularMenuViewController.h"

@interface ViewController ()<ADCircularMenuDelegate>
{
    ADCircularMenuViewController *circularMenuVC;
}

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnMenuPressed:(id)sender
{
    circularMenuVC = nil;
    
    //use 3 or 7 or 12 for symmetric look (current implementation supports max 12 buttons)
    NSArray *arrImageName = [[NSArray alloc] initWithObjects:@"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu", nil];
    
    circularMenuVC = [[ADCircularMenuViewController alloc] initWithMenuButtonImageNameArray:arrImageName andCornerButtonImageName:@"btnMenuCorner"];
    circularMenuVC.delegateCircularMenu = self;
    [circularMenuVC show];
}

- (void)circularMenuClickedButtonAtIndex:(int) buttonIndex
{
    NSLog(@"Clicked menu button at index : %d",buttonIndex);
}

@end
