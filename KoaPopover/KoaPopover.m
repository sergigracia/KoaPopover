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
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) UIView *objectFromPresent;

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
    self.objectFromPresent = object;

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

- (void)setPopoverWithoutBorder:(BOOL)popoverWithoutBorder {
    //We decide to use the default popover width or not use border
    if (popoverWithoutBorder) {
        KoaPopoverBorderWidth = 0;
    }
    else {
        KoaPopoverBorderWidth = 2;
    }
}

- (void)setPopoverFrameFromObject:(id)object
{
    CGSize popoverSize;
    CGPoint popoverOrigin;
    CGPoint popoverArrowOrigin;
    
    //Get object global position
    //CGPoint objectGlobalOrigin = [((UIView *)object).superview convertPoint:((UIView *)object).frame.origin toView:[[UIApplication sharedApplication] keyWindow]];
    CGPoint objectGlobalOrigin = [((UIView *)object).superview convertPoint:((UIView *)object).frame.origin toView:[[UIApplication sharedApplication] delegate].window.rootViewController.view];
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
                                             objectGlobalOrigin.y + objectGlobalSize.height + KoaPopoverMarginFromObject - self.arrow.frame.size.height/2 - 5);
            
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
    [self.arrow setFrame:CGRectMake(popoverArrowOrigin.x,
                                    popoverArrowOrigin.y,
                                    self.arrow.frame.size.width,
                                    self.arrow.frame.size.height)];
    
    //Set content frame
	[self.contentViewController.view setFrame:CGRectMake(KoaPopoverBorderWidth, KoaPopoverBorderWidth, popoverSize.width, popoverSize.height)];
    
    //Set container frame
    CGRect frame = CGRectMake(popoverOrigin.x,
                              popoverOrigin.y,
                              self.contentViewController.contentSizeForViewInPopover.width + KoaPopoverBorderWidth*2,
                              self.contentViewController.contentSizeForViewInPopover.height + KoaPopoverBorderWidth*2);

    //Create container
    if (!self.containerView) {
        //Init container view
        self.containerView = [[UIView alloc] initWithFrame:frame];
        self.containerView.backgroundColor = [UIColor clearColor];
    }else{
        [self.containerView setFrame:frame];
    }
    
    //Add content to container
	if (![self.contentViewController.view isDescendantOfView:self.containerView]) {
        [self.containerView addSubview:self.contentViewController.view];
    }
    
    //Check main screen margins
    [self checkMainScreenMarginsOfView:self.containerView];
    
    //Add container to popover view
    if (![self.containerView isDescendantOfView:self.view]) {
        [self.view addSubview:self.containerView];
        //Customize popover (border, corners..)
        [self customizePopover:self.containerView];
    }
    
    //Add arrow to popover view
	if (![self.arrow isDescendantOfView:self.view]) {
        [self.view addSubview:self.arrow];
    }
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
    //CGSize mainScreenSize = [[UIApplication sharedApplication] delegate].window.frame.size;
    CGSize mainScreenSize = [self getCurrentScreenSize];
    CGRect popoverFrame = containerView.frame;
    
    //Check marings between popover and mainscreen limits

    //Check RIGHT
    if ((popoverFrame.origin.x + popoverFrame.size.width + KoaPopoverMarginFromMainScreen) > mainScreenSize.width) {
        
        int diff = abs((popoverFrame.origin.x + popoverFrame.size.width + KoaPopoverMarginFromMainScreen) - mainScreenSize.width);
    
        //Check if we can move the popover to the left
        if (popoverFrame.origin.x - diff > KoaPopoverMarginFromMainScreen && self.arrowDirection != UIPopoverArrowDirectionLeft) {
            [containerView setFrame:CGRectMake(popoverFrame.origin.x - diff,
                                               popoverFrame.origin.y,
                                               popoverFrame.size.width,
                                               popoverFrame.size.height)];
        }else{
            [containerView setFrame:CGRectMake(popoverFrame.origin.x,
                                               popoverFrame.origin.y,
                                               popoverFrame.size.width - diff,
                                               popoverFrame.size.height)];
        }
        popoverFrame = containerView.frame;
    }
    
    //Check LEFT
    if (popoverFrame.origin.x - KoaPopoverMarginFromMainScreen < 0) {
        
        int diff = abs(popoverFrame.origin.x - KoaPopoverMarginFromMainScreen);
        
        //Check if we can move the popover to the right
        if (popoverFrame.origin.x + popoverFrame.size.width + diff < mainScreenSize.width - KoaPopoverMarginFromMainScreen  && self.arrowDirection != UIPopoverArrowDirectionRight) {
            //We can move to the right
            [containerView setFrame:CGRectMake(popoverFrame.origin.x + diff,
                                               popoverFrame.origin.y,
                                               popoverFrame.size.width,
                                               popoverFrame.size.height)];
        }else{
            //We can't move to the right
            [containerView setFrame:CGRectMake(popoverFrame.origin.x + diff,
                                               popoverFrame.origin.y,
                                               popoverFrame.size.width - diff,
                                               popoverFrame.size.height)];
        }
        popoverFrame = containerView.frame;
    }
    
    //Check BOTTOM
    if ((popoverFrame.origin.y + popoverFrame.size.height + KoaPopoverMarginFromMainScreen) > mainScreenSize.height) {
        
        int diff = (popoverFrame.origin.y + popoverFrame.size.height + KoaPopoverMarginFromMainScreen) - mainScreenSize.height;
        
        //Check if we can move the popover to the top
        if (popoverFrame.origin.y - diff < popoverFrame.origin.y + KoaPopoverMarginFromMainScreen && self.arrowDirection != UIPopoverArrowDirectionUp) {
            //We can move to the top
            [containerView setFrame:CGRectMake(popoverFrame.origin.x,
                                               popoverFrame.origin.y - diff - KoaPopoverStatusBarHeight,
                                               popoverFrame.size.width,
                                               popoverFrame.size.height)];
        }else{
            //We can't move to the top
            [containerView setFrame:CGRectMake(popoverFrame.origin.x,
                                               popoverFrame.origin.y,
                                               popoverFrame.size.width,
                                               popoverFrame.size.height - diff - KoaPopoverStatusBarHeight)];
        }
        popoverFrame = containerView.frame;
    }
    
    //Check TOP
    if ((popoverFrame.origin.y - KoaPopoverMarginFromMainScreen) < 0) {
        
        int diff = abs(popoverFrame.origin.y - KoaPopoverMarginFromMainScreen);
        
        [containerView setFrame:CGRectMake(popoverFrame.origin.x,
                                           popoverFrame.origin.y + diff,
                                           popoverFrame.size.width,
                                           popoverFrame.size.height - diff)];
        popoverFrame = containerView.frame;
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
	[window.rootViewController.view addSubview:self.view];
	
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

#pragma mark -
#pragma mark Rotation Methods

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"WILL ROTATE");
    NSLog(@"OjectFromPResent: %@", NSStringFromCGRect(self.objectFromPresent.frame));
    [UIView animateWithDuration:0.1 animations:^{
		self.view.alpha = 0.0;
	} completion:nil];
}

     
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"DID ROTATE");
    NSLog(@"OjectFromPResent: %@", NSStringFromCGRect(self.objectFromPresent.frame));
    
    //Set popover frame
	[self setPopoverFrameFromObject:self.objectFromPresent];
        
    [UIView animateWithDuration:0.1 animations:^{
		self.view.alpha = 1.0;
	} completion:nil];
}

//- (void)viewDidLayoutSubviews
//{
//    NSLog(@"DID Layout Subviews");
//    NSLog(@"OjectFromPResent: %@", NSStringFromCGRect(self.objectFromPresent.frame));
//}

- (CGSize)getCurrentScreenSize
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    //UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        size = CGSizeMake(size.height, size.width);
    }
//    if (application.statusBarHidden == NO) {
//        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
//    }
    size.height -= self.navigationController.navigationBar.frame.size.height;
    return size;
}

@end




