//
//  ViewController.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/18/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "SettingsBundle.h"
#import "BubbleView.h"
#import "Bubble.h"
#import "BubbleView.h"
#import "Color.h"
@class BubbleView;

@interface ViewController : UIViewController {
    
    NSMutableArray * buttons;
    
    //used for physics engine
    UIDynamicAnimator* _animator;
    UICollisionBehavior* _collision;
//    UIGravityBehavior *_gravity;

    
    //UI elements
    IBOutlet UIScreenEdgePanGestureRecognizer *pauseGuesture;
    IBOutlet UILabel * scoreLabel;
    IBOutlet UILabel * timeLabel;
    
    //used for game time management
    NSInteger time;
    NSInteger startTime;
    NSTimer * moveTimer;
    NSTimer * countdownTimer;
    

    //game engine elements
    NSInteger score;
    NSInteger numb_bubbles;
    NSInteger bubble_max_speed;
    Color *previous_color;
    
    //colors for bubbles
    Color *green;
    Color *blue;
    Color *pink;
    Color *red;
    Color *black;
    
}
//to keep track of players high scores and settings
@property Player* player;
@property SettingsBundle *settings;

//when game is paused
-(IBAction)pause:(id)sender;
//creates new bubble  objects
-(BubbleView *)createNewButton;

//speeds up physics
- (void)timerTick;
//changes bubble colors
- (void)changeBubbleColor;
//used to keep track of time remaining
- (void)countdownTick;
//adds points and pops bubbles
- (IBAction)buttonClick:(id)sender;
-(BOOL)isButtonOverlapping:(NSArray *)array button:(BubbleView *)btn;
@end

