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
}

- (IBAction)showPopover:(id)sender
{
    UIButton *button = sender;
    
    NSLog(@"Show Popover!");
    PopViewController *popVC = [[PopViewController alloc] initWithNibName:@"PopViewController" bundle:nil];
    [popVC setContentSizeForViewInPopover:popVC.view.frame.size];
    self.popover = [[KoaPopover alloc] initWithContentViewController:popVC];
    [self.popover setDelegate:self];
    [self.popover presentPopoverFromObject:button setArrowDirection:UIPopoverArrowDirectionLeft animated:YES];
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
