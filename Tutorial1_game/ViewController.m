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


    
//    CGRect buttonFrame = clickMe.frame;
    buttonFrame.origin.x = randomX;
    buttonFrame.origin.y = randomY;
    clickMe.frame = buttonFrame;

    [self.view addSubview:clickMe];
    
    //physics shit
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:buttons];
    ballBehavior.elasticity = 1;
    ballBehavior.friction = 0;
    ballBehavior.resistance = 0;
    ballBehavior.allowsRotation = NO;
    
    [_animator addBehavior:ballBehavior];
    
    
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[clickMe] mode:UIPushBehaviorModeInstantaneous];
    [push setPushDirection:CGVectorMake(arc4random() % bubble_max_speed, arc4random() % bubble_max_speed)];
    
    [_animator addBehavior:push];
    [push setActive:YES];
    
    return clickMe;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    bubble_max_speed = 2.5;
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
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:5
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
        

        //should save the data here
        
//        NSManagedObjectContext *context = [self managedObjectContext];
//        NSManagedObject *powerDesc = [NSEntityDescription insertNewObjectForEntityForName:@"EY_Appliance" inManagedObjectContext:context];
        //
        //
        //[powerDesc setValue:self.applianceId.text forKey:@"applianceId"];
        //[powerDesc setValue:self.applianceName.text forKey:@"applianceName"];
        //[powerDesc setValue:self.watts.text forKey:@"watts"];
        //[powerDesc setValue:self.amountPerWatts.text forKey:@"amountPerWatts"];
        //
        //// Save the context
        //NSError *error = nil;
        //if (![context save:&error]) {
        //    NSLog(@"Saving Failed!, Error and its Desc %@ %@", error, [error localizedDescription]);
        //}
        
    }
    
    [timeLabel setText:[NSString stringWithFormat:@"Time: %d", time]];
    time --;
    [self changeBubbleColor];
   

}

- (void)changeBubbleColor{
    for (UIButton * clickMe in buttons) {
        bool was_hidden = clickMe.hidden;
        clickMe.hidden = (bool)(arc4random() % 2);

        
//        while ([self isButtonOverlapping:buttons button:clickMe]){
//            CGRect buttonFrame = clickMe.frame;
//            
//            buttonFrame.origin.x = arc4random() % (int)(self.view.frame.size.width - buttonFrame.size.width);
//            buttonFrame.origin.y = arc4random() % (int)(self.view.frame.size.height - buttonFrame.size.height);;
//            clickMe.frame = buttonFrame;
//
//        }
//        
        
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
        [push setPushDirection:CGVectorMake(arc4random() % 2, arc4random() % 2)];
        
        [_animator addBehavior:push];
        [push setActive:YES];
        
//        //where in this array, clickMe is
//        long buttonIndex = [buttons indexOfObject:clickMe];
//        NSValue * buttonVelocityValue = [buttonVelocities objectAtIndex:buttonIndex];
//        CGPoint buttonVelocity = [buttonVelocityValue CGPointValue];
//        CGRect buttonFrame = [clickMe frame];
//        
//        //move down
//        buttonFrame.origin.y += buttonVelocity.y;
//        //move right
//        buttonFrame.origin.x += buttonVelocity.x;
//        
//        if (!clickMe.hidden && [self isButtonOverlapping:buttons button:clickMe]) {
//            buttonVelocity.y *= -1;
//            buttonVelocity.x *= -1;
//            buttonFrame.origin.y += buttonVelocity.y*2;
//            buttonFrame.origin.x += buttonVelocity.x*2;
//        }

        
        
//        this shit checks to see if it has collided with any other bubble.
//        int thatY, thatX;
//        int thisY = buttonFrame.origin.y;
//        int thisX = buttonFrame.origin.x;
//        int size = buttonFrame.size.height;
//        
//        bool left_intrusion, right_intrusion, top_intrusion, bottom_intrusion;
//        NSLog(@"%d size", size);
//        
//        for (UIButton * otherButton in buttons) {
//        
//            if (otherButton.hidden || otherButton == clickMe){
//                continue;
//            }
//            thatY = otherButton.frame.origin.y;
//            thatX = otherButton.frame.origin.x;
//            
//            left_intrusion = (thisX < thatX && thisX + size >= thatX);
//            right_intrusion = (thisX <= thatX + size && thatX + size <= thisX + size);
//            bottom_intrusion = thisY <= thatY && thatY <= thisY + size;
//            top_intrusion = thisY >= thatY && thisY <= thatY + size;
//            
//            if (left_intrusion && bottom_intrusion) {
//                clickMe.hidden = YES;
////                buttonVelocity.y *= -1;
////                buttonVelocity.x *= -1;
//                NSLog(@"left bottom ");
//
//            }
//            else if (left_intrusion && top_intrusion) {
////                buttonVelocity.y *= -1;
////                buttonVelocity.x *= -1;
//                clickMe.hidden = YES;
//
//                NSLog(@"left top ");
//
//            }
//            else if (right_intrusion && bottom_intrusion){
////                buttonVelocity.y *= -1;
////                buttonVelocity.x *= -1;
//                clickMe.hidden = YES;
//
//                NSLog(@"right bottom ");
//
//
//            }
//            else if (right_intrusion && top_intrusion) {
////                buttonVelocity.y *= -1;
////                buttonVelocity.x *= -1;
//                clickMe.hidden = YES;
//
//                NSLog(@"right top ");
//
//            }
//            else {
//                clickMe.hidden = NO;
//
//                NSLog(@"no collision");
//            }
//
//        }
        
        
        
////               origin is the top left hand corner
//        if (buttonFrame.origin.x < 0  || buttonFrame.origin.x + buttonFrame.size.width > self.view.frame.size.width){
//            //if it hit the left side || hit the right side
//         //   clickMe.hidden = YES;
//            buttonVelocity.x *= -1;
//            //move right
//            buttonFrame.origin.x += buttonVelocity.x;
//        }
//        if (buttonFrame.origin.y < 0  || buttonFrame.origin.y + buttonFrame.size.height > self.view.frame.size.height){
//            //if it hit the top side || hit the bottom side
//           // clickMe.hidden = YES;
//
//            buttonVelocity.y *= -1;
//            buttonFrame.origin.y += buttonVelocity.y;
//
//        }
//
//        [clickMe setFrame:buttonFrame];
//        [buttonVelocities replaceObjectAtIndex:buttonIndex withObject:[NSValue valueWithCGPoint:buttonVelocity]];
//        
    }
//    NSLog(buttonVelocities);

    
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
  
     //sender.accessibilityValue:@"Color";
    
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %d", score]];
    
//    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[sender] mode:UIPushBehaviorModeInstantaneous];
//    [push setPushDirection:CGVectorMake(arc4random() % 4, arc4random() % 4)];
//    
//    [_animator addBehavior:push];
//    [push setActive:YES];

   // [sender removeFromSuperview];
    sender.hidden = YES;
    
//    CGRect buttonFrame = sender.frame;
//    int randomX = arc4random() % (int)(self.view.frame.size.width - buttonFrame.size.width);
//    int randomY = arc4random() % (int)(self.view.frame.size.height - buttonFrame.size.height);
//    
//    buttonFrame.origin.x = randomX;
//    buttonFrame.origin.y = randomY;
//    sender.frame = buttonFrame;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
