//
//  GameBoardView.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/12/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "GameBoardView.h"

@implementation GameBoardView {
    ViewController * controller;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
     //   [self initWithSpecifications:];
    }
    
    return self;
}

- (id)init {
//    self = [super init];
//    
//    if (self) {
//        controller = [self superview];
//    }
//    return self;
    [NSException raise:@"Invalid inititalization." format:@"Must initialzie with view controller."];
    return nil;
}


- (id)initWithSpecifications:(ViewController *) viewController {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cavas.jpg"]];
//        UILongPressGestureRecognizer* longPress = [ [ UILongPressGestureRecognizer alloc ] initWithTarget:self.nextResponder action:@selector(longPressEvent:)];
//        
//        categoryPanelDrag.minimumPressDuration = 0.0;


        controller = viewController;
    }
    return self;
    
}


- (BubbleView *)addBubble {
    
    BubbleView * bubble = [[BubbleView alloc] init];
    [bubble addTarget:self action:@selector(bubbleClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:bubble];
    
    return bubble;

}


- (void) showBubble:(BubbleView *)bubble {
    [self addSubview:bubble];
}


- (BOOL) accessibilityPerformMagicTap {
    [controller pauseActions];
    return YES;
}


- (IBAction)pause:(id)sender {
    [controller pauseActions];
    
}


- (IBAction)bubbleClicked:(BubbleView *)bubble {
    [controller buttonClick:bubble]; 
    [bubble removeFromSuperview];
    
}

@end
