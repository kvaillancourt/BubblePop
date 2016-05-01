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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if(UIAccessibilityIsVoiceOverRunning())
    {
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ad.managedObjectContext;
    Player *player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:context];
    player.name=nameField.text;
    
    ViewController *c = (ViewController *)[segue destinationViewController];
    //    c.player=player;
    [c setPlayer:player];
    
    // access the instance of viewController here
}

@end
