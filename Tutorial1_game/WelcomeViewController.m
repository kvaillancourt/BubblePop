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

@interface WelcomeViewController () {
    NSManagedObjectContext *context;
    NSArray *previousPlayers;
}

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    context = ad.managedObjectContext;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
    previousPlayers = [context executeFetchRequest:request error:nil];
    if ([previousPlayers lastObject]) {
        Player *player = [previousPlayers lastObject];
        
        nameField.text = [player name];
    }

    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)enditingEnded{
    [self.view endEditing:YES];

}
- (IBAction)buttonClick:(id)sender {
    if ([nameField.text length] > 0) {
        [self performSegueWithIdentifier:@"showCountDown" sender:self];
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
    
    Player *player;

    
    if ( [segue.identifier isEqualToString:@"showCountDown"]){
              for (Player * tempPlayer in previousPlayers) {
            if ([[tempPlayer name] isEqualToString:nameField.text]) {
                player = tempPlayer;
                break;
            }
        }
   
        if (!player) {
            player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:context];
            player.name=nameField.text;

        }
            
        ViewController *controller = (ViewController *)[segue destinationViewController];
        [controller setPlayer:player]; 
        //[controller setPlayer:player];
        
    }


    
    // access the instance of viewController here
    

}
@end

