//
//  Color.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/9/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Color : UIColor

@property UIColor *color;
@property NSInteger points;
@property NSString *name;

-(id)initWithSpecifications:(UIColor *)color :(NSInteger)points :(NSString *)name;
-(UIColor *)getColor;
-(NSInteger)getPoints;
-(NSString *)getName;
@end
