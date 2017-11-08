//
//  baseMarketInfoViewController.h
//  
//
//  Created by Benjamin de Bos on 13-10-17.
//

#import <UIKit/UIKit.h>

@interface baseMarketInfoViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
    UIPageViewController *pvc;
    NSArray *viewControllers;
}
@property (nonatomic,retain) NSString *type;
@end
