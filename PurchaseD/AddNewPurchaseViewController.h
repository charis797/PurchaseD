//
//  AddNewPurchaseViewController.h
//  PurchaseD
//
//  Created by Office on 17/02/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddNewPurchaseViewController : UIViewController <UITextFieldDelegate>

- (void)updateCardDetails;
- (void)updateReceiverDetails;

@property (weak, nonatomic) IBOutlet UITextField *textFieldDate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDescription;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAmount;
@property (weak, nonatomic) IBOutlet UIButton *buttonCard;
@property (weak, nonatomic) IBOutlet UIButton *buttonReceiver;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDictionary *dictionaryCardDetails;
@property (strong, nonatomic) NSDictionary *dictionaryReceiverDetails;

@end
