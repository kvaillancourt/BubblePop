//
//  ScoreboardViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/20/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "ScoreboardViewController.h"
#import "AppDelegate.h"
#import "Player.h"
@interface ScoreboardViewController (){
    NSArray *players;
    
}

@property (weak, nonatomic) IBOutlet UITableView *scoreBoardTableView;

@end

@implementation ScoreboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scoreBoardTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    AppDelegate *ad = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = ad.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Player"];
    players = [context executeFetchRequest:request error:nil];
    
    //TODO sort the fuck up!
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * tableCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Player *player = [players objectAtIndex:indexPath.row];
    tableCell.textLabel.text = [NSString stringWithFormat:@"%@    %@", [player name], [player score]];
    return tableCell; 
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
