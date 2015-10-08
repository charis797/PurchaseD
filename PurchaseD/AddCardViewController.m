//
//  AddCardViewController.m
//  PurchaseD
//
//  Created by Office on 17/02/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import "AddCardViewController.h"
#import <CoreData/CoreData.h>

@interface AddCardViewController ()


@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Card";
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
    
    NSString *name = self.textFieldName.text;
    NSString *amount = self.textFieldNumber.text;
    
    if (name.length ==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter card name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    else if (amount.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter card name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSManagedObject *person = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Cards"
                               inManagedObjectContext:context];
    
    [person setValue:name forKey:@"name"];
    [person setValue:[NSNumber numberWithFloat:amount.floatValue] forKey:@"number"];
    NSDate *today = [[NSDate alloc] init];
    [person setValue:[NSNumber numberWithDouble:today.timeIntervalSince1970] forKey:@"card_identifier"];
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
