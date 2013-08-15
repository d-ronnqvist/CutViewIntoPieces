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
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 320-100, 200)];
	UIView *upperView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 500, 210)];

	
    [self.view addSubview:upperView];
	[upperView addSubview:textView];
	upperView.clipsToBounds = YES;
    [textView setText:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis consequat adipiscing arcu, porttitor feugiat lectus ullamcorper quis. Donec et sem tortor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aenean nec nisl sit amet risus convallis dapibus. Nunc suscipit massa in enim facilisis vehicula. Nulla porta lectus ut metus lobortis tempor. Nam ornare elit vel ante blandit tincidunt. Suspendisse justo diam, convallis eleifend fermentum quis, aliquet et odio. Nam vehicula porttitor tincidunt. Sed porttitor, sem ut posuere adipiscing, nisl metus scelerisque neque, in lacinia lectus mauris ac mi. Etiam laoreet pretium cursus. Nunc placerat vehicula ligula ut tempus. Cras et faucibus velit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam eu felis a risus blandit dictum. Nulla justo nisl, posuere eu lacinia ac, iaculis in diam."];
    [textView setBackgroundColor:[UIColor orangeColor]];
    [textView setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:14]];
    
    UIView *tornView = [[UIView alloc] initWithFrame:[textView frame]];
	
	
	CGRect f = textView.frame;
	textView.layer.anchorPoint = CGPointMake(0.5, 1.0);
	textView.frame = f;
	
	
	textView.layer.shadowPath = CGPathCreateWithRect(textView.bounds, NULL);
	textView.layer.shadowColor = [UIColor blackColor].CGColor;
	textView.layer.shadowOffset = CGSizeMake(0, 1);
	textView.layer.shadowOpacity = 0.75;
	textView.layer.shadowRadius = 2.0;
	textView.clipsToBounds = NO;
    
    [self.view addSubview:tornView];
    
    UIImage *splitMeInTwo = [self imageRepresentationOfView:textView];
    
    NSUInteger numberOfImages = 10;
    NSMutableArray *imageViews = [NSMutableArray arrayWithCapacity:numberOfImages];
    
	CALayer *mask = [CALayer layer];
	mask.frame = CGRectMake(-100, CGRectGetHeight(tornView.bounds), 500, 999);
	mask.backgroundColor = [UIColor purpleColor].CGColor;
	
	tornView.layer.mask = mask;
	
    for (NSUInteger imageIndex = 0 ; imageIndex < numberOfImages ; imageIndex++ ) {
        // The size of each part is half the height of the whole image
        CGSize size = CGSizeMake([splitMeInTwo size].width/numberOfImages,
                                 [splitMeInTwo size].height);
        
        // Create image-based graphics context for top half
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        // Draw into context, bottom half is cropped off
//        //[image drawAtPoint:CGPointMake(0.0,0.0)];
        [splitMeInTwo drawAtPoint:CGPointMake(-size.width*imageIndex,0.0)
                        blendMode:kCGBlendModeNormal 
                            alpha:1.0];
        
        // Grab the current contents of the context as a UIImage 
        // and add it to our array
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        imageView.frame = CGRectMake(size.width*imageIndex, 0, size.width, size.height);
        imageView.layer.shadowPath = CGPathCreateWithRect(imageView.bounds, NULL);
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0, 1);
        imageView.layer.shadowOpacity = 0.75;
        imageView.layer.shadowRadius = 2.0;
        
        [tornView addSubview:imageView];
        [imageViews addObject:imageView];
        
		
        CGFloat smallAngle = M_PI/45;
        CGFloat randomSeed = rand()%10-5.0;
        imageView.layer.transform = CATransform3DMakeRotation(smallAngle * randomSeed, 1.0, 0.0, 0.0);
        imageView.layer.shouldRasterize = YES;
		
        UIGraphicsEndImageContext();
    }
    
    
    CATransform3D perspeciveTransform = CATransform3DIdentity;
    perspeciveTransform.m34 = -1.0/900.0;
    perspeciveTransform = CATransform3DTranslate(perspeciveTransform, 30, 30, 0);
    
    
    tornView.layer.sublayerTransform = perspeciveTransform;
    
	CABasicAnimation *moveFromAnchor = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
	[moveFromAnchor setToValue:[NSValue valueWithCGPoint:CGPointMake(0.5, 0.1)]];
	[moveFromAnchor setDuration:1.5];
	[moveFromAnchor setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[moveFromAnchor setAutoreverses:YES];
	[moveFromAnchor setRepeatCount:INFINITY];
	
	[textView.layer addAnimation:moveFromAnchor forKey:@"move"];

    
    [imageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imageView = obj;
        CABasicAnimation *moveFromAnchor = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
        [moveFromAnchor setToValue:[NSValue valueWithCGPoint:CGPointMake(0.5, 0.1)]];
        [moveFromAnchor setDuration:1.5];
        [moveFromAnchor setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [moveFromAnchor setAutoreverses:YES];
        [moveFromAnchor setRepeatCount:INFINITY];
        
        [imageView.layer addAnimation:moveFromAnchor forKey:@"move"];
    }];
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
