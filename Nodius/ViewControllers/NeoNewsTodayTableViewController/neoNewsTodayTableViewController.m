//
//  neoNewsTodayTableViewController.m
//  Nodius
//
//  Created by Benjamin de Bos on 05-10-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "neoNewsTodayTableViewController.h"
#import "neoNewsTodayTableViewCell.h"

@implementation neoNewsTodayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //setup the request network manager
    networkManager = [AFHTTPSessionManager manager];
    
    UIImage *menuIcon = [[NodiusDataSource sharedData] tableIconPositive:@"fa-reorder"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openLeftSide)];

    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.tableView.refreshControl = self.refreshControl;
    [self.refreshControl addTarget:self action:@selector(loadRss) forControlEvents:UIControlEventValueChanged];
    [self loadRss];
    self.title = @"NEONewsToday.com";
}

-(void)loadRss {
    NSLog(@"load rss");
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    networkManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [networkManager GET:@"https://neonewstoday.com/feed/"
             parameters:nil
               progress:nil
                success:^(NSURLSessionTask *task, id responseObject) {
                    NSError *error;
                    NSDictionary *tmpDict = [XMLReader dictionaryForXMLData:responseObject error:&error];
                    if (error) {
                        NSLog(@"Foutje gebeurd! :-)");
                    } else {
                        posts = [[[tmpDict objectForKey:@"rss"] objectForKey:@"channel"] objectForKey:@"item"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.refreshControl endRefreshing];
                            [hud hideAnimated:YES];
                            [self.tableView reloadData];
                        });
                    }
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    [hud hideAnimated:YES];
                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [posts count]-1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellName = @"tableCell";
    neoNewsTodayTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[neoNewsTodayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    } else {
         [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.headerImage];
        cell.headerImage.image = [UIImage new];
    }
    
    //set dictionary
    NSDictionary *p = [posts objectAtIndex:indexPath.section];
    
    //set body
    NSString *body = [[p objectForKey:@"description"] objectForKey:@"text"];
    
    //set header image
    NSString *imageUrl;
    NSArray *image = [body rx_textsForMatchesWithPattern:@"src=\"(.*?)\""];
    if ([image count] >0) {
        imageUrl = [[image objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        imageUrl = [[imageUrl stringByReplacingOccurrencesOfString:@"src=" withString:@""] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    } else {
        imageUrl = @"empty";
    }
    
    //set image
    cell.headerImage.showActivityIndicator = YES;
    cell.headerImage.activityIndicatorColor = neoGreenColor;
    cell.headerImage.activityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
    cell.headerImage.imageURL = [NSURL URLWithString:imageUrl];
    
    //set title label
    cell.titleLabel.text = [[p objectForKey:@"title"] objectForKey:@"text"];
    //ScrollableGraphView* x = [[ScrollableGraphView alloc] init];
    
    //set the date and category
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
    [df setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss Z"];
    NSDate *date = [df dateFromString:[[p objectForKey:@"pubDate"] objectForKey:@"text"]];
    [df setDateFormat:@"dd MMMM yyyy"];

    //category:
    id cats = [p objectForKey:@"category"];
    NSString *category;
    if ([cats isKindOfClass:[NSArray class]]) {
        category = [[[p objectForKey:@"category"] objectAtIndex:0] objectForKey:@"text"];
    } else if ([cats isKindOfClass:[NSDictionary class]]) {
        category = [[p objectForKey:@"category"] objectForKey:@"text"];
    }

    cell.categoryLabel.text = [NSString stringWithFormat:@"%@ - %@",[df stringFromDate:date],category];
    
    
    
    //body
    NSString *bodyString = [body rx_stringByReplacingMatchesOfPattern:@"<img(.*?)/>" withTemplate:@""];
    
    NSArray *bodyParts = [bodyString componentsSeparatedByString:@"[&#8230;]"];
    NSString *bodyPart= [bodyParts objectAtIndex:0];
    NSString *baseStyle =   @"<style>" \
                            "body{ font-family: 'Helvetica Neue'; font-weight: 300; font-size:14px; text-align: justify;}" \
                            "a{ color: #99E164; }" \
    ".readon { color:#4BB604; font-weight: 500}"
                            "</style>";
    
    NSString *compiledBody = [baseStyle stringByAppendingFormat:@"%@...<span class='readon'>%@</span>.",[bodyPart stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]],NSLocalizedString(@"Tap to read on", nil)];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[compiledBody dataUsingEncoding:NSUnicodeStringEncoding]
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                         documentAttributes:nil
                                                                      error:nil];
    
    
    cell.descriptionLabel.attributedText = attrStr;

    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *url = [[[posts objectAtIndex:indexPath.section] objectForKey:@"link"] objectForKey:@"text"],
            *title = [[[posts objectAtIndex:indexPath.section] objectForKey:@"title"] objectForKey:@"text"];
    
    webViewRoot = [[UIViewController alloc] init];
    webViewRoot.title = title;
    webViewRoot.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[NodiusDataSource sharedData] tableIconNegative:@"fa-times"]
                                                                                     style:UIBarButtonItemStyleDone
                                                                                    target:self
                                                                                    action:@selector(closeModal)];
    
    UIWebView *webView = [UIWebView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:url]]
                                         loaded:^(UIWebView *webView) {
                                             [MBProgressHUD hideHUDForView:webViewRoot.view animated:YES];
                                         }
                                         failed:^(UIWebView *webView, NSError *error) {
                                             NSLog(@"Failed loading %@", error);
                                         }];
    
    webViewRoot.view = webView;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:webViewRoot.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = NSLocalizedString(@"Loading article", nil);
    [hud showAnimated:YES];
    
    
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewRoot]
                                            animated:YES
                                          completion:nil];
}

-(void)closeModal {
    [webViewRoot dismissViewControllerAnimated:YES completion:nil];
}



-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}


@end
