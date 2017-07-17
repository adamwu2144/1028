//
//  ActivityDetailViewController.m
//  FG
//
//  Created by fg on 2016/1/26.
//  Copyright © 2016年 FG. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "MyManager.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ApiBuilder.h"
#import "TaskClass.h"
#import "ActivityDetailClass.h"
#import "MCScannerViewController.h"
#import "MCBeaconViewController.h"
#import "ShakeViewController.h"
#import "ICSNavigationController.h"
#import "../Framework/AFNetworking/AFHTTPSessionManager.h"

#define SCROLL_TO_TOP_SHOW_DISTANCE 50

@interface ActivityDetailViewController ()<ShakeViewControllerDelegate,MCScannerViewControllerDelegate>{
    NSString *name;
    int myTask_id;
    TaskClass *myTaskClass;
    BOOL isRefreshParaentContent;
    
}

@end

@implementation ActivityDetailViewController

-(void)willMoveToParentViewController:(UIViewController *)parent{
    if (parent == NULL) {
        if ([self.delegate respondsToSelector:@selector(doRefreshTaskContent:)]) {
            NSLog(@"myTaskClass des = %@",myTaskClass.description);
            [self.delegate doRefreshTaskContent:myTaskClass];
        }
    }
}

-(id)initWithActivityTaskClass:(TaskClass *)taskClass{
    self = [super init];
    if (self) {
        NSLog(@"taskClass des = %@",taskClass.description);

        myTask_id = [taskClass.taskid intValue];
        name = taskClass.title;
        myTaskClass = taskClass;
        isRefreshParaentContent = NO;
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavi];
    [self initCustomerView];
    [self initData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
    
    if (CGRectGetMaxY(self.activityURLLabel.frame) > self.scrollView.frame.size.height) {
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + (CGRectGetMaxY(self.activityURLLabel.frame) - self.scrollView.frame.size.height));
        self.containerHight.constant = self.scrollView.contentSize.height;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavi{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    [titleLabel setTextColor:[UIColor colorWithRed:248.0/255.0 green:134.0/255.0 blue:134.0/255.0 alpha:1]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:name];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButtonItem];
}

-(void)initCustomerView{
    
//    self.activityButton.backgroundColor = [UIColor whiteColor];
    self.activityButton.layer.shadowColor =[UIColor blackColor].CGColor;
    self.activityButton.layer.shadowOffset = CGSizeMake(0, 4.0f);

    self.activityButton.layer.shadowOpacity = 0.4f;

    self.activityButton.layer.shadowRadius = 1.0f;
    self.activityButton.layer.masksToBounds = NO;
    self.activityButton.layer.cornerRadius =  self.activityButton.frame.size.height/2;
    self.activityButton.titleLabel.numberOfLines = 0;
    
//    [[self.activityButton layer] setBorderWidth:1.0f];
//    [[self.activityButton layer] setBorderColor:[AppDelegate colorWithHexString:@"FF8A82"].CGColor];
    [[self.activityButton layer] setBorderColor:[UIColor redColor].CGColor];

    [self.activityButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    self.buttonWidth.constant = self.buttonWidth.constant + 20;
    
}

-(void)initData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[MyManager shareManager] requestWithMethod:GET WithPath:[ApiBuilder getEventsContentFromID:myTask_id] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        
        self.activityDetailClass = [ActivityDetailClass initWithDictionary:[dic objectForKey:@"items"]];
        [self setData];
        
    } WithFailurBlock:^(NSError *error, int statusCode) {
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NSString *message = [serializedData objectForKey:@"message"];
    }];

}

-(void)setData{

    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:self.activityDetailClass.task_image] placeholderImage:nil options:SDWebImageTransformAnimatedImage];
    
//    self.activityImageViewheight.constant = self.activityImageView.intrinsicContentSize.height;
    
    NSLog(@"activityDetailClass.description = %@",self.activityDetailClass.task_description);
    
    [self.activityContentLabel setText:self.activityDetailClass.task_description];
    
    [self.activityButton setTitle:self.activityDetailClass.task_status_text forState:UIControlStateNormal];

//    if ([activityDetailClass.task_completed boolValue]) {
//        [self.activityButton setTitle:@"已參加活動" forState:UIControlStateNormal];
//    }
//    else{
//        [self.activityButton setTitle:@"請按我進入搖一搖畫面" forState:UIControlStateNormal];
//    }
    
    if (isRefreshParaentContent) {
        isRefreshParaentContent = NO;
//        // 首頁
//        myTaskClass.taskCompleted = activityDetailClass.task_completed;
//        
//        //如果tabbar在BeaconViewController第一頁，更新第一頁資料
//        
//        long beaconNaviCount = (unsigned long)[PublicAppDelegate.mainTabBarController.beaconNavi.viewControllers count];
//
//        UINavigationController *currentNavi = PublicAppDelegate.mainTabBarController.beaconNavi;
//        
//        if (beaconNaviCount == 1) {
//            
//            NSLog(@"[[currentNavi visibleViewController] isKindOfClass:[BeaconViewController class]] = %d",[currentNavi.viewControllers.firstObject isKindOfClass:[BeaconViewController class]]);
//            
//            if ([currentNavi.viewControllers.firstObject isKindOfClass:[BeaconViewController class]]) {
//                BeaconViewController *beaconViewController = (BeaconViewController *)currentNavi.viewControllers.firstObject;
//                if ([beaconViewController isViewLoaded]) {
//                    
//                    NSLog(@"beaconViewController.activityArray = %@",beaconViewController.activityArray);
//                    
//                    for (TaskClass *tmp in beaconViewController.activityArray) {
//                        if (tmp.taskid == myTaskClass.taskid) {
//                            tmp.taskCompleted = myTaskClass.taskCompleted;
//                            
//                            NSInteger objIndex = [beaconViewController.activityArray indexOfObject:tmp];
//                            
//                            NSArray *indexPathArray = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:objIndex inSection:0]];
//                            
//                            [beaconViewController.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
//                            
//                            break;
//                        }
//                    }
//                }
//                
//            }
//        }
//        else if(beaconNaviCount == 2){
//            
//        }
        
        //更新
        myTaskClass.taskStatus = self.activityDetailClass.task_status;

        if ([self.activityDetailClass.task_status intValue] == 2) {
            myTaskClass.taskStatusText = @"已完成";
        }
        
        if ([self.activityDetailClass.task_type intValue] == ActivityTypeForBeacon) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BeaconTaskDidChangeNotification" object:myTaskClass];

        }
        else if([self.activityDetailClass.task_type intValue] == ActivityTypeForQRCode){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QRCodeTaskDidChangeNotification" object:myTaskClass];
        }

        
    }
    
    [self modifyButtonFrame];
}

-(void)modifyButtonFrame{
    self.buttonWidth.constant = self.activityButton.titleLabel.intrinsicContentSize.width+20 > SCREEN_WIDTH?SCREEN_WIDTH:self.activityButton.titleLabel.intrinsicContentSize.width+20;
    NSLog(@"oioioioi = %f",self.activityButton.titleLabel.intrinsicContentSize.height);
    
    UIFont *fontText = [UIFont fontWithName:self.activityButton.titleLabel.font.fontName size:self.activityButton.titleLabel.font.pointSize];
    
    CGRect buttonWidth = [self.activityButton.titleLabel.text boundingRectWithSize:CGSizeMake(self.buttonWidth.constant, 0)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:fontText}
                                           context:nil];
    
    self.buttonHeight.constant = buttonWidth.size.height+10;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)handleBtnClick:(id)sender {

    if ([self.activityDetailClass.task_status intValue] == 2 || [self.activityDetailClass.task_status intValue] == 3 || [self.activityDetailClass.task_status intValue] == 4) {
        NSLog(@"%@",self.activityDetailClass.task_status_text);
        [self showVaildMessageWithTitle:@"提醒" content:self.activityDetailClass.task_status_text];
        return;
    }
    
    switch ([self.activityDetailClass.task_type intValue]) {
        case ActivityTypeForBeacon:{
//            MCBeaconViewController *mcBeaconViewController = [[MCBeaconViewController alloc] initWithNibName:@"MCBeaconViewController" bundle:nil];
            ShakeViewController *mcBeaconViewController = [[ShakeViewController alloc] initWithNibName:@"ShakeViewController" bundle:nil withTask:self.activityDetailClass withBeacon:YES];
            mcBeaconViewController.delegate = self;
            ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:mcBeaconViewController];
            [self presentViewController:navi animated:YES completion:^{
                
            }];
        }
            break;
        case ActivityTypeForQRCode:{
            MCScannerViewController *mcScannerViewController = [[MCScannerViewController alloc] initWithNibName:@"MCScannerViewController" bundle:nil];
            mcScannerViewController.delegate = self;
            ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:mcScannerViewController];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case ActivityTypeForUnBeacon:{
            ShakeViewController *mcBeaconViewController = [[ShakeViewController alloc] initWithNibName:@"ShakeViewController" bundle:nil withTask:self.activityDetailClass withBeacon:NO];
            mcBeaconViewController.delegate = self;
            ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:mcBeaconViewController];
            [self presentViewController:navi animated:YES completion:^{
                
            }];
        }
            break;
        case ActivityTypeForOpenURL:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.activityDetailClass.result_url]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat width = self.view.frame.size.width;// 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y; //偏移量
    
    NSLog(@":  %.2f", yOffset);
    
    if (yOffset < 0) {
        NSLog(@"activityImageView = %@",_activityImageView);
        
        if (self.activityImageView.frame.size.height <= 0) {
            return;
        }
        CGFloat totalOffset = self.activityImageViewheight.constant + ABS(yOffset);
        CGFloat f = totalOffset / self.activityImageViewheight.constant; //缩放系数
        
        self.activityImageView.frame = CGRectMake(-(width * f - width) / 2, yOffset, width * f, totalOffset); //拉伸后的frame是同比例缩放
    }
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
//    if (yOffset > 0) {
//        CGFloat totalOffset = 150 - ABS(yOffset);
//        CGFloat f = totalOffset / 150;
//        
//        self.activityImageView.frame = CGRectMake(-(width * f - width) / 2, yOffset, width * f, totalOffset);
//    }

-(void)refreshMemberData{
    [[MyManager shareManager] getUserDataWithJWT:nil WithComplete:^(BOOL status, int statusCode) {
        
    }];
}

#pragma mark - ShakeViewControllerDelegate

-(void)doRefreshContent{
    isRefreshParaentContent = YES;
    [self initData];
    [self refreshMemberData];
}

#pragma mark - MCScannerViewControllerDelegate

-(void)doRefreshContentFromQRCode{
    isRefreshParaentContent = YES;
    [self initData];
    [self refreshMemberData];
}
@end
