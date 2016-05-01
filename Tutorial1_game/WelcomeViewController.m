//
//  WelcomeViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/20/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Player.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    if ([nameField.text length] > 0) {
        [self performSegueWithIdentifier:@"ShowGameScreen" sender:self];
    }
    else {
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Invalid Name"
                                     message:[NSString stringWithFormat:@"Please enter a name to begin."]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Will do!"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
  \
    
    if ( [segue.identifier isEqualToString:@"ShowGameScreen"]){
        AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = ad.managedObjectContext;
        Player *player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:context];
        player.name=nameField.text;
        
        ViewController *c = (ViewController *)[segue destinationViewController];
        //    c.player=player;
        [c setPlayer:player];
        
    }
//    else {
////        NSLog(@"Scoreboard was tapped");
//    }

    
    //todo: force user to enter in valid name
    
    
    if(UIAccessibilityIsVoiceOverRunning())
    {
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    

    
    // access the instance of viewController here
}

@end
