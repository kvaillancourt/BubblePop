//
//  ViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/18/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize player;

- (UIButton *)createNewButton{
    UIButton * clickMe = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, (int) (800 /(numb_bubbles)), (int)(800 / (numb_bubbles)))];
    [clickMe addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [clickMe setBackgroundImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
    [clickMe setBackgroundImage:[UIImage imageNamed:@"splat.png"] forState:UIControlStateHighlighted];
    
    

    CGRect buttonFrame = clickMe.frame;
    int randomX = arc4random() % (int)(self.view.frame.size.width - buttonFrame.size.width);
    int randomY = arc4random() % (int)(self.view.frame.size.height - buttonFrame.size.height);


    buttonFrame.origin.x = randomX;
    buttonFrame.origin.y = randomY;
    clickMe.frame = buttonFrame;

    [self.view addSubview:clickMe];
    
    //physics shit
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:buttons];
    ballBehavior.elasticity = 1;
    ballBehavior.friction = 0;
    ballBehavior.angularResistance = 0;
    ballBehavior.resistance = 0;
    ballBehavior.allowsRotation = NO;
    
    [_animator addBehavior:ballBehavior];
    
    
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[clickMe] mode:UIPushBehaviorModeInstantaneous];
    int is_negative = (arc4random() % 2);
    int other_is_negative = (arc4random() % 2);
    
    float x = (arc4random() % bubble_max_speed) / 4.0;
    float y = (arc4random() % bubble_max_speed) / 4.0;
    if (is_negative && other_is_negative){
            [push setPushDirection:CGVectorMake(-x, -y)];
    }
    else if (!is_negative && other_is_negative) {
        [push setPushDirection:CGVectorMake(x, -y)];
        
    }
    else if (is_negative && !other_is_negative) {
        [push setPushDirection:CGVectorMake(-x, y)];
        
    }
    else {
        [push setPushDirection:CGVectorMake(x, y)];

    }
    
    [_animator addBehavior:push];
    [push setActive:YES];
    
    return clickMe;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cavas.jpg"]];

    bubble_max_speed = 2;
    time = 2;
    buttons = [[NSMutableArray alloc] init];
    buttonVelocities = [[NSMutableArray alloc] init];
    numb_bubbles = 13;
    
    
    green = [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1];
    blue = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:204.0f/255.0f alpha:1];
    red = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    pink = [UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1];
    
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    for (int i = 0; i < numb_bubbles; i++){
        UIButton * button = [self createNewButton];
        [buttons addObject:button];
        button.hidden = YES;
     //   CGPoint vel = CGPointMake((int)(arc4random_uniform(20) - 11), (int)(arc4random_uniform(20) - 11));
       // [buttonVelocities addObject:([NSValue valueWithCGPoint:vel])];
    }
    [self changeBubbleColor];

    // Do any additional setup after loading the view, typically from a nib.
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                 target:self
                                               selector:@selector(timerTick)
                                               userInfo:nil
                                                repeats:YES];
    
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(countdownTick)
                                               userInfo:nil
                                                repeats:YES];
    
    

    
    
    _collision = [[UICollisionBehavior alloc]initWithItems:buttons];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    
    [_animator addBehavior:_collision];

    
    
}

-(IBAction)pause:(id)sender{
    [moveTimer invalidate];
    [countdownTimer invalidate];

    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Pause"
                                 message:[NSString stringWithFormat:@"Score: %d", score]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Resume"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             moveTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                                          target:self
                                                                        selector:@selector(timerTick)
                                                                        userInfo:nil
                                                                         repeats:YES];
                             
                             countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                               target:self
                                                                             selector:@selector(countdownTick)
                                                                             userInfo:nil
                                                                              repeats:YES];
                           

                         }];
    
    UIAlertAction* main = [UIAlertAction
                         actionWithTitle:@"Quit"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [self performSegueWithIdentifier:@"ShowMainMenu" sender:self];

                         }];
    
    
    
    
    [alert addAction:ok];
    [alert addAction:main];

    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)countdownTick{
    //if the game is finished
    if (time == 0){
        [moveTimer invalidate];
        [countdownTimer invalidate];
        
        //access player here
        [player setScore:[NSNumber numberWithInteger:score]];
        //save player
        AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = ad.managedObjectContext;
        
        [context save:nil];
        

        
        UIAlertController * alert = [UIAlertController
                                      alertControllerWithTitle:@"Finish"
                                      message:[NSString stringWithFormat:@"Score: %d", score]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self performSegueWithIdentifier:@"ShowScoreboard" sender:self];
//                                 UIViewController * vc = [[UIViewController alloc] init];
//                                 [self presentViewController:vc animated:YES completion:nil];

                             }];
                             
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        

        
    }
    
    [timeLabel setText:[NSString stringWithFormat:@"Time: %d", time]];
    time --;
    [self changeBubbleColor];
   

}

- (void)changeBubbleColor{
    for (UIButton * clickMe in buttons) {
        bool was_hidden = clickMe.hidden;
        clickMe.hidden = (bool)(arc4random() % 2);

        
        int colorNumber = arc4random() % 100;
        
        if (was_hidden && !clickMe.hidden){
            if (colorNumber < 40){
                //red
                [clickMe setTintColor:red]; //UIColor.redColor
            //     clickMe.accessibilityLabel = @"Red Bubble";
        
                //Protanopia Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:150.0f/255.0f green:135.0f/255.0f blue:38.0f/255.0f alpha:1]];
                
                //Deuteranopia Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:169.0f/255.0f green:130.0f/255.0f blue:0.0f/255.0f alpha:1]];
                
                //Tritanopita Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:254.0f/255.0f green:028.0f/255.0f blue:0.0f/255.0f alpha:1]];
                
            }
            else if (colorNumber < 70){
                //pink
                [clickMe setTintColor:pink];
            //    clickMe.accessibilityLabel = @"Pink Bubble";
                
                //Protanopia Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:207.0f/255.0f green:215.0f/255.0f blue:255.0f/255.0f alpha:1]];
                
                //Deuteranopia Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:255.0f/255.0f green:216.0f/255.0f blue:253.0f/255.0f alpha:1]];
                
                //Tritanopita Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:251.0f/255.0f green:209.0f/255.0f blue:225.0f/255.0f alpha:1]];
                
            }
            else if (colorNumber < 85){
                //green
                [clickMe setTintColor:green];
              //  clickMe.accessibilityLabel = @"Green Bubble";
                
                //Protanopia Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:246.0f/255.0f green:220.0f/255.0f blue:0.0f/255.0f alpha:1]];
                
                //Deuteranopia Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:255.0f/255.0f green:205.0f/255.0f blue:114.0f/255.0f alpha:1]];
                
                //Tritanopita Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:115.0f/255.0f green:247.0f/255.0f blue:225.0f/255.0f alpha:1]];
                 
            }
            else if (colorNumber < 95){
                //blue
                [clickMe setTintColor:blue];
                // clickMe.accessibilityLabel = @"Blue Bubble";
                
                //Protanopia Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:0.0f/255.0f green:120.0f/255.0f blue:240.0f/255.0f alpha:1]];
                
                //Deuteranopia Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:0.0f/255.0f green:118.0f/255.0f blue:190.0f/255.0f alpha:1]];
                
                //Tritanopita Color Seen
                //[clickMe setTintColor:[UIColor colorWithRed:0.0f/255.0f green:127.0f/255.0f blue:133.0f/255.0f alpha:1]];
                
            }
            else {
                //black - Same color for Protanopia, Deuteranopia, and Tritanopita
                [clickMe setTintColor:UIColor.blackColor];
            }
            
            UIImage * image = [clickMe.currentBackgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            [clickMe setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        
    }
}

-(BOOL)isButtonOverlapping:(NSArray *)array button:(UIButton *)btn {
    for (UIButton *btn_ in [array copy]) {
        if (btn_ == btn){continue;}
        if (CGRectIntersectsRect(btn_.frame, btn.frame) && !btn_.hidden) return YES;
    }
    return NO;
}

- (void)timerTick{
        //move the button
    for (UIButton * clickMe in buttons) {
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[clickMe] mode:UIPushBehaviorModeInstantaneous];
        [push setPushDirection:CGVectorMake((arc4random() % bubble_max_speed) / 4.0 + (60 - time) * 0.01, arc4random() % bubble_max_speed / 4.0 + (60 - time) * 0.01)];
        
        [_animator addBehavior:push];
        [push setActive:YES];
        
    }

    
}

- (IBAction)buttonClick:(UIButton *)sender{
    float bonus = 1;
    if (previous_color == sender.tintColor){
        bonus = 1.5;
    }
    previous_color = sender.tintColor;
    
    if (sender.tintColor == UIColor.blackColor){
        score += (int)(10*bonus);
    }   else if (sender.tintColor == blue){
        //Blue
        score += (int)(8*bonus);
    }    else if (sender.tintColor == green){
        //Green
        score += (int)(5*bonus);
    }   else if (sender.tintColor == pink){
        //Pink
        score += (int)(2*bonus);
    }    else if (sender.tintColor == red){
        //Red
        score += (int)(1*bonus);
    }
    
    if(UIAccessibilityIsVoiceOverRunning())
    {
        UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, @"cats");
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification,[NSString stringWithFormat:@"Socre is at %d", score]);
    }
    
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %d", score]];
    

   // [sender removeFromSuperview];
    sender.hidden = YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
