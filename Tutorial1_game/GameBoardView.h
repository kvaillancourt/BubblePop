//
//  GameBoardView.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/12/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//





/*
 Tasks of this class:
 1. set the background
 2. clear the screen of all bubbles
 3. remove single bubble from view
 4. preformMagicTap
 5. sendPauseAction to Controller
 6. add BubbleViews to the screen 
 7. bubble click recognizer
 */

#import <UIKit/UIKit.h>
#import "BubbleView.h"
@class BubbleView; 

@interface GameBoardView : UIView {
    
}


- (BubbleView *)addBubble;
- (BOOL) accessibilityPerformMagicTap;
- (IBAction)pause:(id)sender;
- (IBAction)bubbleClicked:(BubbleView *)bubble;
- (id)init;
- (void) showBubble:(BubbleView *)bubble; 
- (id)initWithSpecifications:(UIViewController *)viewController;
@end
