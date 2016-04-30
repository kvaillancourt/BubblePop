//
//  WelcomeViewController.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/20/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController {
    NSString *name;
    __weak IBOutlet UITextField *nameField;
}

-(IBAction)saveName:(id)sender;

@end
