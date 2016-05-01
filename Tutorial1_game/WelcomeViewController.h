//
//  WelcomeViewController.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/20/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MagicalRecord/MagicalRecord.h>
//@class Player;

@interface WelcomeViewController : UIViewController {
    NSString *name;
    __weak IBOutlet UITextField *nameField;
}

//@property (nonatomic, strong) Player *player;

-(IBAction)saveName:(id)sender;

@end
