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

@interface ViewController : UIViewController {
    
    NSMutableArray * buttons;
    NSMutableArray * buttonVelocities;
    NSMutableArray * buttonLocations;

    //used for physics engine
    UIDynamicAnimator* _animator;
    UICollisionBehavior* _collision;
    UIGravityBehavior *_gravity;
    IBOutlet UIScreenEdgePanGestureRecognizer *pauseGuesture;
    IBOutlet UILabel * scoreLabel;
    IBOutlet UILabel * timeLabel;
    NSInteger time;
    NSInteger startTime;
    NSTimer * moveTimer;
    NSTimer * countdownTimer;
    int score;
    int numb_bubbles;
    int bubble_max_speed;
    UIColor *previous_color;
    
    UIColor *green;
    UIColor *blue;
    UIColor *pink;
    UIColor *red;
    //black
    
}
@property Player* player;
@property SettingsBundle *settings;

-(IBAction)pause:(id)sender;
- (UIButton *)createNewButton;
- (void)timerTick;
- (void)changeBubbleColor; 
- (void)countdownTick;
- (IBAction)buttonClick:(id)sender;

@end

