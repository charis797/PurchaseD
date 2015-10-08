//
//  AddReceiverViewController.m
//  PurchaseD
//
//  Created by Office on 17/02/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import "AddReceiverViewController.h"
#import <CoreData/CoreData.h>

@interface AddReceiverViewController ()

@end

@implementation AddReceiverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Person";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resignKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)submitClicked:(id)sender {
    
    if (self.textFieldName.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter the person" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];

    NSManagedObject *person = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Receiver"
                                       inManagedObjectContext:context];
    
    [person setValue:self.textFieldName.text forKey:@"name"];
    NSDate *today = [[NSDate alloc] init];
    [person setValue:[NSNumber numberWithDouble:today.timeIntervalSince1970] forKey:@"person_identifier"];

    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", error);
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
