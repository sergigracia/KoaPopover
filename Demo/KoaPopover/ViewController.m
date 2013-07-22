//
//  ViewController.m
//  KoaPopover
//
//  Created by Sergi Gracia on 23/05/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "ViewController.h"
#import "PopViewController.h"

@interface ViewController ()

@property (nonatomic, strong) KoaPopover *popover;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self.view setBackgroundColor:[UIColor colorWithRed:224/255.f green:59/255.f blue:63/255.f alpha:1]];
}

- (IBAction)showPopoverArrowDirectionLeft:(id)sender
{
    UIButton *button = sender;
    NSLog(@"Show Popover!");
    PopViewController *popVC = [[PopViewController alloc] initWithNibName:@"PopViewController" bundle:nil];
    [popVC setContentSizeForViewInPopover:popVC.view.frame.size];
    NSLog(@"Size: %@", NSStringFromCGSize(popVC.view.frame.size));
    self.popover = [[KoaPopover alloc] initWithContentViewController:popVC];
    [self.popover setDelegate:self];
    [self.popover presentPopoverFromObject:button setArrowDirection:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)showPopoverArrowDirectionRight:(id)sender
{
    UIButton *button = sender;
    NSLog(@"Show Popover!");
    PopViewController *popVC = [[PopViewController alloc] initWithNibName:@"PopViewController" bundle:nil];
    [popVC setContentSizeForViewInPopover:popVC.view.frame.size];
    NSLog(@"Size: %@", NSStringFromCGSize(popVC.view.frame.size));
    self.popover = [[KoaPopover alloc] initWithContentViewController:popVC];
    [self.popover setDelegate:self];
    [self.popover presentPopoverFromObject:button setArrowDirection:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)showPopoverArrowDirectionUp:(id)sender
{
    UIButton *button = sender;
    NSLog(@"Show Popover!");
    PopViewController *popVC = [[PopViewController alloc] initWithNibName:@"PopViewController" bundle:nil];
    [popVC setContentSizeForViewInPopover:popVC.view.frame.size];
    NSLog(@"Size: %@", NSStringFromCGSize(popVC.view.frame.size));
    self.popover = [[KoaPopover alloc] initWithContentViewController:popVC];
    [self.popover setDelegate:self];
    [self.popover presentPopoverFromObject:button setArrowDirection:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)showPopoverArrowDirectionDown:(id)sender
{
    UIButton *button = sender;
    NSLog(@"Show Popover!");
    PopViewController *popVC = [[PopViewController alloc] initWithNibName:@"PopViewController" bundle:nil];
    [popVC setContentSizeForViewInPopover:popVC.view.frame.size];
    NSLog(@"Size: %@", NSStringFromCGSize(popVC.view.frame.size));
    self.popover = [[KoaPopover alloc] initWithContentViewController:popVC];
    [self.popover setDelegate:self];
    [self.popover presentPopoverFromObject:button setArrowDirection:UIPopoverArrowDirectionDown animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.popover willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.popover didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
