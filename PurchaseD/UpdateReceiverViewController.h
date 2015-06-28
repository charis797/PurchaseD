//
//  UpdateReceiverViewController.h
//  PurchaseD
//
//  Created by Office on 04/03/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface UpdateReceiverViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (strong, nonatomic) NSManagedObject *receiverName;

@end
