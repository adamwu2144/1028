//
//  ICSColorsViewController.m
//
//  Created by Vito Modena
//
//  Copyright (c) 2014 ice cream studios s.r.l. - http://icecreamstudios.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "ICSColorsViewController.h"
#import "BarcodeViewController.h"
#import "MainTabBarController.h"
#import "MenuMainCell.h"
#import "MenuDetailCell.h"

static NSString * const kICSColorsViewControllerCellReuseId = @"kICSColorsViewControllerCellReuseId";



@interface ICSColorsViewController ()

@property(nonatomic, strong) NSArray *colors;
@property(nonatomic, assign) NSInteger previousRow;
@property(nonatomic, strong) NSMutableArray *titleArray;
@end



@implementation ICSColorsViewController

- (id)initWithColors:(NSArray *)colors
{
    NSParameterAssert(colors);
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _colors = colors;
    }
    return self;
}

#pragma mark - Managing the view

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *fashionDetail = [[NSArray alloc] initWithObjects:@"潮流搶先", nil];
    NSArray *productDetail = [[NSArray alloc] initWithObjects:@"產品資訊", nil];
    NSArray *officalShopDetail =[[NSArray alloc] initWithObjects:@"購物官網", nil];
    NSArray *shopDetail = [[NSArray alloc] initWithObjects:@"1028商城", nil];
    NSArray *pointExChangeDetail = [[NSArray alloc] initWithObjects:@"積點兌換", nil];
    NSArray *focusDetail = [[NSArray alloc] initWithObjects:@"關注我們",@"Facebook",@"Instagram",@"Youtube",@"美拍",@"微博",@"優酷", nil];
    NSArray *mapDetail = [[NSArray alloc] initWithObjects:@"店點地圖", nil];
    NSArray *serviceDetail = [[NSArray alloc] initWithObjects:@"聯絡我們", nil];
    NSArray *logoutDetail = [[NSArray alloc] initWithObjects:@"登出", nil];
    
    self.titleArray = [[NSMutableArray alloc] initWithObjects:fashionDetail,productDetail,officalShopDetail,shopDetail,pointExChangeDetail,focusDetail,mapDetail,serviceDetail,logoutDetail, nil];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kICSColorsViewControllerCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    NSLog(@"colorsViewController");
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
    return 43.0f;
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
        
        cell.MenuMainCellLabel.text = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor blueColor];
        
        return cell;
    }
    else{
        static NSString *menuDetailcellIdentifier = @"MenuDetailCell";
        MenuDetailCell *cell = (MenuDetailCell *)[tableView dequeueReusableCellWithIdentifier:menuDetailcellIdentifier];
        if(!cell){
            [tableView registerNib:[UINib nibWithNibName:@"MenuDetailCell" bundle:nil] forCellReuseIdentifier:menuDetailcellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:menuDetailcellIdentifier];
        }
        NSString *tmpStr = [[self.titleArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        cell.MenuDeatilCellLabel.text = tmpStr;
        NSLog(@"text2 = %@",tmpStr);
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.previousRow) {
        // Close the drawer without no further actions on the center view controller
        [self.drawer close];
    }
    else {
//        [self.drawer reloadCenterViewControllerUsingBlock:^(){
        typeof(self) __weak weakSelf = self;

            [self.drawer reloadCenterViewControllerUsingBlock:^{
                MainTabBarController *tmp = (MainTabBarController *)weakSelf.drawer.centerViewController;
                tmp.taskNavi.viewControllers.firstObject.view.backgroundColor = [UIColor redColor];
            }];
        
        
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

    }
    self.previousRow = indexPath.row;
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
