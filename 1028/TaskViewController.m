//
//  TaskViewController.m
//  1028
//
//  Created by fg on 2017/5/26.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "TaskViewController.h"
#import "LoginViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "MemberRegisterData.h"
#import "MyManager.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "TaskCell.h"
#import "RegisterViewController.h"
#import "TaskClass.h"
#import "MBProgressHUD.h"
#import "TaskMsgCell.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"
#import "ActivityDetailViewController.h"
#import "ICSNavigationController.h"
#import "ActivityDetailClass.h"
#import "AttestationCheckViewController.h"
#import "NoDataCell.h"

@interface TaskViewController ()<MyManagerDelegate,ActivityDetailViewControllerDelegate>{
    MemberData *myMemberData;
    int Page;
    BOOL updateUserData;
}

@property(strong, nonatomic)LoginViewController *loginViewController;

@end

@implementation TaskViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (updateUserData) {
        updateUserData = NO;
        [self setDataWithoutTask];
    }
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    NSLog(@"float2  =  %f",self.memberLevel.intrinsicContentSize.width);
//    
//    self.memberLevelWidth.constant = self.memberLevel.intrinsicContentSize.width;
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    NSLog(@"float3  =  %f",self.memberLevel.intrinsicContentSize.width);
//    
//    self.memberLevelWidth.constant = self.memberLevel.intrinsicContentSize.width;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"开始进来了");
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        //并行执行的线程一
        for (int i = 0; i < 10; i++) {
            NSLog(@"11111111111");
        }
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        //并行执行的线程二
        for (int i = 0; i < 10; i++) {
            NSLog(@"22222222222");
        }
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        //汇总结果
        for (int i = 0; i < 10; i++) {
            NSLog(@"33333333333");
        }
    });
    
    NSLog(@"结束了,....");

    
    [MBProgressHUD showHUDAddedTo:PublicAppDelegate.window.rootViewController.view animated:YES];

    updateUserData = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidChangeFromBeacon:) name:@"BeaconTaskDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidChangeFromQRCode:) name:@"QRCodeTaskDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDataDidChange:) name:@"UserDataDidChangeNotification" object:nil];


    _cellHeights = [[NSMutableDictionary alloc] init];
    Page = 1;
    [self initTableView];

    MyManager *manager = [MyManager shareManager];
    manager.myManagerDelegate = self;
    
    [self.memberLevel.layer setCornerRadius:15];
    [self.memberLevel.layer setBorderColor:self.memberLevel.textColor.CGColor];
    [self.memberLevel.layer setBorderWidth:1.0f];
    self.memberLevelWidth.constant = 80;
        
    if([[MyManager shareManager] memberData]){
        [self setData];
    }
    else{
        
        if([[MyManager shareManager] loadUserInfoFromKeyChaninWithKey:@"jwt"]) {
            
            NSDictionary *parameters = @{@"token":[[MyManager shareManager] loadUserFBTokenFromKeyChaninWithKey]};

            [[MyManager shareManager] requestWithMethod:POST WithPath:[ApiBuilder getLogin] WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
                
                [[MyManager shareManager] getUserDataWithJWT:nil WithComplete:^(BOOL status, int code) {
                    
                    if ([[dic objectForKey:@"code"] intValue] == 202) {
                        [MBProgressHUD hideHUDForView:PublicAppDelegate.window.rootViewController.view animated:YES];

                        AttestationCheckViewController *attestationCheckViewController = [[AttestationCheckViewController alloc] initWithNibName:@"AttestationCheckViewController" bundle:nil];
                        ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:attestationCheckViewController];
                        [self presentViewController:navi animated:YES completion:nil];
                    }
                    else{
                        if(status){
                            [self setData];
                        }
                        else{
                            //                    if(code == 103 || code == 102){
                            //                        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                            //                        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
                            //                        [self presentViewController:loginNavi animated:YES completion:nil];
                            //                    }
                            //                    if (code == 106) {
                            //                        self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                            //                        UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
                            //                        [self presentViewController:loginNavi animated:YES completion:nil];
                            //                    }
                        }

                    }
                    

                }];
                
                
            } WithFailurBlock:^(NSError *error, int statusCode) {
                //TODO:fb token error
                if (statusCode == 422) {
                    self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                    UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
                    [self presentViewController:loginNavi animated:YES completion:nil];
                }
            }];
        }
        else{
            self.loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *loginNavi = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
            [self presentViewController:loginNavi animated:YES completion:nil];
        }
    }
}

-(void)initTableView{
    self.taskTableView.dataSource = self;
    self.taskTableView.delegate = self;
    [self.taskTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.taskTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.taskTableView.estimatedRowHeight = 175;
    self.taskTableView.rowHeight = UITableViewAutomaticDimension;
    [self.taskTableView setContentInset:UIEdgeInsetsMake(90, 0, 0, 0)];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk"]];
    [self.taskTableView setBackgroundView:image];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.taskTableView addSubview:self.refreshControl];
    [self.taskTableView sendSubviewToBack:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadMemberPic{
    [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:myMemberData.avatar] placeholderImage:nil];
}

-(void)setData{
    
    myMemberData = [[MyManager shareManager] memberData];

    BOOL status = [[MyManager shareManager] loginStatus];
    
    if (status) {
        NSMutableAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可兌換點數：%@ 點",myMemberData.points]];
    
        UIFont *font = [UIFont systemFontOfSize:24.0f weight:5.0f];
        
        [pointString addAttribute:NSFontAttributeName value:font range:NSMakeRange(6, [myMemberData.points stringValue].length)];
        [pointString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(6,[myMemberData.points stringValue].length)];
        self.memberPoint.attributedText = pointString;
        
        self.memberName.text = myMemberData.user_name;
        
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
        
        switch ([myMemberData.titleKey intValue]) {
            case 1:
                imageAttachment.image = [UIImage imageNamed:@"iconBabe"];
                self.memberLevel.textColor = TITLE_KEY_ONE_COLOR;
                self.memberLevel.layer.borderColor = TITLE_KEY_ONE_COLOR.CGColor;

                break;
            case 2:
                imageAttachment.image = [UIImage imageNamed:@"iconGirl"];
                self.memberLevel.textColor = TITLE_KEY_TWO_COLOR;
                self.memberLevel.layer.borderColor = TITLE_KEY_TWO_COLOR.CGColor;
                break;
            case 3:
                imageAttachment.image = [UIImage imageNamed:@"iconLady"];
                self.memberLevel.textColor = TITLE_KEY_THREE_COLOR;
                self.memberLevel.layer.borderColor = TITLE_KEY_THREE_COLOR.CGColor;
                break;
            default:
                break;
        }
        CGFloat imageOffsetY = 0.0;
        imageAttachment.bounds = CGRectMake(-5, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@" "];
        [completeText appendAttributedString:attachmentString];
        NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:myMemberData.title];
        [completeText appendAttributedString:textAfterIcon];
        self.memberLevel.textAlignment=NSTextAlignmentCenter;
        self.memberLevel.attributedText=completeText;
        self.memberLevelWidth.constant = self.memberLevel.intrinsicContentSize.width+20;
        
        self.navigationItem.rightBarButtonItem.badgeValue = [myMemberData.notification stringValue];

        [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:myMemberData.avatar] placeholderImage:nil];
        
        UIImage *tempPic = nil;
        if ([myMemberData.gender intValue]== 1) {
            tempPic = [UIImage imageNamed:@"man"];
        }
        else{
            tempPic = [UIImage imageNamed:@"girl"];
        }
        [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:myMemberData.avatar] placeholderImage:tempPic];
        
        [self.memberLevel setHidden:NO];
        [self getTaskData];
        
    }
    else{
        NSString *tmpPoint = @"0";
        NSMutableAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可兌換點數：%@ 點",tmpPoint]];
        
        UIFont *font = [UIFont systemFontOfSize:24.0f weight:5.0f];
        
        [pointString addAttribute:NSFontAttributeName value:font range:NSMakeRange(6,tmpPoint.length)];
        [pointString addAttribute:NSForegroundColorAttributeName value:DEFAULT_COLOR range:NSMakeRange(6,tmpPoint.length)];
        [self.memberImageView setImage:[UIImage imageNamed:@"girl"]];
        self.memberName.text = @"訪客";
        self.memberPoint.attributedText = pointString;
        self.memberLevel.text = @"尚未登入";
        [self.memberLevel setHidden:YES];
        self.navigationItem.rightBarButtonItem.badgeValue = @"";
        
        [self getGuestData];

    }

}

-(void)setDataWithoutTask{
    myMemberData = [[MyManager shareManager] memberData];
    
    BOOL status = [[MyManager shareManager] loginStatus];
    
    if (status) {
        NSMutableAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可兌換點數：%@ 點",myMemberData.points]];
        
        UIFont *font = [UIFont systemFontOfSize:24.0f weight:5.0f];
        
        [pointString addAttribute:NSFontAttributeName value:font range:NSMakeRange(6, [myMemberData.points stringValue].length)];
        [pointString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(6,[myMemberData.points stringValue].length)];
        self.memberPoint.attributedText = pointString;
        
        self.memberName.text = myMemberData.user_name;
        
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
        
        switch ([myMemberData.titleKey intValue]) {
            case 1:
                imageAttachment.image = [UIImage imageNamed:@"iconBabe"];
                self.memberLevel.textColor = TITLE_KEY_ONE_COLOR;
                self.memberLevel.layer.borderColor = TITLE_KEY_ONE_COLOR.CGColor;
                
                break;
            case 2:
                imageAttachment.image = [UIImage imageNamed:@"iconGirl"];
                self.memberLevel.textColor = TITLE_KEY_TWO_COLOR;
                self.memberLevel.layer.borderColor = TITLE_KEY_TWO_COLOR.CGColor;
                break;
            case 3:
                imageAttachment.image = [UIImage imageNamed:@"iconLady"];
                self.memberLevel.textColor = TITLE_KEY_THREE_COLOR;
                self.memberLevel.layer.borderColor = TITLE_KEY_THREE_COLOR.CGColor;
                break;
            default:
                break;
        }
        CGFloat imageOffsetY = 0.0;
        imageAttachment.bounds = CGRectMake(-5, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@" "];
        [completeText appendAttributedString:attachmentString];
        NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:myMemberData.title];
        [completeText appendAttributedString:textAfterIcon];
        self.memberLevel.textAlignment=NSTextAlignmentCenter;
        self.memberLevel.attributedText=completeText;
        self.memberLevelWidth.constant = self.memberLevel.intrinsicContentSize.width+20;
        
        self.navigationItem.rightBarButtonItem.badgeValue = [myMemberData.notification stringValue];
        
        [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:myMemberData.avatar] placeholderImage:nil];
        
        UIImage *tempPic = nil;
        if ([myMemberData.gender intValue]== 1) {
            tempPic = [UIImage imageNamed:@"man"];
        }
        else{
            tempPic = [UIImage imageNamed:@"girl"];
        }
        [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:myMemberData.avatar] placeholderImage:tempPic];
        
        [self.memberLevel setHidden:NO];
        
    }
    else{
        NSString *tmpPoint = @"0";
        NSMutableAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可兌換點數：%@ 點",tmpPoint]];
        
        UIFont *font = [UIFont systemFontOfSize:24.0f weight:5.0f];
        
        [pointString addAttribute:NSFontAttributeName value:font range:NSMakeRange(6,tmpPoint.length)];
        [pointString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(6,tmpPoint.length)];
        [self.memberImageView setImage:[UIImage imageNamed:@"girl"]];
        self.memberName.text = @"訪客";
        self.memberPoint.attributedText = pointString;
        self.memberLevel.text = @"尚未登入";
        [self.memberLevel setHidden:YES];
        self.navigationItem.rightBarButtonItem.badgeValue = @"";
    }
}

-(void)getTaskData{
    
    [[MyManager shareManager] requestWithMethod:GET WithPath:[ApiBuilder getEventsFromTask] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        
        [self.activityArray removeAllObjects];
        self.activityArray = [TaskClass initWithArray:[dic objectForKey:@"items"]];

        [self.taskTableView reloadData];
        [self hideRefreshControl];
        [MBProgressHUD hideHUDForView:PublicAppDelegate.window.rootViewController.view animated:YES];
    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

-(void)getGuestData{
    
    [[MyManager shareManager] requestWithMethod:GET WithPath:[ApiBuilder getGuestEventsFromTask] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        
        [self.activityArray removeAllObjects];
        self.activityArray = [TaskClass initWithArray:[dic objectForKey:@"items"]];

        [self.taskTableView reloadData];
        [self hideRefreshControl];
        [MBProgressHUD hideHUDForView:PublicAppDelegate.window.rootViewController.view animated:YES];
    } WithFailurBlock:^(NSError *error, int statusCode) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *message = [serializedData objectForKey:@"message"];
    }];
}

-(void)hideRefreshControl{
    if(self.refreshControl.refreshing){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    }
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
        noDataCell.messageLabel.text = @"您已完成全部活動嘍";
        
        return cell;
    }
    else{
        TaskClass *taskClass = [self.activityArray objectAtIndex:indexPath.row];
        
        if ([taskClass.taskType intValue] == 1) {
            cellIdentifier = @"TaskCell";
        }
        else if([taskClass.taskType intValue] == 2){
            cellIdentifier = @"TaskMsgCell";
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil){
            if ([taskClass.taskType intValue] == 1) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil];
                
                cell = (TaskCell *)[nib objectAtIndex:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];        }
            else if([taskClass.taskType intValue] == 2){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TaskMsgCell" owner:self options:nil];
                
                cell = (TaskMsgCell *)[nib objectAtIndex:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
        }
        
        
        if ([taskClass.taskType intValue] == 1) {
            TaskCell *taskCell = (TaskCell *)cell;
            [taskCell.taskImageView sd_setImageWithURL:[NSURL URLWithString:taskClass.image]];
            taskCell.taskTitle.text = taskClass.title;
            
            if (taskClass.taskStatus == nil) {
                taskCell.taskStatus.text = @"";
            }
            else{
                taskCell.taskStatus.text = taskClass.taskStatusText;
                switch ([taskClass.taskStatus intValue]) {
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
                //            taskCell.taskStatus.text = [taskClass.taskCompleted boolValue] ? @"已完成":@"未完成" ;
                //            taskCell.taskStatus.textColor = [taskClass.taskCompleted boolValue] ? DEFAULT_GARY_COLOR:DEFAULT_COLOR;
            }
            
        }
        else if([taskClass.taskType intValue] == 2){
            TaskMsgCell *taskMsgCell = (TaskMsgCell *)cell;
            taskMsgCell.title.text = taskClass.title;
            taskMsgCell.content.text = taskClass.content;
            NSLog(@"[MyManager colorWithHexString:taskClass.backgroundColor] = %@",taskClass.backgroundColor);
            [taskMsgCell.taskMsgBGView setBackgroundColor:[MyManager colorWithHexString:taskClass.backgroundColor]];
        }
        
        //
        //    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        //    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        //    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        //    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        //    taskCell.taskImageView.backgroundColor = color;
        //    taskCell.taskTitle.text = @"小海馬活動";
        //    taskCell.taskStatus.text = @"未完成";
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL status = [[MyManager shareManager] loginStatus];
    TaskClass *taskClass = [self.activityArray objectAtIndex:indexPath.row];

    if (status) {
        if ([taskClass.taskType intValue] == 1) {
            TaskClass *tmp = [self.activityArray objectAtIndex:indexPath.row];
            ActivityDetailViewController *activityDetailViewController = [[ActivityDetailViewController alloc] initWithActivityTaskClass:tmp];
            activityDetailViewController.delegate = self;
            [self.navigationController pushViewController:activityDetailViewController animated:YES];
        }
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
    [self setData];
}

-(void)showVaildMessageWithTitle:(NSString *)title content:(NSString *)message{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    alertController.view.tintColor = DEFAULT_COLOR;
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - MyManagerDelegate

-(void)clickedLogOut{
    [self setData];
    MemberViewController *memberViewController = [[PublicAppDelegate.mainTabBarController.memberNavi viewControllers] firstObject];
    [memberViewController showLoginView];
}

#pragma mark - ActivityDeatilViewControllerDelegate

-(void)doRefreshTaskContent:(TaskClass *)taskClass{
    
    NSLog(@"activityArray = %@",_activityArray);
    
    NSInteger objIndex = [self.activityArray indexOfObject:taskClass];
    
    TaskClass *tak = [self.activityArray objectAtIndex:objIndex];
    NSLog(@"activityArray = %@",tak.taskStatus);
    
    NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
    
    [self.taskTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - BeaconTaskDidChangeNotification

-(void)dataDidChangeFromBeacon:(NSNotification *)notifi{

    TaskClass *notiTaskClass = (TaskClass *)notifi.object;
        
    for (TaskClass *tmp in self.activityArray) {
        if (tmp.taskid == notiTaskClass.taskid) {
            //更新自己
            tmp.taskStatus = notiTaskClass.taskStatus;
            
            if ([notiTaskClass.taskStatus intValue] == 2) {
                tmp.taskStatusText = @"已完成";
            }
            
            //更新自己的次頁
            long taskNaviCount = (unsigned long)[PublicAppDelegate.mainTabBarController.taskNavi.viewControllers count];

            UINavigationController *taskNavi = PublicAppDelegate.mainTabBarController.taskNavi;

            if(taskNaviCount == 2){
                //叫他更新
                if ([[taskNavi.viewControllers objectAtIndex:2-1] isKindOfClass:[ActivityDetailViewController class]]) {
                    ActivityDetailViewController *activityDetailViewController = (ActivityDetailViewController *)[taskNavi.viewControllers objectAtIndex:2-1];
                    if ([activityDetailViewController isViewLoaded]) {
                        activityDetailViewController.activityDetailClass.task_status = notiTaskClass.taskStatus;
                        if ([notiTaskClass.taskStatus intValue] == 2) {
                            activityDetailViewController.activityDetailClass.task_status_text = @"已經完成活動";
                            activityDetailViewController.activityButton.titleLabel.text = @"已經完成活動";
                        }
                    }
                }
            }
            
            //更新BeaconView
            long beaconNaviCount = (unsigned long)[PublicAppDelegate.mainTabBarController.beaconNavi.viewControllers count];
            
            UINavigationController *currentNavi = PublicAppDelegate.mainTabBarController.beaconNavi;
            
            if (beaconNaviCount == 1) {
                if ([currentNavi.viewControllers.firstObject isKindOfClass:[BeaconViewController class]]) {
                    BeaconViewController *beaconViewController = (BeaconViewController *)currentNavi.viewControllers.firstObject;
                    if ([beaconViewController isViewLoaded]) {
                        for (TaskClass *tmp in beaconViewController.activityArray) {
                            if (tmp.taskid == notiTaskClass.taskid) {
                                tmp.taskStatus = notiTaskClass.taskStatus;
            
                                if ([notiTaskClass.taskStatus intValue] == 2) {
                                    tmp.taskStatusText = @"已完成";
                                }
                                NSInteger objIndex = [beaconViewController.activityArray indexOfObject:tmp];
    
                                NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
            
                                [beaconViewController.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                                        
                                break;
                            }
                        }
                    }
                }
            }
            else if(beaconNaviCount == 2){
                //叫他更新
                if ([[currentNavi.viewControllers objectAtIndex:2-1] isKindOfClass:[ActivityDetailViewController class]]) {
                    ActivityDetailViewController *activityDetailViewController = (ActivityDetailViewController *)[currentNavi.viewControllers objectAtIndex:2-1];
                    if ([activityDetailViewController isViewLoaded]) {
                        activityDetailViewController.activityDetailClass.task_status = notiTaskClass.taskStatus;
                        if ([notiTaskClass.taskStatus intValue] == 2) {
                            activityDetailViewController.activityDetailClass.task_status_text = @"已經完成活動";
                            activityDetailViewController.activityButton.titleLabel.text = @"已經完成活動";
                        }
                    }
                }
            }
            
//            NSInteger objIndex = [activityArray indexOfObject:tmp];
//                
//            NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
//                
//            [self.taskTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                
            break;
        }
    }
}

#pragma mark - QRCodeTaskDidChangeNotification

-(void)dataDidChangeFromQRCode:(NSNotification *)notifi{
    TaskClass *notiTaskClass = (TaskClass *)notifi.object;
    
    for (TaskClass *tmp in self.activityArray) {
        if (tmp.taskid == notiTaskClass.taskid) {
            
            //更新自己
            tmp.taskStatus = notiTaskClass.taskStatus;
            
            if ([notiTaskClass.taskStatus intValue] == 2) {
                tmp.taskStatusText = @"已完成";
            }
            
            //更新自己的次頁
            long taskNaviCount = (unsigned long)[PublicAppDelegate.mainTabBarController.taskNavi.viewControllers count];
            
            UINavigationController *taskNavi = PublicAppDelegate.mainTabBarController.taskNavi;
            
            if(taskNaviCount == 2){
                //叫他更新
                if ([[taskNavi.viewControllers objectAtIndex:2-1] isKindOfClass:[ActivityDetailViewController class]]) {
                    ActivityDetailViewController *activityDetailViewController = (ActivityDetailViewController *)[taskNavi.viewControllers objectAtIndex:2-1];
                    if ([activityDetailViewController isViewLoaded]) {
                        activityDetailViewController.activityDetailClass.task_status = notiTaskClass.taskStatus;
                        if ([notiTaskClass.taskStatus intValue] == 2) {
                            activityDetailViewController.activityDetailClass.task_status_text = @"已經完成活動";
                            activityDetailViewController.activityButton.titleLabel.text = @"已經完成活動";
                        }
                    }
                }
            }
            
            //更新BarcodeView
            long barcodeNaviCount = (unsigned long)[PublicAppDelegate.mainTabBarController.barcodeNavi.viewControllers count];
            
            UINavigationController *currentNavi = PublicAppDelegate.mainTabBarController.barcodeNavi;
            
            if (barcodeNaviCount == 1) {
                if ([currentNavi.viewControllers.firstObject isKindOfClass:[BarcodeViewController class]]) {
                    BarcodeViewController *barcodeViewController = (BarcodeViewController *)currentNavi.viewControllers.firstObject;
                    if ([barcodeViewController isViewLoaded]) {
                        for (TaskClass *tmp in barcodeViewController.activityArray) {
                            if (tmp.taskid == notiTaskClass.taskid) {
                                tmp.taskStatus = notiTaskClass.taskStatus;
                                
                                if ([notiTaskClass.taskStatus intValue] == 2) {
                                    tmp.taskStatusText = @"已完成";
                                }
                                
                                NSInteger objIndex = [barcodeViewController.activityArray indexOfObject:tmp];
                                
                                NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
                                
                                [barcodeViewController.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
                                
                                break;
                            }
                        }
                    }
                }
            }
            else if(barcodeNaviCount == 2){
                //叫他更新
                if ([[currentNavi.viewControllers objectAtIndex:2-1] isKindOfClass:[ActivityDetailViewController class]]) {
                    ActivityDetailViewController *activityDetailViewController = (ActivityDetailViewController *)[currentNavi.viewControllers objectAtIndex:2-1];
                    if ([activityDetailViewController isViewLoaded]) {
                        activityDetailViewController.activityDetailClass.task_status = notiTaskClass.taskStatus;
                        if ([notiTaskClass.taskStatus intValue] == 2) {
                            activityDetailViewController.activityDetailClass.task_status_text = @"已經完成活動";
                            activityDetailViewController.activityButton.titleLabel.text = @"已經完成活動";
                        }
                    }
                }
            }
            
            //            NSInteger objIndex = [activityArray indexOfObject:tmp];
            //
            //            NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
            //
            //            [self.taskTableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
        }
    }
}

-(void)userDataDidChange:(NSNotification *)notifi{
    updateUserData =YES;
}


@end
