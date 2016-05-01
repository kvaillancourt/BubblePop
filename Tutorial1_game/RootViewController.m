//
//  RootViewController.m
//  Tutorial1_game
//
//  Created by Kara Vaillancourt on 5/1/16.
//  Copyright © 2016 vaillancourt.kara.com. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    //Inhertance
    [super viewDidLoad];
    
    //Create the data model
    _pageTitiles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Featrues", @"Bookmark Favorite Tip", @"Free Regular Update" ];
    _pageImages = @[@"grey7.png", @"grey3.png", @"grey-2.png", @"circle.png"];
    
    //Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    //Change size of page view controller
    self.pageViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //Dispose of any resources
}

- (IBAction)startWalkThrough:(id)sender {
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

-(PageContentViewController *) viewControllerAtIndex:(NSUInteger)index
{
    if(([self.pageTitiles count] == 0) || (index >= [self.pageTitiles count]))
    {
        return nil;
    }
    
    //Create a new view controller and pass data
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PagecontentViewContoller"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitiles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    
    return[self viewControllerAtIndex:index];
    
}

-(UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;

    if(index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    
    if(index == [self.pageTitiles count])
    {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

-(NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitiles count];
}

-(NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
