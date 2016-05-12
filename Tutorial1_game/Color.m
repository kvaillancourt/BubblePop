//
//  Color.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/9/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "Color.h"

@implementation Color
@synthesize name;
@synthesize color;
@synthesize points;


-(id)initWithSpecifications:(UIColor *)initColor :(NSInteger)initPoints :(NSString *)initName {
    self = [self init];
    if (self) {
        color = initColor;
        name = initName;
        points = initPoints;
        
    }
    return self;
}

-(UIColor *)getColor {
    return color;
    
}
-(NSInteger)getPoints {
    return points;
    
}
-(NSString *)getName {
    return name; 
}
-(BOOL) isEqual:(id)otherColor {
    if (otherColor == self)
        return YES;
    if (!otherColor || ![otherColor isKindOfClass:[self class]])
        return NO;
    return [self isEqualToColor:otherColor];
}

-(BOOL) isEqualToColor:(Color*)otherColor {
    if (self == otherColor)
        return YES;
    
    return color == otherColor.color;
}
@end
