//
//  KoaPopover.h
//  KoaPopover
//
//  Created by Sergi Gracia on 23/05/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol KoaPopoverControllerDelegate;
@interface KoaPopover : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<KoaPopoverControllerDelegate> delegate;

- (void)presentPopoverFromObject:(id)object setArrowDirection:(UIPopoverArrowDirection)arrowDirection animated:(BOOL)animated;
- (id)initWithContentViewController:(UIViewController *)contentViewController;
- (void)dismissPopoverAnimated:(BOOL)animated;

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end

@protocol KoaPopoverControllerDelegate <NSObject>
@optional
- (void)popoverControllerDidDismissPopover:(KoaPopover *)popoverController;
- (BOOL)popoverControllerShouldDismissPopover:(KoaPopover *)popoverController;
@end