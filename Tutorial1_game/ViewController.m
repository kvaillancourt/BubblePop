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
@synthesize settings;

- (BubbleView *)createNewButton{

    BubbleView * bubble = [[BubbleView alloc] initWithSpecifications: numb_bubbles];
    
    
  
    [bubble addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bubble];
   // [self.view sendSubviewToBack:bubble];

    //this do while loop sometimes goes inifitely.
    do {
        [bubble changePosition:self.view.frame];
    }
    while ([self isButtonOverlapping:buttons button:bubble]);
    

    
    //physics
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:buttons];
    ballBehavior.elasticity = 1;
    ballBehavior.friction = 0;
    ballBehavior.angularResistance = 0;
    ballBehavior.resistance = 0;
    ballBehavior.allowsRotation = NO;
    
    [_animator addBehavior:ballBehavior];
    
    
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[bubble] mode:UIPushBehaviorModeInstantaneous];
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
    
    return bubble;

}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cavas.jpg"]];

    //clear the screen before beginning
    for (UIView *view in self.view.subviews)
    {
        if ([view isMemberOfClass:[Bubble class]])
        {
            [(BubbleView *)view removeFromSuperview];
        }
    }

    if(UIAccessibilityIsVoiceOverRunning())
    {
        bubble_max_speed = 1;
    }
    else
    {
        bubble_max_speed = 2;
    }
    startTime = 60;
    numb_bubbles = 15;
    
    
    AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ad.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SettingsBundle"];
    NSArray *previousSettings = [context executeFetchRequest:request error:nil];
    
    if (previousSettings.firstObject){
        
    settings = [previousSettings firstObject];
    numb_bubbles = [[settings maxbubbles] integerValue];
        NSLog(@"%d",numb_bubbles);
    startTime = [[settings maxtime] integerValue];
        
        if (![[settings movebubble] boolValue]){
            bubble_max_speed = 0;
        }
    }
    time = startTime;
    
    green = [[Color alloc] initWithSpecifications:[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1] :5 :@"Green"];
    blue = [[Color alloc] initWithSpecifications:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:204.0f/255.0f alpha:1] :8 :@"Blue"];
    red = [[Color alloc] initWithSpecifications:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0] :1 :@"Red"];
    pink = [[Color alloc] initWithSpecifications:[UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1] :2 :@"Pink"];
    black = [[Color alloc] initWithSpecifications:[UIColor blackColor] :10 :@"Black"];
    
    
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    buttons = [[NSMutableArray alloc] init];
    //make sure array is empty from previous runs
    [buttons removeAllObjects];
    
    
    for (int i = 0; i < numb_bubbles; i++){
        UIButton * button = [self createNewButton];

        [buttons addObject:button];
        [button removeFromSuperview];

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
    
//    _gravity = [[UIGravityBehavior alloc] initWithItems:buttons];
//
//    CGVector vector = CGVectorMake(0.0, -1.0);
//
//    _gravity.gravityDirection = vector;
//    
//    [_animator addBehavior:_gravity];
    
    
    [_animator addBehavior:_collision];

    
    
    
}


-(BOOL)isButtonOverlapping:(NSArray *)array button:(BubbleView *)btn {
    for (BubbleView *btn_ in [array copy]) {
        if (btn_ == btn){continue;}
        if (CGRectIntersectsRect(btn_.frame, btn.frame)) return YES;
    }
    return NO;
}


-(BOOL) accessibilityPerformMagicTap {
    [self pauseActions];
    return YES;
}


-(void) pauseActions {
    [moveTimer invalidate];
    [countdownTimer invalidate];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Pause"
                                 message:[NSString stringWithFormat:@"Score: %ld", (long)score]
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

-(IBAction)pause:(id)sender{
    
    [self pauseActions];
    
}
- (void)countdownTick{
    //if the game is finished
    if (time == 0){
        [moveTimer invalidate];
        [countdownTimer invalidate];
        
        //access player here
        if (score > [[player score] integerValue]){
            [player setScore:[NSNumber numberWithInteger:score]];
            
            //save player
 
            AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = ad.managedObjectContext;
            
            [context save:nil];

        }
        

        
        UIAlertController * alert = [UIAlertController
                                      alertControllerWithTitle:@"Game Over"
                                      message:[NSString stringWithFormat:@"Score: %ld", (long)score]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self performSegueWithIdentifier:@"ShowScoreboard" sender:self];

                             }];
                             
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        

        
    }
    
    [timeLabel setText:[NSString stringWithFormat:@"Time: %ld", (long)time]];
    time --;
    [self changeBubbleColor];
   

}

- (void)changeBubbleColor{
    for (BubbleView * clickMe in buttons) {
        bool was_hidden = false;
        bool hide = (bool)(arc4random() % 2);
        if(![clickMe superview]) {
            //no superview means not in the view hierarchy
            was_hidden = true;
        }
    
        //clickMe.hidden = ;

        if (!was_hidden && hide) {
            //randomly hide
            [clickMe removeFromSuperview];
            
        }
        else if (!hide){
            
        
            [self.view addSubview:clickMe];

        
        
        int colorNumber = arc4random() % 100;
        
            //if it was hidden before, show a new color
        if (was_hidden){

            if (colorNumber < 40){
                //red
                [clickMe changeColor:red]; //UIColor.redColor
                
            }
            else if (colorNumber < 70){
                //pink
                [clickMe changeColor:pink];

            }
            else if (colorNumber < 85){
                //green
                [clickMe changeColor:green];
                 
            }
            else if (colorNumber < 95){
                [clickMe changeColor:blue];

            }
            else {
                [clickMe changeColor:black];
            }
            
          
        }
    }
        
    }
}

- (void)timerTick{
        //move the button
    for (BubbleView * clickMe in buttons) {
        
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[clickMe] mode:UIPushBehaviorModeInstantaneous];

        int is_negative = (arc4random() % 2);
        int other_is_negative = (arc4random() % 2);
        float x = 0;
        float y = 0;
        if (bubble_max_speed != 0 ){
            x = (arc4random() % bubble_max_speed) / 4.0 + (startTime - time) * 0.01;
            y = arc4random() % bubble_max_speed / 4.0 + (startTime - time) * 0.01;
        }
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
        
    }

    
}

- (IBAction)buttonClick:(BubbleView *)sender{
    float bonus = 1;
    NSInteger scoreBefore = score;
    
    if (previous_color.color == sender.bubble.color){
        bonus = 1.5;
    }
    previous_color.color = sender.bubble.color;
    
    score += (int)(sender.bubble.points *bonus);

    
    if( (scoreBefore != score) && (UIAccessibilityIsVoiceOverRunning()))
    {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [NSString stringWithFormat:@"Score: %ld", (long)score]);

    }
    
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %ld", (long)score]];
    

   [sender removeFromSuperview];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
