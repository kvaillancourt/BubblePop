//
//  SettingsViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/8/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "SettingsBundle.h"
@interface SettingsViewController () {
    
    __weak IBOutlet UISlider *timeSlider;
    __weak IBOutlet UISwitch *moveBubbles;
    __weak IBOutlet UISlider *maxNumbBubbles;
    
    SettingsBundle *settings;

}

@end



@implementation SettingsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ad.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SettingsBundle"];
    NSArray *previousSettings = [context executeFetchRequest:request error:nil];
    
    if (previousSettings.firstObject) {
        settings = [previousSettings firstObject];
        [timeSlider setValue:[[settings maxtime] integerValue]];
        [moveBubbles setOn:[[settings movebubble] boolValue]];
        [maxNumbBubbles setValue:[[settings maxbubbles] integerValue]];
    }
    else {
        
        settings = [NSEntityDescription insertNewObjectForEntityForName:@"SettingsBundle" inManagedObjectContext:context];
    }
    
    // Do view setup here.

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    settings.movebubble = [NSNumber numberWithBool:[moveBubbles isOn]];
    [settings setMaxtime:[NSNumber numberWithInteger:timeSlider.value]];
    [settings setMaxbubbles:[NSNumber numberWithInteger:maxNumbBubbles.value]];
    
    
    }

@end
