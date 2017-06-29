//
//  NotificationViewController.m
//  1028
//
//  Created by fg on 2017/6/26.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "NotificationViewController.h"
#import "MyManager.h"
#import "ApiBuilder.h"
#import "NotificationCell.h"
#import "NotificationDetailCell.h"
#import "NotificationClass.h"
#import "../Framework/MJRefresh/MJRefresh.h"

@interface NotificationViewController (){
    int Page;
    NSMutableArray *notificationArray;
}

@end

@implementation NotificationViewController

-(void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == NULL) {
        if ([self.delegate respondsToSelector:@selector(refreshUserData)]) {
            [self.delegate refreshUserData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Page = 1;
    [self initTableView];
    [self getNotificationList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    
    notificationArray = [[NSMutableArray alloc] init];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.estimatedRowHeight = 175;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk"]];
    [self.tableView setBackgroundView:image];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getNotificationList)];
    [footer setTitle:@"點擊或上拉載入更多…" forState:MJRefreshStateIdle];
    [footer setTitle:@"加載資料中…" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"資料加載完畢" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    
    _tableView.footer = footer;
    [_tableView.footer endRefreshing];
    
}

-(void)getNotificationList{
    [[MyManager shareManager] requestWithMethod:GET WithPath:[ApiBuilder getNotificationsPage:Page] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        
        NSArray *tmpNotificationArray = [dic objectForKey:@"items"];

        NSLog(@"notificationArray = %@",notificationArray);
        
        if ([tmpNotificationArray count] > 0) {
            [notificationArray addObjectsFromArray:[NotificationClass initWithArray:tmpNotificationArray]];
            Page++;
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];

        }
        else{
            [self.tableView.footer noticeNoMoreData];

        }
        
    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

-(void)updateNotificationStatus:(int)NotificationID{
    [[MyManager shareManager] requestWithMethod:PATCH WithPath:[ApiBuilder getUpdateNotificationByID:NotificationID] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        
    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [notificationArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NotificationClass *tmp = [notificationArray objectAtIndex:section];
    
    if (tmp.status) {
        return 2;
    }
    else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellIdentifier = @"";

    if (indexPath.row == 0) {
        cellIdentifier = @"NotificationCell";
    }
    else{
        cellIdentifier = @"NotificationDetailCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        if (indexPath.row == 0) {
            cell = (NotificationCell *)[nib objectAtIndex:0];
        }
        else{
            cell = (NotificationDetailCell *)[nib objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    NotificationClass *tmp = [notificationArray objectAtIndex:indexPath.section];

    if (indexPath.row == 0) {
        NotificationCell *notificationCell = (NotificationCell *)cell;
        notificationCell.messageTitleLabel.text = tmp.title;
        
        if (tmp.status) {
            notificationCell.comBinddShape.image = [UIImage imageNamed:@"combinedShape"];
        }
        else{
            notificationCell.comBinddShape.image = [UIImage imageNamed:@"upsidecombinedShape"];
        }
        
        if ([tmp.isRead boolValue]) {
            [notificationCell.readStatusLabel setHidden:YES];
        }
        else{
            [notificationCell.readStatusLabel setHidden:NO];
        }
    }
    else{
        NotificationDetailCell *notificationDetailCell = (NotificationDetailCell *)cell;
        notificationDetailCell.detailContentLabel.text = tmp.content;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        NotificationCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NotificationClass *tmp = [notificationArray objectAtIndex:indexPath.section];
        if(tmp.status){
            tmp.status = NO;
        }
        else{
            tmp.status = YES;
        }
        
        if (![tmp.isRead boolValue]) {
            [self updateNotificationStatus:[tmp.notificationID intValue]];
            tmp.isRead = [NSNumber numberWithInt:1];
        }
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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



@end
