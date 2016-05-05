//
//  ViewController.m
//  ALaCarte
//
//  Created by Shane Rosse on 5/3/15.
//  Copyright (c) 2015 Shane Rosse. All rights reserved.
//

#import "ViewController.h"
#import "FoodModel.h"

static const CGFloat ThrowingThreshold = 1000;
static const CGFloat ThrowingVelocityPadding = 25;

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIView *image;
@property (nonatomic, weak) IBOutlet UIView *redSquare;
@property (nonatomic, weak) IBOutlet UIView *blueSquare;
@property (strong, nonatomic) IBOutlet UILabel *label;


@property (nonatomic, assign) CGRect originalBounds;
@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;

@property (strong, nonatomic) FoodModel* viewModel;

@end

@implementation ViewController

@synthesize label;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel = [FoodModel sharedModel];
    // Do any additional setup after loading the view, typically from a nib.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.originalBounds = self.image.bounds;
    self.originalCenter = self.image.center;
    self.label.text = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction) handleAttachmentGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self.view];
    CGPoint boxLocation = [gesture locationInView:self.image];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"you touch started position %@",NSStringFromCGPoint(location));
            NSLog(@"location in image started is %@",NSStringFromCGPoint(boxLocation));
            //remove any prior behavior
            [self.animator removeAllBehaviors];
            //establish an offset between views
            UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.image.bounds),
                                                 boxLocation.y - CGRectGetMidY(self.image.bounds));
            //initalize attachment behavior
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.image
                                                                offsetFromCenter:centerOffset
                                                                attachedToAnchor:location];
            //establish anchor points and center of tracking views
            self.redSquare.center = self.attachmentBehavior.anchorPoint;
            self.blueSquare.center = location;
            [self.animator addBehavior:self.attachmentBehavior];
                     break;
        }
        case UIGestureRecognizerStateEnded: {
            //remove any prior behavior
            [self.animator removeBehavior:self.attachmentBehavior];
            //establish velocity
            CGPoint velocity = [gesture velocityInView:self.view];
            //establish magnitude
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            //checking if it was thrown hard enough
            if (magnitude > ThrowingThreshold) {
                //initialize behavior
                UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]
                                                initWithItems:@[self.image]
                                                mode:UIPushBehaviorModeInstantaneous];
                //set the direction and magnitude of behavior
                pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding;
                
                self.pushBehavior = pushBehavior;
                [self.animator addBehavior:self.pushBehavior];
                
                NSInteger angle = arc4random_uniform(20) - 10;
                //more settings to the behavior
                self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.image]];
                self.itemBehavior.friction = 0.2;
                self.itemBehavior.allowsRotation = YES;
                [self.itemBehavior addAngularVelocity:angle forItem:self.image];
                [self.animator addBehavior:self.itemBehavior];
                //reset the string after 0.4 seconds
                [self performSelector:@selector(resetDemo) withObject:nil afterDelay:0.4];
                
                // these few lines of code insert data to the model
               
                if (self.pushBehavior.pushDirection.dx > 0) {
                    [self.viewModel addToFav];
//                    NSLog(@"Right toss!");
                }
                else {
//                    NSLog(@"Left toss!");
                }
            }
            else {
                [self resetDemo];
            }
            break;
        }
        default:
            [self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.view]];
            self.redSquare.center = self.attachmentBehavior.anchorPoint;
            break;
    }
}

- (void)resetDemo
{
    [self.animator removeAllBehaviors];
    //reset the string after it's been thrown once
    [UIView animateWithDuration:0.45 animations:^{
        self.image.bounds = self.originalBounds;
        self.image.center = self.originalCenter;
        self.image.transform = CGAffineTransformIdentity;
    }];
    self.label.text = [self.viewModel setLabelToNext];
}

@end
