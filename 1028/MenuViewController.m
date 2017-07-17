//
//  MenuViewController.m
//  1028
//
//  Created by fg on 2017/5/25.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "MenuViewController.h"
#import "BarcodeViewController.h"
#import "MainTabBarController.h"
#import "MenuMainCell.h"
#import "MenuDetailCell.h"
#import "MyWebViewController.h"
#import "FashionNewsViewController.h"
#import "ICSNavigationController.h"
#import "SocialLinkCell.h"
#import "ExchangeViewController.h"

@interface MenuViewController (){
    
    MyWebViewController *myWebViewController;
    FashionNewsViewController *fashionNewsViewController;
}

@property(nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previousRow = -1;
    // Do any additional setup after loading the view from its nib.
    NSArray *fashionDetail = [[NSArray alloc] initWithObjects:@"潮流搶先", nil];
    NSArray *productDetail = [[NSArray alloc] initWithObjects:@"產品資訊", nil];
    NSArray *officalShopDetail =[[NSArray alloc] initWithObjects:@"購物官網", nil];
//    NSArray *shopDetail = [[NSArray alloc] initWithObjects:@"1028商城", nil];
    NSArray *pointExChangeDetail = [[NSArray alloc] initWithObjects:@"點數兌換", nil];
//    NSArray *focusDetail = [[NSArray alloc] initWithObjects:@"關注我們",@"- Facebook",@"- Instagram",@"- Youtube",@"- 美  拍",@"- 微  博",@"- 優  酷", nil];
    NSArray *focusDetail = [[NSArray alloc] initWithObjects:@"關注我們",@"ALL", nil];

//    NSArray *mapDetail = [[NSArray alloc] initWithObjects:@"店點地圖", nil];
    NSArray *serviceDetail = [[NSArray alloc] initWithObjects:@"聯絡我們", nil];
    NSArray *logoutDetail = [[NSArray alloc] initWithObjects:@"登  出", nil];
    
//    self.titleArray = [[NSMutableArray alloc] initWithObjects:fashionDetail,productDetail,officalShopDetail,shopDetail,pointExChangeDetail,focusDetail,mapDetail,serviceDetail,logoutDetail, nil];
  
    self.titleArray = [[NSMutableArray alloc] initWithObjects:fashionDetail,productDetail,officalShopDetail,pointExChangeDetail,focusDetail,serviceDetail,logoutDetail, nil];
    
//    [self.menuTableView setSeparatorStyle:NO];
    [self.menuTableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.menuTableView.separatorColor = [UIColor whiteColor];
    self.menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.menuTableView setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f]];
    
    fashionNewsViewController = [[FashionNewsViewController alloc] initWithNibName:@"FashionNewsViewController" bundle:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configuring the view’s layout behavior

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // Even if this view controller hides the status bar, implementing this method is still needed to match the center view controller's
    // status bar style to avoid a flicker when the drawer is dragged and then left to open.
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && indexPath.row == 1) {
        return 120.0f;
    }
    return 60.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titleArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"indePath section= %ld, row = %ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.row ==0) {
        
        static NSString *menuCellIdentifier = @"MenuMainCell";
        MenuMainCell *cell = (MenuMainCell *)[tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
        if(!cell){
            [tableView registerNib:[UINib nibWithNibName:@"MenuMainCell" bundle:nil] forCellReuseIdentifier:menuCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
        }
        
        NSLog(@"text = %@",[[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
        
        switch (indexPath.section) {
            case 0:
                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"rock"]];
                break;
            case 1:
                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"iconMakeup"]];
                break;
            case 2:
                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"iconShoppingBag"]];
                break;
//            case 3:
//                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"iconHartplus"]];
//                break;
            case 3:
                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"iconLoop_s"]];
                break;
            case 4:
                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"iconShare"]];
                break;
//            case 6:
//                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"iconLocation"]];
//                break;
            case 5:
                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"iconContact"]];
                break;
            case 6:
                [cell.MenuMainCellImageView setImage:[UIImage imageNamed:@"iconLogout"]];
                break;
            default:
                break;
        }
        

        cell.MenuMainCellLabel.text = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (indexPath.section == 6) {
            cell.MenuMainCellLabel.textColor = [UIColor whiteColor];
            [cell.contentView setBackgroundColor:[UIColor blackColor]];
        }
        else{
            cell.MenuMainCellLabel.textColor = [UIColor blackColor];
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:254.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f]];
        }

        
        return cell;
    }
    else{
//        static NSString *menuDetailcellIdentifier = @"MenuDetailCell";
//        MenuDetailCell *cell = (MenuDetailCell *)[tableView dequeueReusableCellWithIdentifier:menuDetailcellIdentifier];
//        if(!cell){
//            [tableView registerNib:[UINib nibWithNibName:@"MenuDetailCell" bundle:nil] forCellReuseIdentifier:menuDetailcellIdentifier];
//            cell = [tableView dequeueReusableCellWithIdentifier:menuDetailcellIdentifier];
//        }
//        NSString *tmpStr = [[self.titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//        
//        cell.MenuDeatilCellLabel.text = tmpStr;
//        NSLog(@"text2 = %@",tmpStr);
        static NSString *menuDetailcellIdentifier = @"SocialLinkCell";
        SocialLinkCell *cell = (SocialLinkCell *)[tableView dequeueReusableCellWithIdentifier:menuDetailcellIdentifier];
        if(!cell){
            [tableView registerNib:[UINib nibWithNibName:@"SocialLinkCell" bundle:nil] forCellReuseIdentifier:menuDetailcellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:menuDetailcellIdentifier];
        }
        
        if (SCREEN_WIDTH == 414) {
            cell.edgeDistance.constant = 90;
        }
        else if(SCREEN_WIDTH == 375){
            cell.edgeDistance.constant = 50;
        }
        
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == self.previousRow) {
        // Close the drawer without no further actions on the center view controller
//        [self.drawer close];
//    }
//    else {
//                [self.drawer reloadCenterViewControllerUsingBlock:^(){
//        typeof(self) __weak weakSelf = self;
//
//        [self.drawer reloadCenterViewControllerUsingBlock:^{
//            MainTabBarController *tmp = (MainTabBarController *)weakSelf.drawer.centerViewController;
//            tmp.taskNavi.viewControllers.firstObject.view.backgroundColor = [UIColor redColor];
//        }];
        
        
        //            BarcodeViewController *viewController = [[BarcodeViewController alloc] initWithNibName:@"BarcodeViewController" bundle:nil];
        //
        //
        //            [PublicAppDelegate.mainTabBarController.mainNavi pushViewController:viewController animated:YES];
        
        //        }];
        
        //
        //        if(indexPath.row == 0){
        //            // Replace the current center view controller with a new one
        //            PublicAppDelegate.mainTabBarController.mainNavi.viewControllers.firstObject.view.backgroundColor = [UIColor blackColor];
        //        }
        //        else if(indexPath.row == 1){
        //            PublicAppDelegate.mainTabBarController.beaconNavi.viewControllers.firstObject.view.backgroundColor = [UIColor blueColor];
        //        }
        //        else{
        //            PublicAppDelegate.mainTabBarController.barcodeNavi.viewControllers.firstObject.view.backgroundColor = [UIColor purpleColor];
        //
        //        }
        
        switch (indexPath.section) {
            case 0:{
                ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:fashionNewsViewController];
                
                [self setNaviCancelBtn:fashionNewsViewController];
                
                [self presentViewController:navi animated:YES completion:^{
                    [self.drawer close];
                }];
            }

//                if (fashionNewsViewController) {
                
//                    [self.drawer close];
                    
//                    double delayInSeconds = 0.2;
//                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                    
//                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                        MainTabBarController *tmp = (MainTabBarController *)self.drawer.centerViewController;
//                        [tmp.taskNavi pushViewController:fashionNewsViewController animated:YES];
//                    });
                    
//                }
                break;
            case 1:{
                if (myWebViewController) {
                    
                    ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:myWebViewController];
                    
                    [self presentViewController:navi animated:YES completion:^{
                        [self.drawer close];
                        [myWebViewController setMyWebViewRequestURL:[ApiBuilder getGoodsList]];
                    }];    
                }
                else{
                    myWebViewController = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil withURL:[ApiBuilder getGoodsList]];
                    [self setNaviCancelBtn:myWebViewController];
                    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                }
            }
                break;
            case 2:
                if (myWebViewController) {
                    
                    ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:myWebViewController];
                    
                    [self presentViewController:navi animated:YES completion:^{
                        [self.drawer close];
                        [myWebViewController setMyWebViewRequestURL:[ApiBuilder getOfficalSite]];
                    }];
                }
                else{
                    myWebViewController = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil withURL:[ApiBuilder getOfficalSite]];
                    [self setNaviCancelBtn:myWebViewController];
                    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                }
                break;
            case 3:{
                if ([[MyManager shareManager] loginStatus]) {
//                    if (myWebViewController) {
//                        ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:myWebViewController];
//                        
//                        [self presentViewController:navi animated:YES completion:^{
//                            [self.drawer close];
//                            [myWebViewController setMyWebViewRequestURL:[ApiBuilder getBounsExchange]];
//                        }];
//                    }
//                    else{
//                        myWebViewController = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil withURL:[ApiBuilder getBounsExchange]];
//                        [self setNaviCancelBtn:myWebViewController];
//                        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
//                    }
                    ExchangeViewController *exchangeViewController = [[ExchangeViewController alloc] initWithNibName:@"ExchangeViewController" bundle:nil];
                    ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:exchangeViewController];
                    [self presentViewController:navi animated:YES completion:^{
                        [self.drawer close];
                        [self setNaviCancelBtn:exchangeViewController];
                    }];
                }
                else{
                    [self showVaildMessageWithTitle:@"尚未登入" content:@"請登入"];
                }

            }
                break;
            case 4:{
//                switch (indexPath.row) {
//                    case 1:
//                        [self openDaleDietrichDotCom:[ApiBuilder get1028FB]];
//                        break;
//                    case 2:
//                        [self openDaleDietrichDotCom:[ApiBuilder get1028IG]];
//                        break;
//                    case 3:
//                        [self openDaleDietrichDotCom:[ApiBuilder get1028YouTube]];
//                        break;
//                    case 4:
//                        [self openDaleDietrichDotCom:[ApiBuilder get1028MeiPai]];
//                        break;
//                    case 5:
//                        [self openDaleDietrichDotCom:[ApiBuilder get1028WeiBo]];
//                        break;
//                    case 6:
//                        [self openDaleDietrichDotCom:[ApiBuilder get1028YouKu]];
//                        break;
//                    default:
//                        break;
//                }
            }
                break;
            case 5:{
                if ([[MyManager shareManager] loginStatus]) {
                    if (myWebViewController) {
                        ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:myWebViewController];
                        
                        [self presentViewController:navi animated:YES completion:^{
                            [self.drawer close];
                            [myWebViewController setMyWebViewRequestURL:[ApiBuilder getConnect]];
                        }];
                    }
                    else{
                        myWebViewController = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil withURL:[ApiBuilder getConnect]];
                        [self setNaviCancelBtn:myWebViewController];
                        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                    }
                }
                else{
                    [self showVaildMessageWithTitle:@"尚未登入" content:@"請登入"];
                }

            }
                break;
            case 6:{
                [[MyManager shareManager] logOut];
                
            }
                break;
            default:
                break;
        }
        
//    }
//    self.previousRow = indexPath.row;
}

-(void)setNaviCancelBtn:(UIViewController *)viewController{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(0, 0, 35, 35)];
    [cancelBtn addTarget:self action:@selector(cancelHandler:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ic_arrow_white"] forState:UIControlStateNormal];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    [viewController.navigationItem setLeftBarButtonItems:@[negativeSpacer, cancelItem]];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
    [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [viewController.navigationItem setTitleView:logoImage];
}

-(void)cancelHandler:(UIButton *)sender
{
    
    [PublicAppDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)openDaleDietrichDotCom:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

@end
