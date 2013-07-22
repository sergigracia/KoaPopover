//
//  PopViewController.m
//  KoaPopover
//
//  Created by Sergi Gracia on 23/05/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation PopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    //[self performSelector:@selector(resizeView) withObject:nil afterDelay:2];
}

- (void)resizeView
{
    NSLog(@"RESIZING");
    
    [self.textView setFrame:CGRectMake(self.textView.frame.origin.x,
                                       self.textView.frame.origin.y,
                                       self.textView.frame.size.width,
                                       self.textView.frame.size.height-20)];
    
    [self.view setFrame:CGRectMake(self.view.frame.origin.x,
                                   self.view.frame.origin.y,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height-20)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
