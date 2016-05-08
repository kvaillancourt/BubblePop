//
//  CountDownViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/8/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "CountDownViewController.h"
#import "ViewController.h"

@interface CountDownViewController () {
    
    __weak IBOutlet UILabel *textLabel;
    __weak IBOutlet UILabel *count;
    NSTimer *moveTimer;
    NSInteger time;
}

@end

@implementation CountDownViewController
@synthesize player;


- (void)viewDidLoad {
    [super viewDidLoad];
    time = 3;
    
    
    moveTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(countDown)
                                               userInfo:nil
                                                repeats:YES];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)countDown {
    count.text = [NSString stringWithFormat:@"%ld", (long)time];
    
    if (time == 2){
        textLabel.text = [NSString stringWithFormat:@"Get set!"];
    } else if (time == 1) {
        textLabel.text = [NSString stringWithFormat:@"Go!"];
        [self performSegueWithIdentifier:@"transistionGameScreen" sender:self];

    }
    
    time--;
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    ViewController *controller = (ViewController *)[segue destinationViewController];
    [controller setPlayer:player];
    //[controller setPlayer:player];
}


@end
