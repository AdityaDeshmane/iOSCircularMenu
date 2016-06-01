/*
 
 The MIT License (MIT)
 
 Copyright (c) 2015 Aditya Deshmane
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

//
//  ViewController.m
//  iOSCircularMenu
//
//  Created by Aditya Deshmane on 19/10/14.
//

#import "ViewController.h"
#import "ADCircularMenu.h"

@interface ViewController ()<ADCircularMenuDelegate>
{
    ADCircularMenu    *_circularMenuVC;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)btnMenuPressed:(id)sender
{
    _circularMenuVC = nil;
    
    //use 3 or 7 or 12 for symmetric look (current implementation supports max 12 buttons)
    NSArray *arrImageName = [[NSArray alloc] initWithObjects:
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             nil];
    
    _circularMenuVC = [[ADCircularMenu alloc] initWithMenuButtonImageNameArray:arrImageName
                                                      andCornerButtonImageName:@"btnMenuCorner"
                                                andShouldAddStatusBarMargin:YES];
    _circularMenuVC.delegateCircularMenu = self;
    [_circularMenuVC show];
}

- (void)ADCircularMenuClickedButtonAtIndex:(int) buttonIndex
{
    NSLog(@"Circular Mneu : Clicked button at index : %d",buttonIndex);
}

@end
