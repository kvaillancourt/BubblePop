//
//  ViewController.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/18/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    NSMutableArray * buttons;
    NSMutableArray * buttonVelocities;
    NSMutableArray * buttonLocations;

    //used for physics engine
    UIDynamicAnimator* _animator;
    UICollisionBehavior* _collision;

    
    
    IBOutlet UIScreenEdgePanGestureRecognizer *pauseGuesture;
    IBOutlet UILabel * scoreLabel;
    IBOutlet UILabel * timeLabel;
    int time;
    NSTimer * moveTimer;
    NSTimer * countdownTimer;
    int score;
    int numb_bubbles;
    UIColor *previous_color;
}
-(IBAction)pause:(id)sender;
-(BOOL)isButtonOverlapping:(NSArray *)array button:(UIButton *)btn; 
- (UIButton *)createNewButton;
- (void)timerTick;
- (void)changeBubbleColor; 
- (void)countdownTick;
- (IBAction)buttonClick:(id)sender;

@end

