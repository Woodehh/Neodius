//
//  baseMarketInfoViewController.m
//  
//
//  Created by Benjamin de Bos on 13-10-17.
//

#import "baseMarketInfoViewController.h"
#import "marketInfoTableViewController.h"
#import "marketGraphTableViewController.h"
#import "nodiusUIComponents.h"

@implementation baseMarketInfoViewController {
    BOOL isScrolling;
}

@synthesize type = _type;

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_type == nil)
        _type = @"GAS";
    
    isScrolling = YES;
    
    self.title = [NSString stringWithFormat:NSLocalizedString(@"%@ Market information",nil),_type];
    self.view.backgroundColor = neoGreenColor;
    
    //market table view controller
    marketInfoTableViewController *mitvc = [[marketInfoTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    mitvc.type = _type;
    
    marketGraphTableViewController *mgtvc = [[marketGraphTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    mgtvc.type = _type;
    
    // Do any additional setup after loading the view.
    viewControllers = @[mitvc,mgtvc];
    
    pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                        options:nil];
    pvc.delegate = self;
    pvc.dataSource = self;
    [pvc setViewControllers:@[[viewControllers objectAtIndex:0]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    
    [self addChildViewController:pvc];
    [[self view] addSubview:[pvc view]];
    [pvc didMoveToParentViewController:self];

    UIImage *menuIcon = [[NodiusDataSource sharedData] tableIconPositive:@"fa-reorder"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openLeftSide)];
    
    UIImage *refreshIcon = [[NodiusDataSource sharedData] tableIconPositive:@"fa-refresh"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:refreshIcon
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(reloadData)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disablePaging)
                                                 name:@"disablePaging"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enablePaging)
                                                 name:@"enablePaging"
                                               object:nil];

}

-(void)disablePaging {
    if (isScrolling) {
        NSLog(@"Received disable paging");
        isScrolling = NO;
        for (UIScrollView *view in pvc.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                view.scrollEnabled = NO;
            }
        }
    }
}

-(void)enablePaging {
    if (!isScrolling) {
        NSLog(@"Received enable paging");
        isScrolling = YES;
        for (UIScrollView *view in pvc.view.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                view.scrollEnabled = YES;
            }
        }
    }
}


-(void)viewDidDisappear:(BOOL)animated {
    pvc = nil;
}

-(void)reloadData {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
}

-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    if (index == 0)
        return viewControllers[1];
    index--;
    return viewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    index++;
    if (index == viewControllers.count)
        return viewControllers[0];
    return viewControllers[index];
}

-(NSInteger)indexOfViewController:(UIViewController*)viewController {
    for (int i = 0; i <= viewControllers.count; i++) {
        if (viewController == viewControllers[i]) {
            return i;
        }
    }
    return -1;
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return [viewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

@end
