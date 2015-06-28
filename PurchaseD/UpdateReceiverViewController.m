//
//  UpdateReceiverViewController.m
//  PurchaseD
//
//  Created by Office on 04/03/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import "UpdateReceiverViewController.h"
#import <CoreData/CoreData.h>

@interface UpdateReceiverViewController ()

@end

@implementation UpdateReceiverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.receiverName) {
        [self.textFieldName setText:[self.receiverName valueForKey:@"name"]];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submitClicked:(id)sender {
}

@end
