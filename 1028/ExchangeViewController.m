//
//  ExchangeViewController.m
//  1028
//
//  Created by fg on 2017/6/19.
//  Copyright © 2017年 fg. All rights reserved.
//

#define CELL_BTN_START_NUMBER 1000

#import "ExchangeViewController.h"
#import "../Framework/MJRefresh/MJRefresh.h"
#import "MBProgressHUD.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "ExchangeCell.h"
#import "ExchangeClass.h"
#import "MyManager.h"
#import "ApiBuilder.h"
#import "ExchangeDetailViewController.h";

@interface ExchangeViewController (){
    NSMutableArray *productArray;

}

@end

@implementation ExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    [self getProduct];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.estimatedRowHeight = 175;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk"]];
    [self.tableView setBackgroundView:image];
//
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getActivity)];
//    [footer setTitle:@"點擊或上拉載入更多…" forState:MJRefreshStateIdle];
//    [footer setTitle:@"加載資料中…" forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"資料加載完畢" forState:MJRefreshStateNoMoreData];
//    footer.stateLabel.textColor = [UIColor lightGrayColor];
//    
//    _tableView.footer = footer;
//    [_tableView.footer endRefreshing];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [productArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"ExchangeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExchangeCell" owner:self options:nil];
        
        cell = (ExchangeCell *)[nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];

    }
    
    ExchangeCell *exchangeCell = (ExchangeCell *)cell;
    
    if (productArray != nil) {
        ExchangeClass *exchangeClass = [productArray objectAtIndex:indexPath.row];
        exchangeCell.productTitle.text = exchangeClass.productTitle;
        
        NSMutableAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"兌換點數 %@",[exchangeClass.productPoints stringValue]]];

        UIFont *font = [UIFont systemFontOfSize:23];
        [pointString addAttribute:NSFontAttributeName value:font range:NSMakeRange(5,[exchangeClass.productPoints stringValue].length)];
        [pointString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(5,[exchangeClass.productPoints stringValue].length)];
        
        exchangeCell.productExchangePoints.attributedText = pointString;
        exchangeCell.exchangeButton.tag = CELL_BTN_START_NUMBER+indexPath.row;
        [exchangeCell.exchangeButton addTarget:self action:@selector(exchangeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [exchangeCell.productImageView sd_setImageWithURL:[NSURL URLWithString:exchangeClass.productImage] placeholderImage:nil];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL status = [[MyManager shareManager] loginStatus];
    
    if (status) {
//        TaskClass *tmp = [activityArray objectAtIndex:indexPath.row];
//        ActivityDetailViewController *activityDetailViewController = [[ActivityDetailViewController alloc] initWithActivityTaskID:[tmp.taskid intValue] TaskName:tmp.title];
//        [self.navigationController pushViewController:activityDetailViewController animated:YES];
    }
    else{
//        [self showVaildMessageWithTitle:@"尚未登入" content:@"請登入"];
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

-(void)getProduct{

    [[MyManager shareManager] addJWT];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[MyManager shareManager] requestWithMethod:GET WithPath:[ApiBuilder getProductList] WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *tmpProductArray = [dic objectForKey:@"items"];
        
        if ([tmpProductArray count] > 0) {
            productArray = [ExchangeClass initWithArray:tmpProductArray];
            [self.tableView reloadData];
        }
//        else{
//            [self.tableView.footer noticeNoMoreData];
//        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

- (void)exchangeBtnClicked:(id)sender{
    UIButton *clickBtn = (UIButton *)sender;
    long selectIndex = clickBtn.tag - CELL_BTN_START_NUMBER;
    NSLog(@"selectindex = %ld",selectIndex);
    
    ExchangeClass *exchangeClass = [productArray objectAtIndex:selectIndex];
    
    ExchangeDetailViewController *exchangeDetailViewController = [[ExchangeDetailViewController alloc] initWithNibName:@"ExchangeDetailViewController" bundle:nil withProductID:[exchangeClass.productid intValue]];
    [self.navigationController pushViewController:exchangeDetailViewController animated:YES];
    
}


@end
