//
//  CountDownViewController.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/8/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface CountDownViewController : UIViewController
@property Player* player;
-(void)countDown;

@end
