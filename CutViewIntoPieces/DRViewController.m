//
//  DRViewController.m
//  CutViewIntoPieces
//
//  Created by David Rönnqvist on 2012-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DRViewController ()

@end

@implementation DRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 50, 320-100, 200)];
    [self.view addSubview:textView];
    [textView setText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consequat adipiscing arcu, porttitor feugiat lectus ullamcorper quis. Donec et sem tortor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean nec nisl sit amet risus convallis dapibus. Nunc suscipit massa in enim facilisis vehicula. Nulla porta lectus ut metus lobortis tempor. Nam ornare elit vel ante blandit tincidunt. Suspendisse justo diam, convallis eleifend fermentum quis, aliquet et odio. Nam vehicula porttitor tincidunt. Sed porttitor, sem ut posuere adipiscing, nisl metus scelerisque neque, in lacinia lectus mauris ac mi. Etiam laoreet pretium cursus. Nunc placerat vehicula ligula ut tempus. Cras et faucibus velit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam eu felis a risus blandit dictum. Nulla justo nisl, posuere eu lacinia ac, iaculis in diam."];
    [textView setBackgroundColor:[UIColor orangeColor]];
    [textView setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:14]];
    
    
    
    UIImage *splitMeInTwo = [self imageRepresentationOfView:textView];
    
    // The size of each part is half the height of the whole image
    CGSize size = CGSizeMake([splitMeInTwo size].width, [splitMeInTwo size].height/2);
    
    // Create image-based graphics context for top half
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    // Draw into context, bottom half is cropped off
    //[image drawAtPoint:CGPointMake(0.0,0.0)];
    [splitMeInTwo drawAtPoint:CGPointMake(0.0,0.0) blendMode:kCGBlendModeNormal alpha:1.0];
    
    // Grab the current contents of the context as a UIImage 
    // and add it to our array
    UIImage *top = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *topV = [[UIImageView alloc] initWithImage:top];
    topV.frame = CGRectMake(0, 0, size.width, size.height);

    [self.view addSubview:topV];

    
    UIGraphicsEndImageContext();
}

- (UIImage *)imageRepresentationOfView:(UIView *)view {
    CGSize imageSize = [view frame].size;
    BOOL imageIsOpaque = [view isOpaque];
    CGFloat imageScale = 0.0; // automatically set to scale factor of main screen
    UIGraphicsBeginImageContextWithOptions(imageSize, imageIsOpaque, imageScale);
    CALayer * drawingLayer = [view layer];
    [drawingLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
