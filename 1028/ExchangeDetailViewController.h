//
//  ExchangeDetailViewController.h
//  1028
//
//  Created by fg on 2017/6/23.
//  Copyright © 2017年 fg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *productImageView;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@property (strong, nonatomic) IBOutlet UILabel *productDescription;
@property (strong, nonatomic) IBOutlet UILabel *exchangePointsLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)btnClicked:(id)sender;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withProductID:(int)productID;
@end
