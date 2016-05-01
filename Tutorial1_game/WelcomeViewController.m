//
//  WelcomeViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/20/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "WelcomeViewController.h"
#import "../Player.h"
#import "../PlayerDetails.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    name = @"";
    
//    // 1. If there is no beer, create new Beer
//    if (!self.player) {
//        self.player = [Player createEntity];
//    }
//    // 2. If there are no beer details, create new BeerDetails
//    if (!self.player.playerDetails) {
//        self.player.playerDetails = [PlayerDetails createEntity];
//    }
//    // View setup
//    // 3. Set the title, name, note field and rating of the beer
//    self.title = self.player.name ? self.player.name : @"New Player";
//    self.playerNameField.text = self.player.name;
////    self.beerNotesView.text = self.beer.beerDetails.note;
////    self.ratingControl.rating = [self.beer.beerDetails.rating integerValue];
//    [self.cellOne addSubview:self.ratingControl];
//    
////    // 4. If there is an image path in the details, show it.
////    if ([self.beer.beerDetails.image length] > 0) {
////        // Image setup
////        NSData *imgData = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:self.beer.beerDetails.image]];
////        [self setImageForBeer:[UIImage imageWithData:imgData]];
////    }
////    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveName:(id)sender {
    if ([nameField.text length] > 0) {
//        self.player.playerDetails.name = nameField.text;
    }
//    name = nameField.text;

}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
