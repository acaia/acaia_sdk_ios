//
//  AcaiaScaleTableVC.m
//  AcaiaExample
//
//  Created by Michael Wu on 2018/7/2.
//  Copyright © 2018 mikewu1211. All rights reserved.
//

#import "AcaiaScaleTableVC.h"
#import "AppDelegate.h"
#import <AcaiaSDK/AcaiaSDK.h>
#import <MBProgressHUD.h>

@interface AcaiaScaleTableVC ()
@property BOOL isRefreshed;
@property NSTimer *timer;
@end

@implementation AcaiaScaleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isRefreshed = NO;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Scanning"];
    self.tableView.refreshControl = self.refreshControl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onConnect:)
                                                 name:AcaiaScaleDidConnected
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onFinishScan:)
                                                 name:AcaiaScaleDidFinishScan
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scanListChanged:)
                                                 name:AcaiaScaleDeviceListChanged
                                               object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[AcaiaManager sharedManager] startScan:0.5];
}

- (void)refresh:(UIRefreshControl *)refreshCtrl {
    [[AcaiaManager sharedManager] startScan:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Acaia SDK Notification

- (void)onFinishScan:(NSNotification *)noti {
    [self.tableView.refreshControl endRefreshing];

    if ([AcaiaManager sharedManager].scaleList.count > 0) {
        [self.tableView reloadData];
    }
}

- (void) scanListChanged:(NSNotification *)noti {
    [self.tableView.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)onConnect:(NSNotification *)noti {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    [self.navigationController popViewControllerAnimated:YES];
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)onTimer:(NSTimer *)timer {
    [MBProgressHUD hideHUDForView:self.view animated:true];
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AcaiaManager sharedManager].scaleList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScaleCell"
                                                            forIndexPath:indexPath];
    
    AcaiaScale* scale = [AcaiaManager sharedManager].scaleList[indexPath.row];
    
    cell.textLabel.text = scale.name;
    cell.detailTextLabel.text = scale.modelName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.timer  = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                                   target:self
                                                 selector:@selector(onTimer:)
                                                 userInfo:nil
                                                  repeats:NO];
    AcaiaScale* scale = [AcaiaManager sharedManager].scaleList[indexPath.row];
    [scale connect];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSString stringWithFormat:@"Connecting to %@...", scale.name];
}

@end
