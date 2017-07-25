//
//  GiftDetailViewController.m
//  1028
//
//  Created by fg on 2017/6/2.
//  Copyright © 2017年 fg. All rights reserved.
//

#import "GiftDetailViewController.h"
#import "MainTabBarController.h"
#import "MyManager.h"
#import "MemberRegisterData.h"
#import "../Framework/SDWebImage/UIImageView+WebCache.h"
#import "MyWebViewController.h"
#import "GiftRceiptCell.h"
#import "GiftRceiptClass.h"
#import "../Framework/MJRefresh/MJRefresh.h"
#import "MBProgressHUD.h"
#import "ExchangeViewController.h"

@interface GiftDetailViewController (){
    MemberData *myMemberData;
    MyWebViewController *myWebViewController;
    NSMutableArray *rceiotArray;
    int Page;
    NSString *requestURL;
    int previousClicked;
    BOOL updateUserData;
}

@end

@implementation GiftDetailViewController{
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UserDataDidChangeNotification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.navigationItem.titleView){
        UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_s"]];
        [logoImage setFrame:CGRectMake(0, 0, 120, 33)];
        logoImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.navigationItem setTitleView:logoImage];
    }
    
    if (updateUserData) {
        updateUserData = NO;
        [self btnsetDefault];
        [self getRceiptList];
        [self setData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Page = 1;
    previousClicked = 1;
    updateUserData = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDataDidChange:) name:@"UserDataDidChangeNotification" object:nil];

    [self initTableView];
    [self initCusBtn];
    [self getRceiptList];
    [self setData];
    
    [self.webView setRequestWithURL:[ApiBuilder getPointsExchangeRules]];
    
}

-(void)initCusBtn{
    [self.pointsDetail.layer setCornerRadius:15.0f];
    
    [self.pointsExchange.layer setCornerRadius:15.0f];
    [self.pointsExchange.layer setBorderColor:DEFAULT_COLOR.CGColor];
    [self.pointsExchange.layer setBorderWidth:1.0f];
    
    [self.pointsRules.layer setCornerRadius:15.0f];
    [self.pointsRules.layer setBorderColor:DEFAULT_COLOR.CGColor];
    [self.pointsRules.layer setBorderWidth:1.0f];
}

-(void)initTableView{

    rceiotArray = [[NSMutableArray alloc] init];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.estimatedRowHeight = 170;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bk"]];
    [self.tableView setBackgroundView:image];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getRceiptList)];
    [footer setTitle:@"點擊或上拉載入更多…" forState:MJRefreshStateIdle];
    [footer setTitle:@"加載資料中…" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"資料加載完畢" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    
    _tableView.footer = footer;
    [_tableView.footer endRefreshing];
}

-(void)getRceiptList{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    switch (previousClicked) {
        case 1:
            requestURL = [ApiBuilder getGiftRceiptInComingPage:Page];
            break;
        case 2:
            requestURL = [ApiBuilder getGiftRceiptOutGoingPage:Page];
            break;
        default:
            break;
    }
    
    [[MyManager shareManager] requestWithMethod:GET WithPath:requestURL WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *array = [dic objectForKey:@"items"];
        
        if ([array count] > 0) {
            [rceiotArray addObjectsFromArray:[GiftRceiptClass initWithArray:array]];
            Page++;
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
        }
        else{
            [self.tableView reloadData];
            [self.tableView.footer noticeNoMoreData];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } WithFailurBlock:^(NSError *error, int statusCode) {
        
    }];
}

-(void)setData{
    
    myMemberData = [[MyManager shareManager] memberData];
    
    if (myMemberData) {
        NSMutableAttributedString *pointString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"可兌換點數：%@",myMemberData.points]];
        
        UIFont *font = [UIFont systemFontOfSize:24.0f weight:5.0f];
        
        [pointString addAttribute:NSFontAttributeName value:font range:NSMakeRange(6, [myMemberData.points stringValue].length)];
        [pointString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(6,[myMemberData.points stringValue].length)];
        self.memberPoint.attributedText = pointString;
        
        self.memberLevel.text = myMemberData.title;
        
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
        UIColor *textColor = nil;
        switch ([myMemberData.titleKey intValue]) {
            case 1:
                imageAttachment.image = [UIImage imageNamed:@"iconBabe"];
                self.memberLevel.textColor = TITLE_KEY_ONE_COLOR;
                textColor = TITLE_KEY_ONE_COLOR;
                break;
            case 2:
                imageAttachment.image = [UIImage imageNamed:@"iconGirl"];
                self.memberLevel.textColor = TITLE_KEY_TWO_COLOR;
                textColor = TITLE_KEY_TWO_COLOR;
                break;
            case 3:
                imageAttachment.image = [UIImage imageNamed:@"iconLady"];
                self.memberLevel.textColor = TITLE_KEY_THREE_COLOR;
                textColor = TITLE_KEY_THREE_COLOR;
                break;
            default:
                break;
        }
        CGFloat imageOffsetY = 0.0;
        imageAttachment.bounds = CGRectMake(-5, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@" "];
        [completeText appendAttributedString:attachmentString];
        NSMutableAttributedString *levelString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"特務級數：%@",myMemberData.level_points]];
//        UIFont *levelfont = [UIFont systemFontOfSize:24.0f weight:0.0f];
//        [levelString addAttribute:NSFontAttributeName value:levelfont range:NSMakeRange(5, [myMemberData.level_points stringValue].length)];
//        [levelString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(5,[myMemberData.level_points stringValue].length)];

        NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[[UIFont systemFontOfSize:24.0f weight:0.0f], textColor]
                                                         forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
        [levelString addAttributes:dict range:NSMakeRange(5, [myMemberData.level_points stringValue].length)];
        [levelString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0,5)];

        [completeText appendAttributedString:levelString];
        self.memberTotalScroe.textAlignment=NSTextAlignmentLeft;
        self.memberTotalScroe.attributedText=completeText;
//        self.memberTotalScroe.text = [NSString stringWithFormat:@"特務級數：%@",myMemberData.level_points];
        
        UIImage *tempPic = nil;
        if ([myMemberData.gender intValue]== 1) {
            tempPic = [UIImage imageNamed:@"man"];
        }
        else{
            tempPic = [UIImage imageNamed:@"girl"];
        }
        
        [self.memberImageView sd_setImageWithURL:[NSURL URLWithString:myMemberData.avatar] placeholderImage:tempPic];
        
        [self.memberUsePointBtn.layer setCornerRadius:20];
        [self.memberUsePointBtn.layer setBorderColor:DEFAULT_COLOR.CGColor];
        [self.memberUsePointBtn.layer setBorderWidth:1.0f];
        [self.memberUsePointBtn setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)btnsetDefault{
    [self.pointsDetail.layer setBorderColor:DEFAULT_COLOR.CGColor];
    [self.pointsDetail.layer setBorderWidth:1.0f];
    [self.pointsDetail setBackgroundColor:[UIColor whiteColor]];
    [self.pointsDetail setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    
    [self.pointsExchange.layer setBorderColor:DEFAULT_COLOR.CGColor];
    [self.pointsExchange.layer setBorderWidth:1.0f];
    [self.pointsExchange setBackgroundColor:[UIColor whiteColor]];
    [self.pointsExchange setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    
    [self.pointsRules.layer setBorderColor:DEFAULT_COLOR.CGColor];
    [self.pointsRules.layer setBorderWidth:1.0f];
    [self.pointsRules setBackgroundColor:[UIColor whiteColor]];
    [self.pointsRules setTitleColor:DEFAULT_COLOR forState:UIControlStateNormal];
    
    [self.webView setHidden:YES];
    
    Page = 1;
    
    [rceiotArray removeAllObjects];
}

- (IBAction)btnClicked:(id)sender {
    
    UIButton *selectBtn = (UIButton *)sender;
    
    if (previousClicked == selectBtn.tag) {
        return;
    }
    
    [self btnsetDefault];
    [selectBtn setBackgroundColor:DEFAULT_COLOR];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([selectBtn.titleLabel.text isEqualToString:@"規則"]) {
        [self.webView setHidden:NO];
        previousClicked = 3;
    }
    else if([selectBtn.titleLabel.text isEqualToString:@"集點"]){
        previousClicked = 1;
        [self getRceiptList];
    }
    else{
        previousClicked = 2;
        [self getRceiptList];
    }
}

- (IBAction)membeUsePointBtnClicked:(id)sender {
    
    myWebViewController = [[MyWebViewController alloc] initWithNibName:@"MyWebViewController" bundle:nil withURL:[ApiBuilder getBounsExchange]];

//    ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:myWebViewController];
        
//    [self presentViewController:navi animated:YES completion:^{
//        [self setNaviCancelBtn:myWebViewController];
//        [myWebViewController setMyWebViewRequestURL:[ApiBuilder getBounsExchange]];
//    }];
    
    
    ExchangeViewController *exchangeViewController = [[ExchangeViewController alloc] initWithNibName:@"ExchangeViewController" bundle:nil];
    ICSNavigationController *navi = [[ICSNavigationController alloc] initWithRootViewController:exchangeViewController];
    [self presentViewController:navi animated:YES completion:^{
        [self setNaviCancelBtn:exchangeViewController];
    }];

    
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"[rceiotArray count] = %lu",(unsigned long)[rceiotArray count]);
    
    if ([rceiotArray count] == 0) {
        return 1;
    }
    else{
        return [rceiotArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"GiftRceiptCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GiftRceiptCell" owner:self options:nil];
        cell = (GiftRceiptCell *)[nib objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    GiftRceiptCell *giftRceiptCell = (GiftRceiptCell *)cell;

    if ([rceiotArray count] == 0) {
//        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
//        imageAttachment.image = [UIImage imageNamed:@"iconLoop_m.png"];
//        CGFloat imageOffsetY = 0.0;
//        imageAttachment.bounds = CGRectMake(-5, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
//        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
//        NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@"我的 "];
//        [completeText appendAttributedString:attachmentString];
//        NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:@" 點數明細"];
//        [completeText appendAttributedString:textAfterIcon];
//        giftRceiptCell.contentLabel.attributedText = completeText;
        giftRceiptCell.contentLabel.text = @"目前無資料";
    }
    else{
        GiftRceiptClass *giftRceiptClass = [rceiotArray objectAtIndex:indexPath.row];
        
        NSString *plusORminusPoint = nil;
        NSString *replaceStr = nil;
        NSLog(@"[[giftRceiptClass.rceipt_point stringValue]--%@",[giftRceiptClass.rceipt_point stringValue]);
        if ([[giftRceiptClass.rceipt_point stringValue] hasPrefix:@"-"]) {
            plusORminusPoint = @"扣除了";
            NSString *tmp = [[giftRceiptClass.rceipt_point stringValue] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            replaceStr = [NSString stringWithFormat:@"%@ %@。%@%@點",giftRceiptClass.created_at,giftRceiptClass.rceiptDescription,plusORminusPoint,tmp];
        }
        else{
            plusORminusPoint = @"獲得了";
            replaceStr = [NSString stringWithFormat:@"%@ %@。%@%@點",giftRceiptClass.created_at,giftRceiptClass.rceiptDescription,plusORminusPoint,giftRceiptClass.rceipt_point];

        }
        
        NSMutableAttributedString *rceiptString = [[NSMutableAttributedString alloc] initWithString:replaceStr];
        
        long Startlength = giftRceiptClass.created_at.length+giftRceiptClass.rceiptDescription.length+plusORminusPoint.length+2; //+2是1個空格,1個句號
        if ([[giftRceiptClass.rceipt_point stringValue] hasPrefix:@"-"]) {
            [rceiptString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(Startlength,[giftRceiptClass.rceipt_point stringValue].length-1)];
        }
        else{
            [rceiptString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:145.0/255.0 blue:146.0/255.0 alpha:1.0]range:NSMakeRange(Startlength,[giftRceiptClass.rceipt_point stringValue].length)];
        }

        
        giftRceiptCell.contentLabel.attributedText = rceiptString;
    }
    
    [giftRceiptCell.contentView setBackgroundColor:[UIColor whiteColor]];

    if(indexPath.row %2 == 1 ){
        [giftRceiptCell.contentView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0f]];
    }

    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //put your values, this is part of my code
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
    [view setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0f]];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.view.bounds.size.width, 20)];
    [lbl setFont:[UIFont systemFontOfSize:18]];
    [lbl setTextColor:[UIColor blackColor]];
    [view addSubview:lbl];
    
    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = [UIImage imageNamed:@"iconLoop_m.png"];
    CGFloat imageOffsetY = 0.0;
    imageAttachment.bounds = CGRectMake(0, imageOffsetY, imageAttachment.image.size.width, imageAttachment.image.size.height);
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString:@"我的 "];
    [completeText appendAttributedString:attachmentString];
    NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:@" 點數明細"];
    [completeText appendAttributedString:textAfterIcon];
    [lbl setAttributedText:completeText];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
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

#pragma mark UserDataDidChangeNotification

-(void)userDataDidChange:(NSNotification *)notificaion{
    updateUserData = YES;
    
}

@end
