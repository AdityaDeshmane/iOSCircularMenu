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
//  ADCircularMenuViewController.m
//  iOSCircularMenu
//
//  Created by Aditya Deshmane on 19/10/14.
//

#import "ADCircularMenu.h"


#define STARTING_POINT              CGPointMake(20, 20)
#define CORNER_BUTTON_WIDTH         40
#define BUTTON_WIDTH                50
#define FIRST_INNER_CIRCLE_RADIUS   75
#define DISTACE_BETWEEN_CIRCLES     75
#define SHOW_ANIMATION_DURATION     1.0
#define HIDE_ANIMATION_DURATION     0.5

@interface ADCircularMenu ()<UIGestureRecognizerDelegate>
{
    NSUInteger              _iNumberOfButtons;
    NSMutableArray          *_arrButtons;
    NSArray                 *_arrButtonImageName;
    UIButton                *_buttonCorner;
    NSString                *_strCornerButtonImageName;
    UIGestureRecognizer     *_gestureRecognizerTap;
    BOOL                    _bShouldAddStatusBarMargin;
}

//Initializations
-(void)setupUI;
-(void)setTapGesture;
-(void)setupButtons;

//Show
-(void)showButtons;
-(void)setButtonFrames;

//Hide
- (void)removeViewWithAnimation;
- (IBAction)hideMenu:(id)sender;

@end

@implementation ADCircularMenu


-(id)initWithMenuButtonImageNameArray:(NSArray*) arrImage
             andCornerButtonImageName:(NSString*) strCornerButtonImageName
          andShouldAddStatusBarMargin:(BOOL) bShouldAddStatusBarMargin
{
    self = [super init];
    
    if (self)
    {
        _iNumberOfButtons           = arrImage.count > 12 ? 12 : arrImage.count;//current implementation supports max 12 buttons
        _arrButtonImageName         = [[NSArray alloc] initWithArray:arrImage];
        _strCornerButtonImageName   = strCornerButtonImageName;
        _bShouldAddStatusBarMargin  = bShouldAddStatusBarMargin;
        
        [self setupUI];
        [self setTapGesture];
        [self setupButtons];
    }
    
    return self;
}

#pragma mark - Initialization methods

-(void)setupUI
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [self.view setFrame:window.screen.bounds];
    [window.rootViewController.view addSubview:self.view];
    [self.view setBackgroundColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:0.3]];//Transparent color
}

-(void)setTapGesture
{
    _gestureRecognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _gestureRecognizerTap.cancelsTouchesInView = NO;
    _gestureRecognizerTap.delegate = self;
    [self.view addGestureRecognizer:_gestureRecognizerTap];
}

- (void)setupButtons
{
    //Corner button
    _buttonCorner = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonCorner setImage:[UIImage imageNamed:_strCornerButtonImageName] forState:UIControlStateNormal];
    [_buttonCorner addTarget:self action:@selector(hideMenu:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonCorner setFrame:CGRectMake(0,_bShouldAddStatusBarMargin?20:0, CORNER_BUTTON_WIDTH, CORNER_BUTTON_WIDTH)];
    
    //Circular menu buttons
    _arrButtons = [[NSMutableArray alloc] init];

    for (int i = 0; i < _iNumberOfButtons; i++)
    {
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:i];
        [button addTarget:self action:@selector(hideMenu:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:[_arrButtonImageName objectAtIndex:i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, BUTTON_WIDTH, BUTTON_WIDTH)];
        [_arrButtons addObject:button];
    }
}

#pragma mark - Show menu

-(void)show
{
    [self showButtons];
}

- (void)showButtons
{
    [self.view addSubview:_buttonCorner];
    
    for (int index = 0; index < _iNumberOfButtons; index++)
    {
        UIButton *button = [_arrButtons objectAtIndex:index];
        button.center = CGPointMake(STARTING_POINT.x, STARTING_POINT.y + (_bShouldAddStatusBarMargin?20:0));
        [self.view addSubview:button];
    }
    
    [self.view layoutIfNeeded]; // Ensures that all pending layout operations have been completed
    
    [UIView animateWithDuration:SHOW_ANIMATION_DURATION animations:
     ^{
         [self setButtonFrames];
         [self.view layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
     }];
}

- (void)setButtonFrames
{
    CGPoint circleCenter = CGPointMake(STARTING_POINT.x, STARTING_POINT.y + (_bShouldAddStatusBarMargin?20:0));
    
    /*
     Logic : Use parametric equations to set point along circumference of circle
     
     These formulae will give point(x,y) along circumference
     
     x = cx + r * cos(a)
     y = cy + r * sin(a)
     
     Where,
     r is the radius,
     cx,cy the origin,
     and a the angle from 0..2PI radians or 0..360 degrees.
     */
    
    //1st circle initialization
    int marginAngle             = 5;//5 degree space is kept to avoid touching button on extreme position to corner
    int totalAvailableDegrees   = 90 - marginAngle*2;//Space left to fit button is 80
    int numberOfButtons         = 3;//first circle has 3 button along circumference
    
    float incrementAngle    = totalAvailableDegrees/ (numberOfButtons - 1);//Available space is divided as per button count
    float currentAngle      = marginAngle;
    float circleRadius      = FIRST_INNER_CIRCLE_RADIUS;
    
    for (int i = 0; i < _iNumberOfButtons; i++)
    {
        if(i == 3)//2nd circle started
        {
            numberOfButtons = 4;
            currentAngle    = marginAngle;
            incrementAngle  = totalAvailableDegrees/(numberOfButtons - 1);
            circleRadius    = FIRST_INNER_CIRCLE_RADIUS + DISTACE_BETWEEN_CIRCLES;
        }
        else if(i == 7)//3rd circle started
        {
            numberOfButtons = 5;
            currentAngle    = marginAngle;
            incrementAngle  = totalAvailableDegrees/(numberOfButtons - 1);
            circleRadius    = FIRST_INNER_CIRCLE_RADIUS +(DISTACE_BETWEEN_CIRCLES*2);
        }
        
        CGPoint buttonCenter;
        buttonCenter.x      = circleCenter.x + cos(currentAngle *M_PI/180.0)*circleRadius;
        buttonCenter.y      = circleCenter.y + sin(currentAngle *M_PI/180.0)*circleRadius;
        UIButton *button    = [_arrButtons objectAtIndex:i];
        button.center       = buttonCenter;
        currentAngle        += incrementAngle;
    }
}

#pragma mark - Remove menu

- (IBAction)hideMenu:(id)sender
{
    if (sender &&
        sender != _buttonCorner &&
        _delegateCircularMenu &&
        [_delegateCircularMenu respondsToSelector:@selector(ADCircularMenuClickedButtonAtIndex:)])
    {
        UIButton *button = (UIButton*)sender;
        [_delegateCircularMenu ADCircularMenuClickedButtonAtIndex:(int)button.tag];
    }
    
    [self removeViewWithAnimation];
}


- (void)removeViewWithAnimation
{
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:HIDE_ANIMATION_DURATION
                     animations:
     ^{
         for (int index = 0; index < _iNumberOfButtons; index++)
         {
             UIButton *button = [_arrButtons objectAtIndex:index];
             button.center = CGPointMake(STARTING_POINT.x, STARTING_POINT.y + (_bShouldAddStatusBarMargin?20:0));
         }
     }
    completion:^(BOOL finished)
     {
         [self.view removeFromSuperview];
         [self willMoveToParentViewController:nil];
         [self removeFromParentViewController];
     }];
}


#pragma mark - Tap gesture handling

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //ingore touch for button at top left corner, let its touch up inside handler method handle that
    if ((touch.view == _buttonCorner))
    return NO;
    
    //ingore touch gesture for all menu button, let their touch up inside handler method handle that
    for (int index = 0; index < _iNumberOfButtons; index++)
    {
        UIButton *button = [_arrButtons objectAtIndex:index];
        if ((touch.view == button))
        return NO;
    }
    
    return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    //view was touched at point other than buttons
    [self removeViewWithAnimation];
}

@end
