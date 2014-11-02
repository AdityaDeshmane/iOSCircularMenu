//
//  ADCircularMenuViewController.m
//  iOSCircularMenu
//
//  Created by Aditya Deshmane on 19/10/14.
//  Copyright (c) 2014 Aditya Deshmane. All rights reserved.
//

#import "ADCircularMenuViewController.h"

#define STARTING_POINT CGPointMake(26, 38)

@interface ADCircularMenuViewController ()<UIGestureRecognizerDelegate>
{
    float _fButtonSize;
    float _fInnerRadius;
    
    NSUInteger _iNumberOfButtons;
    NSMutableArray *_arrButtons;
    NSArray *_arrButtonImageName;
    UIButton *_buttonCorner;
    NSString *_strCornerButtonImageName;

    UIGestureRecognizer *_gestureRecognizerTap;
}

//Private Methods
-(void)setupData;
-(void)setupUI;
-(void)setTapGesture;
-(void)setupButtons;

-(void)showButtons;
-(void)setButtonFrames;

- (void)removeViewWithAnimation;

//IBActions
- (IBAction)hideMenu:(id)sender;

@end

@implementation ADCircularMenuViewController


-(id)initWithMenuButtonImageNameArray:(NSArray*) arrImage andCornerButtonImageName:(NSString*) strCornerButtonImageName;
{
    self = [super init];
    
    if (self)
    {
        _iNumberOfButtons = arrImage.count > 12 ? 12 : arrImage.count;//current implementation supports max 12 buttons
        _arrButtonImageName = [[NSArray alloc] initWithArray:arrImage];
        _strCornerButtonImageName = strCornerButtonImageName;
        
        [self setupData];
        [self setupUI];
        [self setTapGesture];
        [self setupButtons];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Initialization methods

-(void)setupData
{
    _fButtonSize = 35;//circular button width/height
    _fInnerRadius = 75;//1st circle boundary
}


-(void)setupUI
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [self.view setFrame:window.screen.bounds];
    [window.rootViewController.view addSubview:self.view];
    [self.view setBackgroundColor:[UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:0.3]];//Transparent color
}


-(void)setTapGesture
{
    _gestureRecognizerTap = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
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
    [_buttonCorner setFrame:CGRectMake(0, 20, 40, 40)];
    
    //Circular menu buttons
    _arrButtons = [[NSMutableArray alloc] init];

    for (int i = 0; i < _iNumberOfButtons; i++)
    {
         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTag:i];
        [button addTarget:self action:@selector(hideMenu:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:[_arrButtonImageName objectAtIndex:i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(0, 0, 50, 50)];
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
        button.center = STARTING_POINT;
        [self.view addSubview:button];
    }
    
    [self.view layoutIfNeeded]; // Ensures that all pending layout operations have been completed
    
    [UIView animateWithDuration:1.0 animations:
     ^{

    
         [self setButtonFrames];
         [self.view layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes
     }];
}

- (void)setButtonFrames
{
    CGPoint circleCenter = STARTING_POINT;
    
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
    float incAngle = ( 117/3 )*M_PI/180.0 ;
    float curAngle = 0.19;//more value more to left;
    float circleRadius = _fInnerRadius;
    
    for (int i = 0; i < _iNumberOfButtons; i++)
    {
        if(i == 3)//2nd circle
        {
            curAngle = 0.09;
            incAngle = ( 115/4 )*M_PI/180.0;
            circleRadius = _fInnerRadius +65;
        }
        else if(i == 7)//3rd circle
        {
            curAngle = 0.04;
            incAngle = ( 113/5 )*M_PI/180.0;
            circleRadius = _fInnerRadius +(65*2);
        }
        
        CGPoint buttonCenter;
        buttonCenter.x = circleCenter.x + cos(curAngle)*circleRadius;
        buttonCenter.y = circleCenter.y + sin(curAngle)*circleRadius;
        UIButton *button = [_arrButtons objectAtIndex:i];
        button.center = buttonCenter;
        curAngle += incAngle;
    }
}


#pragma mark - Remove menu

- (IBAction)hideMenu:(id)sender
{
    if (sender &&
        sender != _buttonCorner &&
        _delegateCircularMenu &&
        [_delegateCircularMenu respondsToSelector:@selector(circularMenuClickedButtonAtIndex:)])
    {
        UIButton *button = (UIButton*)sender;
        [_delegateCircularMenu circularMenuClickedButtonAtIndex:(int)button.tag];
    }
    
    [self removeViewWithAnimation];
}


- (void)removeViewWithAnimation
{
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                     animations:
     ^{
         for (int index = 0; index < _iNumberOfButtons; index++)
         {
             UIButton *button = [_arrButtons objectAtIndex:index];
             button.center = STARTING_POINT;
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
