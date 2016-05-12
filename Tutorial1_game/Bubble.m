//
//  Bubble.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/12/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

-(id)init {
    return [self initWithSpecifications:UIColor.blackColor :0];
}

-(id)initWithSpecifications:(UIColor *)thisColor :(NSInteger)thisPoints {
    self = [super init];
    
    if (self) {
        _color = thisColor;
        _points = thisPoints;
    }
    return self;
}

@end
