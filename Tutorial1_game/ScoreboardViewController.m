//
//  ScoreboardViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 4/20/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "ScoreboardViewController.h"

@interface ScoreboardViewController ()
@property (weak, nonatomic) IBOutlet UITableView *board;
//var names = [String]()
@end

@implementation ScoreboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    title = "\"The List\""
//    tableView.registerClass(UITableViewCell.self,
//                            forCellReuseIdentifier: "Cell")
    // Do any additional setup after loading the view.
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

@end
