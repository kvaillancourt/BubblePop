//
//  ViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/18/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (UIButton *)createNewButton{
    UIButton * clickMe = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, (int) (800 /(numb_bubbles)), (int)(800 / (numb_bubbles)))];
    [clickMe addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [clickMe setBackgroundImage:[UIImage imageNamed:@"bubble.png"] forState:UIControlStateNormal];
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Black-iphone-6-background.jpg"]];

    bubble_max_speed = 2;
    time = 60;
    buttons = [[NSMutableArray alloc] init];
    buttonVelocities = [[NSMutableArray alloc] init];
    numb_bubbles = 15;
    
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
    
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(countdownTick)
                                               userInfo:nil
                                                repeats:YES];
    
    

    
    
    _collision = [[UICollisionBehavior alloc]initWithItems:buttons];
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    
    [_animator addBehavior:_collision];

    
    
}

-(IBAction)pause:(id)sender{
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
                         }];
    
    UIAlertAction* main = [UIAlertAction
                         actionWithTitle:@"Quit"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    
    
    
    [alert addAction:ok];
    [alert addAction:main];

    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)countdownTick{
    //if the game is finished
    if (time == 0){
        
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
                [clickMe setTintColor:UIColor.redColor];
            }
            else if (colorNumber < 70){
                //pink
                [clickMe setTintColor:UIColor.magentaColor];
            }
            else if (colorNumber < 85){
                //green
                [clickMe setTintColor:UIColor.greenColor];
            }
            else if (colorNumber < 95){
                //blue
                [clickMe setTintColor:UIColor.blueColor]; //[UIColor colorWithRed:0 green:0 blue:1.0f alpha:1]]
            }
            else {
                //black
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
    }   else if (sender.tintColor == UIColor.blueColor){
        score += (int)(8*bonus);
    }    else if (sender.tintColor == UIColor.greenColor){
        score += (int)(5*bonus);
    }   else if (sender.tintColor == UIColor.magentaColor){
        score += (int)(2*bonus);
    }    else if (sender.tintColor == UIColor.redColor){
        score += (int)(1*bonus);
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
