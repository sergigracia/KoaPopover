//
//  KoaPopover.m
//  KoaPopover
//
//  Created by Sergi Gracia on 23/05/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "KoaPopover.h"

static CGFloat KoaPopoverBorderWidth = 2;
static CGFloat KoaPopoverBorderRadius = 7;
static CGFloat KoaPopoverMarginFromObject = 12;
static CGFloat KoaPopoverMarginFromMainScreen = 10;
static CGFloat KoaPopoverStatusBarHeight = 20;

@interface KoaPopover () <UIGestureRecognizerDelegate>{
	struct{
		unsigned int shouldDismiss:1;
		unsigned int didDismiss:1;
	}_delegateFlags;
}

@property (nonatomic, strong) UILabel *arrow;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic) UIPopoverArrowDirection arrowDirection;

@property (nonatomic, strong) UIColor *koaPopoverBorderColor;

@end

@implementation KoaPopover

- (void)presentPopoverFromObject:(id)object animated:(BOOL)animated
{
    //Get object global position
    //CGPoint objectGlobalOrigin = [((UIView *)object).superview convertPoint:((UIView *)object).frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
    //CGSize objectGlobalSize = ((UIView *)object).frame.size;

    //To do...
}

- (void)presentPopoverFromObject:(id)object setArrowDirection:(UIPopoverArrowDirection)arrowDirection animated:(BOOL)animated
{
	self.arrowDirection = arrowDirection;

	//Check popover arrow directions
    if (self.arrowDirection == UIPopoverArrowDirectionAny || self.arrowDirection == UIPopoverArrowDirectionUnknown) {
        NSLog(@"Any or Unknown are not supported, you have to set left, top, right or bottom");
    }

    //Set arrow
    switch (arrowDirection) {
        case UIPopoverArrowDirectionRight:
            [self.arrow setText:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-caret-right"]];
            break;
            
        case UIPopoverArrowDirectionLeft:
            [self.arrow setText:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-caret-left"]];
            break;
        
        case UIPopoverArrowDirectionUp:
            [self.arrow setText:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-caret-up"]];
            break;
        
        case UIPopoverArrowDirectionDown:
            [self.arrow setText:[NSString fontAwesomeIconStringForIconIdentifier:@"icon-caret-down"]];
            break;
        default:
            break;
    }
    
    [self.arrow sizeToFit];
    
    //Check if status bar is visible
    if ([UIApplication sharedApplication].statusBarHidden) {
        KoaPopoverStatusBarHeight = 0;
    }
    
	//Set popover frame
	[self setPopoverFrameFromObject:object];

	//Show the popover
	[self showPopoverAnimated:animated];
}

- (void)setPopoverFrameFromObject:(id)object
{
    CGSize popoverSize;
    CGPoint popoverOrigin;
    CGPoint popoverArrowOrigin;
    
    //Get object global position
    CGPoint objectGlobalOrigin = [((UIView *)object).superview convertPoint:((UIView *)object).frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
    CGSize objectGlobalSize = ((UIView *)object).frame.size;
    
    //Set popover size
    popoverSize = CGSizeMake(self.contentViewController.contentSizeForViewInPopover.width, self.contentViewController.contentSizeForViewInPopover.height);
    
    //Set popover origin
    switch (self.arrowDirection) {
        
        case UIPopoverArrowDirectionLeft:
            
            popoverOrigin = CGPointMake(objectGlobalOrigin.x + objectGlobalSize.width + KoaPopoverMarginFromObject,
                                        objectGlobalOrigin.y);
            
            popoverArrowOrigin = CGPointMake(objectGlobalOrigin.x + objectGlobalSize.width + KoaPopoverMarginFromObject - self.arrow.frame.size.width + 2,
                                             objectGlobalOrigin.y + objectGlobalSize.height/2 - self.arrow.frame.size.height/2);
            
            break;
        
        case UIPopoverArrowDirectionRight:

            popoverOrigin = CGPointMake(objectGlobalOrigin.x - popoverSize.width - KoaPopoverMarginFromObject - KoaPopoverBorderWidth*2,
                                        objectGlobalOrigin.y);
            
            popoverArrowOrigin = CGPointMake(objectGlobalOrigin.x - KoaPopoverMarginFromObject - 2,
                                             objectGlobalOrigin.y + objectGlobalSize.height/2 - self.arrow.frame.size.height/2);
            
            break;
            
        case UIPopoverArrowDirectionUp:
            
            popoverOrigin = CGPointMake((objectGlobalOrigin.x + objectGlobalSize.width/2) - popoverSize.width/2,
                                        objectGlobalOrigin.y + objectGlobalSize.height + KoaPopoverMarginFromObject);
            
            popoverArrowOrigin = CGPointMake((objectGlobalOrigin.x + objectGlobalSize.width/2) - self.arrow.frame.size.width/2,
                                             objectGlobalOrigin.y + objectGlobalSize.height + KoaPopoverMarginFromObject - self.arrow.frame.size.height/2 - 4);
            
            break;
        
        case UIPopoverArrowDirectionDown:
            
            popoverOrigin = CGPointMake((objectGlobalOrigin.x + objectGlobalSize.width/2) - popoverSize.width/2,
                                        objectGlobalOrigin.y - popoverSize.height - KoaPopoverMarginFromObject - KoaPopoverBorderWidth*2);
            
            popoverArrowOrigin = CGPointMake((objectGlobalOrigin.x + objectGlobalSize.width/2) - self.arrow.frame.size.width/2,
                                             objectGlobalOrigin.y - KoaPopoverMarginFromObject - KoaPopoverBorderWidth*2 - 9);
            
            break;
            
        
        default:
            break;
    }
    
    //Set arrow frame
    [self.arrow setFrame:CGRectMake(popoverArrowOrigin.x, popoverArrowOrigin.y, self.arrow.frame.size.width, self.arrow.frame.size.height)];
    
    //Set content frame
	[self.contentViewController.view setFrame:CGRectMake(KoaPopoverBorderWidth, KoaPopoverBorderWidth, popoverSize.width, popoverSize.height)];
    
    //Set container frame
    CGRect frame = CGRectMake(popoverOrigin.x, popoverOrigin.y,
                              self.contentViewController.contentSizeForViewInPopover.width + KoaPopoverBorderWidth*2,
                              self.contentViewController.contentSizeForViewInPopover.height + KoaPopoverBorderWidth*2);

    //Create container
	UIView *containerView = [[UIView alloc] initWithFrame:frame];
	containerView.backgroundColor = [UIColor clearColor];
	[containerView addSubview:self.contentViewController.view];
    
    //Check main screen margins
    [self checkMainScreenMarginsOfView:containerView];
    
    //Customize popover (border, corners..)
    [self customizePopover:containerView];
    
    [self.view addSubview:containerView];
	[self.view addSubview:self.arrow];
}

- (void)showPopoverAnimated:(BOOL)animated
{
    CGFloat animationSpeed = animated ? 0.4f : 0.0f;
	self.view.alpha = 0.0;
	[UIView animateWithDuration:animationSpeed animations:^{
		self.view.alpha = 1.0;
	}];
}

- (void)checkMainScreenMarginsOfView:(UIView *)containerView
{
    CGSize mainScreenSize = [[UIApplication sharedApplication] delegate].window.frame.size;
    CGRect popoverFrame = containerView.frame;
    
    //Check marings between popover and mainscreen limits
    switch (self.arrowDirection) {
            
        case UIPopoverArrowDirectionLeft:
            //Check width
            if ((popoverFrame.origin.x + popoverFrame.size.width + KoaPopoverMarginFromMainScreen) > mainScreenSize.width) {
                
                int diff = abs((popoverFrame.origin.x + popoverFrame.size.width + KoaPopoverMarginFromMainScreen) - mainScreenSize.width);
                
                [containerView setFrame:CGRectMake(popoverFrame.origin.x,
                                                   popoverFrame.origin.y,
                                                   popoverFrame.size.width - diff,
                                                   popoverFrame.size.height)];
            }
            break;
            
        case UIPopoverArrowDirectionRight:
            //Check width
            if (popoverFrame.origin.x - KoaPopoverMarginFromMainScreen < 0) {
                
                int diff = abs(popoverFrame.origin.x - KoaPopoverMarginFromMainScreen);
                
                [containerView setFrame:CGRectMake(popoverFrame.origin.x + diff,
                                                   popoverFrame.origin.y,
                                                   popoverFrame.size.width - diff,
                                                   popoverFrame.size.height)];
            }
            break;
            
        case UIPopoverArrowDirectionUp:
            //Check height
            if ((popoverFrame.origin.y + popoverFrame.size.height + KoaPopoverMarginFromMainScreen) > mainScreenSize.height) {

                int diff = (popoverFrame.origin.y + popoverFrame.size.height + KoaPopoverMarginFromMainScreen) - mainScreenSize.height;
                
                [containerView setFrame:CGRectMake(popoverFrame.origin.x,
                                                   popoverFrame.origin.y,
                                                   popoverFrame.size.width,
                                                   popoverFrame.size.height - diff)];
            }
            break;
            
        case UIPopoverArrowDirectionDown:
            //Check height
            if ((popoverFrame.origin.y - KoaPopoverMarginFromMainScreen) < 0) {
                
                int diff = abs(popoverFrame.origin.y - KoaPopoverMarginFromMainScreen) + KoaPopoverStatusBarHeight;
                
                [containerView setFrame:CGRectMake(popoverFrame.origin.x,
                                                   popoverFrame.origin.y + diff,
                                                   popoverFrame.size.width,
                                                   popoverFrame.size.height - diff)];
            }
            break;
            
        default:
            break;
    }
}

- (void)customizePopover:(UIView *)view
{
    view.layer.cornerRadius = KoaPopoverBorderRadius;
    view.clipsToBounds = YES;
    
    view.layer.borderColor = self.koaPopoverBorderColor.CGColor;
    view.layer.borderWidth = KoaPopoverBorderWidth;
    
    self.arrow.textColor = self.koaPopoverBorderColor;
}

#pragma mark - UIViewController Methods

- (id)initWithContentViewController:(UIViewController *)contentViewController
{
    self = [super init];
    if (self) {
        // Custom initialization
		self.contentViewController = contentViewController;
        self.koaPopoverBorderColor = [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1];
        self.arrow = [[UILabel alloc] init];
        [self.arrow setBackgroundColor:[UIColor clearColor]];
        [self.arrow setFont:[UIFont iconicFontOfSize:32]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	//setup own view
	self.view.backgroundColor = [UIColor clearColor];
	
	//add the controller view to the window
	UIWindow *window = [[UIApplication sharedApplication] delegate].window;
	self.view.frame = window.bounds;
	[window addSubview:self.view];
	
	//TapGestureRecognizer
	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_actionDismissController:)];
	recognizer.delegate = self;
	[self.view addGestureRecognizer:recognizer];
}

#pragma mark - UITapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	CGPoint point = [touch locationInView:self.view];
	UIView *view = [self.view hitTest:point withEvent:nil];
	do{
		if (view == self.contentViewController.view) {
			return NO;
		}
		
		view = view.superview;
	}while (view != nil);
	
	return YES;
}

- (void)setDelegate:(id<KoaPopoverControllerDelegate>)delegate
{
	_delegate = delegate;
	_delegateFlags.shouldDismiss = [_delegate respondsToSelector:@selector(popoverControllerShouldDismissPopover:)];
	_delegateFlags.didDismiss = [_delegate respondsToSelector:@selector(popoverControllerDidDismissPopover:)];
}

#pragma mark -
#pragma mark Delegate Wrapper Methods

- (BOOL)_delegateShouldDismissPopover
{
	if (_delegateFlags.shouldDismiss) {
		return (BOOL)[_delegate performSelector:@selector(popoverControllerDidDismissPopover:) withObject:self];
	}
	
	return YES;
}

- (void)_delegateDidDismiss
{
	if (_delegateFlags.didDismiss) {
		[_delegate performSelector:@selector(popoverControllerDidDismissPopover:) withObject:self];
	}
}


#pragma mark -
#pragma mark Action Methods

- (void)_actionDismissController:(UITapGestureRecognizer *)recognizer
{
	if ([self _delegateShouldDismissPopover]) {
		[self _delegateDidDismiss];
	}
	
	[self dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark Public Methods

- (void)dismissPopoverAnimated:(BOOL)animated
{
	CGFloat animationSpeed = animated ? 0.2f : 0.0f;
	[UIView animateWithDuration:animationSpeed animations:^{
		self.view.alpha = 0.0;
	} completion:^(BOOL finished) {
		[self.view removeFromSuperview];
	}];
}


@end
