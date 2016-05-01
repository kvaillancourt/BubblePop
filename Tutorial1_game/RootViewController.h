//
//  RootViewController.h
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/1/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface RootViewController : UIViewController <UIPageViewControllerDataSource>

- (IBAction)startWalkThrough:(id)sender;

@property(strong, nonatomic) UIPageViewController *pageViewController;
@property(strong, nonatomic) NSArray *pageTitiles;
@property(strong, nonatomic) NSArray *pageImages;

@end
