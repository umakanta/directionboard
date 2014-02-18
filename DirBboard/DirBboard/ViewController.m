//
//  ViewController.m
//  DirBboard
//
//  Created by Umakanta on 18/02/14.
//

#import "ViewController.h"


@interface ViewController (){

    CGFloat scale, previousScale;
    CGPoint lastLocation;
    
    CGRect selectedRect;
}

@end

@implementation ViewController
@synthesize dirBoardImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    

    previousScale = 1;
    // I made the .png file and used
    UIImage *image = [UIImage imageNamed:@"direction_board1.png"];
    dirBoardImageView = [[UIImageView alloc] initWithImage:image];
    dirBoardImageView.userInteractionEnabled = YES;
    dirBoardImageView.center = CGPointMake(160, 306);

    [self.view addSubview:dirBoardImageView];

    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(doPinch:)];
    pinchGesture.delegate = self;
    [dirBoardImageView addGestureRecognizer:pinchGesture];

    selectedRect = [dirBoardImageView convertRect:selectedRect fromView:self.view];
  
    
    
    //--------------------------
    
    UIGraphicsBeginImageContext(dirBoardImageView.frame.size);
    [dirBoardImageView.image drawInRect:CGRectMake(0, 0, dirBoardImageView.frame.size.width, dirBoardImageView.frame.size.height)];
	
    
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 2.0);
	
    // drawing with a stroke color
	CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);

    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    //CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(470.0, 550.0, 100.0, 30.0));
    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(460.0, 490.0, 120.0, 230.0));
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
	dirBoardImageView.image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();

    
    
}


- (void)doPinch:(UIPinchGestureRecognizer *)gesture
{
    scale = gesture.scale;
    
    CGAffineTransform t = CGAffineTransformMakeScale(scale * previousScale, scale * previousScale);
    dirBoardImageView.transform = t;

    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousScale = scale * previousScale;
        scale = 1;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
   
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:dirBoardImageView];
    
    if ([touch.view isEqual: self.view] || touch.view == nil) {
        return;
    }
   
    lastLocation = [touch locationInView: self.view];
    
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps == 1) {
        //NSLog(@"touchPt = %@",NSStringFromCGPoint(touchPoint));
        if (CGRectContainsPoint(CGRectMake(470.0, 550.0, 100.0, 30.0),touchPoint)) {
            
            [[[UIAlertView alloc]initWithTitle:@"Wow!" message:@"Food Court Tapped" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
        }
    }
    
}


- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
   
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch.view isEqual: self.view]) {
        return;
    }
    
    CGPoint location = [touch locationInView: self.view];
    
    CGFloat xDisplacement = location.x - lastLocation.x;
    CGFloat yDisplacement = location.y - lastLocation.y;

    CGRect frame = dirBoardImageView.frame;
    //NSLog(@"aa = %@",NSStringFromCGRect(frame));
    
    
    frame.origin.x += xDisplacement;
    frame.origin.y += yDisplacement;
    
    //[dirBoardImageView setFrame:frame];
    dirBoardImageView.frame = CGRectMake(dirBoardImageView.frame.origin.x+xDisplacement, dirBoardImageView.frame.origin.y+yDisplacement, dirBoardImageView.frame.size.width, dirBoardImageView.frame.size.height);
    
    lastLocation = location;
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
