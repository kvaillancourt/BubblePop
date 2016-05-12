//
//  Bubble.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 9/05/2016.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//
#import "BubbleView.h"

@implementation BubbleView


-(id)initWithSpecifications:(NSInteger)numbBubbles {
    self = [self initWithFrame:CGRectMake(10, 10, 60, 60)];
    
    if (self){
        [self setBackgroundImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"splat.png"] forState:UIControlStateHighlighted];
        _bubble = [[Bubble alloc] init];
        
    }
    return self;
}


//randomly places the bubble according to the screen size.
-(void)changePosition:(CGRect)viewFrame {
    
    CGRect buttonFrame = self.frame;
    int randomX = arc4random() % (int)(viewFrame.size.width - buttonFrame.size.width);
    int randomY = arc4random() % (int)(viewFrame.size.height - buttonFrame.size.height);
    
    
    buttonFrame.origin.x = randomX;
    buttonFrame.origin.y = randomY;
    self.frame = buttonFrame;
}

-(void)changeColor:(Color *)color {
    _bubble.color = color.color;
    _bubble.points = color.points;
    
    [self setTintColor:color.color]; //UIColor.redColor
    self.accessibilityLabel = [NSString stringWithFormat:@"%@ Bubble",color.name];

    UIImage * image = [self.currentBackgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self setBackgroundImage:image forState:UIControlStateNormal];

}


@end
