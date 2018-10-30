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
#import <MBProgressHUD/MBProgressHUD.h>

@interface AcaiaScaleTableVC ()
@property BOOL isRefreshed;
@property NSTimer *timer;
//@property AcaiaManager *manager;
@end

@implementation AcaiaScaleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.isRefreshed = NO;
//    self.manager = [AcaiaManager sharedManager];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Scanning"];
    self.tableView.refreshControl = self.refreshControl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFinishScan:) name:AcaiaScaleDidFinishScan object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onConnect:) name:AcaiaScaleDidConnected object:nil];
    
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isRefreshed == NO) {
        self.isRefreshed = YES;
        [self.tableView.refreshControl beginRefreshing];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y-self.refreshControl.frame.size.height) animated:YES];
    }
    [[AcaiaManager sharedManager] startScan:5.0f];
    [self.tableView reloadData];
}

- (void)refresh:(UIRefreshControl *)refreshCtrl {
    [[AcaiaManager sharedManager] startScan:5.0f];
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

//    if ([AcaiaManager manager].connectedScale) {
//        AcaiaScale *scale = [AcaiaManager manager].connectedScale;
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AcaiaManager sharedManager].scaleList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScaleCell" forIndexPath:indexPath];
    AcaiaScale *scale = [AcaiaManager sharedManager].scaleList[indexPath.row];
    cell.textLabel.text = scale.name;
    cell.detailTextLabel.text = scale.uuid;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.timer  = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:NO];
    AcaiaScale *scale = [AcaiaManager sharedManager].scaleList[indexPath.row];
    [scale connect];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = [NSString stringWithFormat:@"Connecting to %@...", scale.name];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
