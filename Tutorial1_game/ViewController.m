//
//  ViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/18/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@class GameBoardView;

@interface ViewController () <UICollisionBehaviorDelegate>

@end

@implementation ViewController



- (BubbleView *)createNewButton{

    BubbleView * bubble = [[BubbleView alloc] init];
    
//    BubbleView *bubble = [gameBoardView addBubble];
  
    [bubble addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_collision addItem:bubble];
    [self.view addSubview:bubble];

    //this do while loop sometimes goes inifitely.
    do {
        [bubble changePosition:self.view.frame];
    }
    while ([self isButtonOverlapping:buttons button:bubble]);
    

    
    //physics to make the bubbles bounce
    UIDynamicItemBehavior *ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:buttons];
    ballBehavior.elasticity = 1;
    ballBehavior.friction = 0;
    ballBehavior.angularResistance = 0;
    ballBehavior.resistance = 0;
    ballBehavior.allowsRotation = NO;
    
    [_animator addBehavior:ballBehavior];
    
    //push the bubble so that it moves around the screen in a random direction
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[bubble] mode:UIPushBehaviorModeInstantaneous];
    int is_negative = (arc4random() % 2);
    int other_is_negative = (arc4random() % 2);
    
    float x = (arc4random() % bubble_max_speed) / 4.0;
    float y = (arc4random() % bubble_max_speed) / 4.0;
    
    //if the max bubble speed is 0, both x and y will also be 0 due to mod by 0 rule.
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
//    [gameboardview showBubble:bubble];
    [_animator addBehavior:push];
    [push setActive:YES];
    
    return bubble;

}



- (void)viewDidLoad {
    [super viewDidLoad];
//    gameBoardView = [[GameBoardView alloc] initWithSpecifications:self];
// 
//    [self.view addSubview:gameBoardView];
//
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cavas.jpg"]];


    //this is my "special functionality" by implementing voiceOver blind people can use the app
    if(UIAccessibilityIsVoiceOverRunning())
    {
        bubble_max_speed = 1;
    }
    else
    {
        bubble_max_speed = 2;
    }
    
    //time used to start the game with if no settings are changed
    startTime = 60;
    numb_bubbles = 15;
    
   
    
    //used to grab previous settings if they have been changed by the user
    AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ad.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SettingsBundle"];
    NSArray *previousSettings = [context executeFetchRequest:request error:nil];
    
    if (previousSettings.firstObject){
        //assign new settings
        _settings = [previousSettings firstObject];
        numb_bubbles = [[_settings maxbubbles] integerValue];
        startTime = [[_settings maxtime] integerValue];
        
        if (![[_settings movebubble] boolValue]){
            bubble_max_speed = 0;
        }
    }
    time = startTime;
    [timeLabel setText:[NSString stringWithFormat:@"Time: %ld", (long)time]];

    //create the color objects for the game. Assign voice over text as well as ui color and point values
    green = [[Color alloc] initWithSpecifications:[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:0.0f/255.0f alpha:1] :5 :@"Green"];
    blue = [[Color alloc] initWithSpecifications:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:204.0f/255.0f alpha:1] :8 :@"Blue"];
    red = [[Color alloc] initWithSpecifications:[UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0] :1 :@"Red"];
    pink = [[Color alloc] initWithSpecifications:[UIColor colorWithRed:255.0f/255.0f green:204.0f/255.0f blue:255.0f/255.0f alpha:1] :2 :@"Pink"];
    black = [[Color alloc] initWithSpecifications:[UIColor blackColor] :10 :@"Black"];
    
    
    //animates the bubbles around the screen
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    buttons = [[NSMutableArray alloc] init];
    //make sure array is empty from previous runs
    [buttons removeAllObjects];
    
    //create all our bubbles!
    for (int i = 0; i < numb_bubbles; i++){
        BubbleView * button = [self createNewButton];

        [buttons addObject:button];
        //remove so the "naked" color isn't shown until our bubbles have been assigned a color
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
    
    //add collisions for physics effects
    _collision = [[UICollisionBehavior alloc]initWithItems:buttons];
  
    _collision.translatesReferenceBoundsIntoBoundary = YES;

    
    [_animator addBehavior:_collision];

    
    
    
}

//makes sure no buttons overlap when they are added to the screen
-(BOOL)isButtonOverlapping:(NSArray *)array button:(BubbleView *)btn {
    for (BubbleView *btn_ in [array copy]) {
        if (btn_ == btn){continue;}
        if (CGRectIntersectsRect(btn_.frame, btn.frame)) return YES;
    }
    return NO;
}

//magic tap is implemented because the pause functionality isn't available with voice over activated
- (BOOL) accessibilityPerformMagicTap {
    [self pauseActions];
    return YES;
}

//preform ui alerts when game is paused
-(void) pauseActions {
    [moveTimer invalidate];
    [countdownTimer invalidate];
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Pause"
                                 message:[NSString stringWithFormat:@"Score: %ld", (long)score]
                                 preferredStyle:UIAlertControllerStyleAlert];
    //go back to game playing
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
    //go back to main screen
    UIAlertAction* main = [UIAlertAction
                           actionWithTitle:@"Quit"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [alert dismissViewControllerAnimated:YES completion:nil];
                               [self performSegueWithIdentifier:@"ShowMainMenu" sender:self];
                               
                           }];
    
    
    
    //add alert actions here
    [alert addAction:ok];
    [alert addAction:main];
    
    //show alert
    [self presentViewController:alert animated:YES completion:nil];
}


//iboutlet to longpressguesture to pause game when there is a long press on the screen
-(IBAction)pause:(id)sender{
    
    [self pauseActions];
    
}

//counts down the seconds until game is finished.
- (void)countdownTick{
    //if the game is finished
    if (time == 0){
        [moveTimer invalidate];
        [countdownTimer invalidate];
        
        //access player for scoreboard here
        //alternate scoring can be kept where there is one entry per user. If a user has a higher score the old
        //score will be replaced with the new one
        if (score > [[_player score] integerValue]){
            [_player setScore:[NSNumber numberWithInteger:score]];
            
            //save player
 
            AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = ad.managedObjectContext;
            
            [context save:nil];

        }
        

        //alert user when a game has been completed
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
    //if the game is not finished, then keep counting down the timer
    [timeLabel setText:[NSString stringWithFormat:@"Time: %ld", (long)time]];
    time --;
    [self changeBubbleColor];
   

}


//go through every bubble object and change the color (activated every second)
- (void)changeBubbleColor{
    for (BubbleView * clickMe in buttons) {
        
        //we only want to change the bubble's color if the bubble was removed previously
        bool was_hidden = false;
        //random variable to tell whether or not to hide the bubble this second
        bool hide = (bool)(arc4random() % 2);
        if(![clickMe superview]) {
            //no superview means not in the view hierarchy, therefore was removed from the screen
            //and we should change the color if it is to be added this second
            was_hidden = true;
        }
    
        
        //if the bubble was not hidden and should  hidden
        if (!was_hidden && hide) {
            // hide
            [clickMe removeFromSuperview];
            
        }
        //show bubble
        else if (!hide){
            
//            [gameBoardView showBubble:clickMe];

            [self.view addSubview:clickMe];

        
        //random color integer
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

//each 3 seconds we want to increase the speed of the bubbles moving across the screen
- (void)timerTick{
//        move the button
    for (BubbleView * clickMe in buttons) {
        
        
        //create a push behavior
        UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[clickMe] mode:UIPushBehaviorModeInstantaneous];

        //creates a random negative value for the direction to move in the x coordinate
        int is_negative = (arc4random() % 2);
        
        //creates other random negative value for the direction to move in the y coordinate
        int other_is_negative = (arc4random() % 2);
        
        //velocites in x and y direction
        float x = 0;
        float y = 0;
        
        //if the bubble speed is 0 we don't want to speed the bubbles up .. we want to keep them still
        if (bubble_max_speed != 0 ){
            //if the bubble speed is not 0 then we want to create a random velocity that is increasing based
            //on the timer (the more time has passed, the faster the bubbles get)
            x = (arc4random() % bubble_max_speed) / 4.0 + (startTime - time) * 0.01;
            y = arc4random() % bubble_max_speed / 4.0 + (startTime - time) * 0.01;
        }
        
        //sets the random velocities of the push
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
        //push!
        [_animator addBehavior:push];
        [push setActive:YES];
        
    }

    
}

//what happens when a button is clicked in the view.
- (IBAction)buttonClick:(BubbleView *)sender {
    
    //by how much we want to multiply if we have two consecutive colors
    float bonus = 1;
    
    //keep track of the score for voiceover
    NSInteger scoreBefore = score;
    
    //checking to see if we earned bonus points
    if (previous_color.color == sender.bubble.color){
        bonus = 1.5;
    }
    previous_color.color = sender.bubble.color;
    
    //grab bubble score, multiply by bonus and add to previous game score
    score += (int)(sender.bubble.points * bonus);

    
    //voiceover alerts
    if( (scoreBefore != score) && (UIAccessibilityIsVoiceOverRunning()))
    {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [NSString stringWithFormat:@"Score: %ld", (long)score]);

    }
    
    //updates the score label with new points
    [scoreLabel setText:[NSString stringWithFormat:@"Score: %ld", (long)score]];
    
    
    //get rid of popped bubble
    [sender removeFromSuperview];
//    [_collision removeItem:sender];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
