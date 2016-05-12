//
//  CountDownViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/8/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "CountDownViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface CountDownViewController () {
    
    __weak IBOutlet UILabel *textLabel;
    __weak IBOutlet UILabel *count;
    NSTimer *moveTimer;
    NSInteger time;
    NSInteger startTime;
}

@end

@implementation CountDownViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    time = 3;
    startTime = 60;
    //create countdown timer
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(countDown)
                                               userInfo:nil
                                                repeats:YES];

    // Do any additional setup after loading the view.
    
    //used to grab previous settings if they have been changed by the user
    AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ad.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SettingsBundle"];
    NSArray *previousSettings = [context executeFetchRequest:request error:nil];
    
    if (previousSettings.firstObject){
        //assign new settings
        startTime = [[[previousSettings firstObject] maxtime] integerValue];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)countDown {
    count.text = [NSString stringWithFormat:@"%ld", (long)time];
    
    //set text for users to know what they are doing
    if (time == 2){
        textLabel.text = [NSString stringWithFormat:@"Get set!"];
        _hint.text = [NSString stringWithFormat:@"Hint: Long press the screen to pause."];
    } else if (time == 1) {
        _hint.text = [NSString stringWithFormat:@"Hint: You have %d seconds!", startTime];
        textLabel.text = [NSString stringWithFormat:@"Go!"];
    } else if (time == 0) {
        [self performSegueWithIdentifier:@"transistionGameScreen" sender:self];
    }
    
    time--;
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    ViewController *controller = (ViewController *)[segue destinationViewController];
    [controller setPlayer:_player];
    //[controller setPlayer:player];
}


@end
