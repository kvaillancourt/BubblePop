//
//  Bubble.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 9/05/2016.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//
#import "UIKit/UIKit.h"
#import <Foundation/Foundation.h>
#import "ViewController.h" 
#import "Color.h"
#import "Bubble.h"

@interface BubbleView : UIButton
-(id)initWithSpecifications:(NSInteger)numbBubbles;
-(void)changePosition:(CGRect)viewFrame; 
-(void)changeColor:(Color *)color;
@property Bubble *bubble;
@end
