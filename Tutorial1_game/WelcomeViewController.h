//
//  WelcomeViewController.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/20/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Player.h"
//@class Player;

@interface WelcomeViewController : UIViewController {
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UIButton *playButton;
}

- (IBAction)buttonClick:(id)sender;

@end
