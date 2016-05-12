//
//  Color.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/9/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "Color.h"

@implementation Color


-(id)initWithSpecifications:(UIColor *)initColor :(NSInteger)initPoints :(NSString *)initName {
    self = [self init];
    if (self) {
        _color = initColor;
        _name = initName;
        _points = initPoints;
        
    }
    return self;
}

-(UIColor *)getColor {
    return _color;
    
}
-(NSInteger)getPoints {
    return _points;
    
}
-(NSString *)getName {
    return _name;
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
    
    return _color == otherColor.color && _points == otherColor.points && [_name isEqualToString:otherColor.name];
}
@end
