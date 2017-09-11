//
//  BeaconViewController.m
//  1028
//
//  Created by fg on 2017/4/17.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "BeaconViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "TaskCell.h"
#import "MyManager.h"
#import "TaskClass.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "MyManager.h"
#import "MemberRegisterData.h"
#import "UIBarButtonItem+Badge.h"
#import "ActivityDetailViewController.h"
#import "../Framework/MJRefresh/MJRefresh.h"
#import "ActivityDetailClass.h"
#import "NoDataCell.h"

#define DETECT_FREQUENCY 3

@interface BeaconViewController ()<CLLocationManagerDelegate>{
    int ferquency;
    NSMutableArray *beaconArray;
    int Page;
}

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation BeaconViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"BeaconViewDidLoad");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidChange:) name:@"BeaconTaskDidChangeNotification" object:nil];
    
    self.view.backgroundColor = [UIColor greenColor];
    ferquency = 0;
    Page = 1;
    beaconArray = [[NSMutableArray alloc] init];
//    [self initNavi];
//    [self setBeacon];
    [self initTableView];
    [self getActivity];

}

-(void)initNavi{
    
    // Build your regular UIBarButtonItem with Custom View
    UIImage *image = [UIImage imageNamed:@"iconMessage"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navrightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = navrightButton;
    
    // this is the key entry to change the badgeValue
    
    NSLog(@"bageValue = %@",[[[MyManager shareManager] memberData].notification stringValue]);
    self.navigationItem.rightBarButtonItem.badgeValue = [[[MyManager shareManager] memberData].notification stringValue];
    self.navigationItem.rightBarButtonItem.badgeOriginY = 13;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0f];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
    [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.navigationItem setTitleView:logoImage];
}

//-(void)setBeacon{
//    
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.allowsBackgroundLocationUpdates = NO;
//    self.locationManager.pausesLocationUpdatesAutomatically = NO;
//    self.locationManager.delegate = self;
//    
//    [self.locationManager requestWhenInUseAuthorization];
//    
//    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
//    
//    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"FashionGuide"];
//    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
//    
//}
//
//-(void)locationManager:(CLLocationManager*)manager didRangeBeacons:(NSArray*)beacons inRegion:(CLBeaconRegion*)region
//{
//    // Beacon found!
//    if (ferquency == DETECT_FREQUENCY) {
//        [self.locationManager stopRangingBeaconsInRegion: self.beaconRegion];
//        [self processBeaconData:beacons];
//    }
//    ferquency ++;
//
//}

//-(void)processBeaconData:(NSArray *)data{
//    
//    for (CLBeacon *obj in data) {
//        NSDictionary *beaconInfo = @{@"major":obj.major,@"minor":obj.minor,@"rssi":[NSNumber numberWithInteger:obj.rssi]};
//        [beaconArray addObject:beaconInfo];
//    }
//}

-(void)initTableView{
    
    self.activityArray = [[NSMutableArray alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.estimatedRowHeight = 175;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk"]];
    [self.tableView setBackgroundView:image];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getActivity)];
    [footer setTitle:@"點擊或上拉載入更多…" forState:MJRefreshStateIdle];
    [footer setTitle:@"加載資料中…" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"資料加載完畢" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    
    _tableView.footer = footer;
    [_tableView.footer endRefreshing];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.tableView sendSubviewToBack:self.refreshControl];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.activityArray count] == 0) {
        return 1;
    }
    else{
        return [self.activityArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier;
    
    if ([self.activityArray count] == 0) {
        cellIdentifier = @"NoDataCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (NoDataCell *)[nib objectAtIndex:0];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        NoDataCell *noDataCell = (NoDataCell *)cell;
        noDataCell.messageLabel.text = @"coming soon";
        
        return cell;
    }
    else{
        cellIdentifier = @"TaskCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil];
            
            cell = (TaskCell *)[nib objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
        
        TaskCell *taskCell = (TaskCell *)cell;
        if (self.activityArray != nil) {
            TaskClass *Mytask = [self.activityArray objectAtIndex:indexPath.row];
            taskCell.taskTitle.text = Mytask.title;
            if (Mytask.taskStatus == nil) {
                taskCell.taskStatus.text = @"";
            }
            else{
                taskCell.taskStatus.text = Mytask.taskStatusText;
                switch ([Mytask.taskStatus intValue]) {
                    case 1:
                        taskCell.taskStatus.textColor = DEFAULT_COLOR;
                        taskCell.taskTitle.textColor = [UIColor blackColor];
                        break;
                    case 2:
                        taskCell.taskStatus.textColor = DEFAULT_GARY_COLOR;
                        taskCell.taskTitle.textColor = DEFAULT_GARY_COLOR;
                        [taskCell.completeMark setHidden:NO];
                        break;
                    case 3:
                        taskCell.taskStatus.textColor = DEFAULT_GARY_COLOR;
                        taskCell.taskTitle.textColor = DEFAULT_GARY_COLOR;
                        break;
                    case 4:
                        taskCell.taskStatus.textColor = DEFAULT_COLOR;
                        taskCell.taskTitle.textColor = [UIColor blackColor];
                        
                        break;
                    default:
                        break;
                }
                //            taskCell.taskStatus.text = [Mytask.taskCompleted boolValue] ? @"已完成":@"未完成" ;
                //            taskCell.taskStatus.textColor = [Mytask.taskCompleted boolValue] ? DEFAULT_GARY_COLOR:DEFAULT_COLOR;
            }
            [taskCell.taskImageView sd_setImageWithURL:[NSURL URLWithString:Mytask.image]];
        }
        else{
            CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
            CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
            UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
            taskCell.taskImageView.backgroundColor = color;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BOOL status = [[MyManager shareManager] loginStatus];
    
    if (status) {
        TaskClass *tmp = [self.activityArray objectAtIndex:indexPath.row];
        ActivityDetailViewController *activityDetailViewController = [[ActivityDetailViewController alloc] initWithActivityTaskClass:tmp];
        activityDetailViewController.delegate = self;
        [self.navigationController pushViewController:activityDetailViewController animated:YES];
    }
    else{
        [self showVaildMessageWithTitle:@"尚未登入" content:@"Girls~要登入成為會員才能參與時尚任務噢！"];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    NSNumber *height = self.cellHeights[key];
    
    if (height) {
        return [height doubleValue];
    }
    
    return tableView.estimatedRowHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *key = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    
    if([self.cellHeights[key]doubleValue] != cell.frame.size.height){
        self.cellHeights[key] = @(cell.frame.size.height);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(self.refreshControl.isRefreshing){
        [self refresh];
    }
}

-(void)refresh{
    //設定重來
    [self.activityArray removeAllObjects];
    [self refreshActivityData];
}

-(void)refreshActivityData{
    //設定重來
    Page = 1;
    [self.activityArray removeAllObjects];
    
    [self getActivity];
}

-(void)hideRefreshControl{
    if(self.refreshControl.refreshing){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    }
}

-(void)getActivity{
    
    BOOL status = [[MyManager shareManager] loginStatus];
    
    NSString *requestStr = @"";
    if (status) {
        requestStr = [ApiBuilder getEventsFromBeaconPage:Page];
    }
    else{
        requestStr = [ApiBuilder getGuestEventsFromBeaconPage:Page];
    }
    

    [[MyManager shareManager] addJWT];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[MyManager shareManager] requestWithMethod:GET WithPath:requestStr WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"dic = %@",dic);
        
        NSArray *tmpActivityArray = [dic objectForKey:@"items"];
        
        if ([tmpActivityArray count] > 0) {
            [self.activityArray addObjectsFromArray:[TaskClass initWithArray:tmpActivityArray]];
            Page++;
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
        }
        else{
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self hideRefreshControl];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } WithFailurBlock:^(NSError *error, int statusCode) {
        NSLog(@"error = %@",error);
    }];

}



-(void)showVaildMessageWithTitle:(NSString *)title content:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = DEFAULT_COLOR;
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doRefreshTaskContent:(TaskClass *)taskClass{
    
    NSInteger objIndex = [self.activityArray indexOfObject:taskClass];
    
    TaskClass *tak = [self.activityArray objectAtIndex:objIndex];
    NSLog(@"activityArray = %@",tak.taskStatus);
    
    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
    
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)dataDidChange:(NSNotification *)notifi{

    TaskClass *notiTaskClass = (TaskClass *)notifi.object;
        
    for (TaskClass *tmp in self.activityArray) {
        if (tmp.taskid == notiTaskClass.taskid) {
            tmp.taskStatus = notiTaskClass.taskStatus;
            
            if ([notiTaskClass.taskStatus intValue] == 2) {
                tmp.taskStatusText = @"已完成";
            }
            
            //更新TaskView
            long taskNaviCount = (unsigned long)[PublicAppDelegate.mainTabBarController.taskNavi.viewControllers count];
            
            UINavigationController *currentNavi = PublicAppDelegate.mainTabBarController.taskNavi;
            
            if (taskNaviCount == 1) {
                if ([currentNavi.viewControllers.firstObject isKindOfClass:[TaskViewController class]]) {
                    TaskViewController *taskViewController = (TaskViewController *)currentNavi.viewControllers.firstObject;
                    if ([taskViewController isViewLoaded]) {
                        
                        for (TaskClass *tmp in taskViewController.activityArray) {
                            if (tmp.taskid == notiTaskClass.taskid) {
                                tmp.taskStatus = notiTaskClass.taskStatus;
                                
                                if ([notiTaskClass.taskStatus intValue] == 2) {
                                    tmp.taskStatusText = @"已完成";
                                }
                                
                                NSInteger objIndex = [taskViewController.activityArray indexOfObject:tmp];
                                
                                NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
                                
                                [taskViewController.taskTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                                
                                break;
                            }
                        }
                    }
                    
                }
            }
            else if(taskNaviCount == 2){
                //叫他更新
                if ([[currentNavi.viewControllers objectAtIndex:2-1] isKindOfClass:[ActivityDetailViewController class]]) {
                    ActivityDetailViewController *activityDetailViewController = (ActivityDetailViewController *)[currentNavi.viewControllers objectAtIndex:2-1];
                    if ([activityDetailViewController isViewLoaded]) {
                        activityDetailViewController.activityDetailClass.task_status = notiTaskClass.taskStatus;
                        if ([notiTaskClass.taskStatus intValue] == 2) {
                            activityDetailViewController.activityDetailClass.task_status_text = @"已經完成活動";
                        }
                    }
                }
            }
            
//            NSInteger objIndex = [beaconArray indexOfObject:tmp];
//                
//            NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
//                
//            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                
            break;
        }
    }
}

@end
