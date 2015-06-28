//
//  ReceiverViewController.h
//  PurchaseD
//
//  Created by Office on 17/02/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewPurchaseViewController.h"
#import "AppDelegate.h"
#import "UpdateReceiverViewController.h"
@interface ReceiverViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UpdateReceiverViewController *updateReceiverViewController;
@property (strong, nonatomic) AddNewPurchaseViewController *addNewPurchaseViewController;

@end
