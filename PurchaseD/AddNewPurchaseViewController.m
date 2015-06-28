//
//  AddNewPurchaseViewController.m
//  PurchaseD
//
//  Created by Office on 17/02/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import "AddNewPurchaseViewController.h"
#import <CoreData/CoreData.h>
#import "CardViewController.h"
#import "ReceiverViewController.h"

@interface AddNewPurchaseViewController ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation AddNewPurchaseViewController


double card_identifier;
double person_identifier;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Purchase";
    [self.datePicker removeFromSuperview];
    [self.textFieldDate setInputView:self.datePicker];
    NSDate *today = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSString *stringDate = [dateFormatter stringFromDate:today];
    self.textFieldDate.text = stringDate;

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ChooseCard"]) {
        CardViewController *cardViewController = [segue destinationViewController];
        cardViewController.addNewPurchaseViewController = self;
}
    if ([[segue identifier] isEqualToString:@"ChoosePerson"]) {
        ReceiverViewController *receiverViewController = [segue destinationViewController];
        receiverViewController.addNewPurchaseViewController = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCardDetails {
    [self.buttonCard setTitle:[self.dictionaryCardDetails valueForKey:@"name"] forState:UIControlStateNormal];
}

- (void)updateReceiverDetails {
    [self.buttonReceiver setTitle:[self.dictionaryReceiverDetails valueForKey:@"name"] forState:UIControlStateNormal];
}

#pragma mark - Customs method

- (IBAction)submitClicked:(id)sender {
    
    if ([self.dictionaryCardDetails valueForKey:@"card_identifier"] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please choose a card name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    if ([self.dictionaryReceiverDetails valueForKey:@"person_identifier"] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please choose a person name" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }

    
    NSString *stringDescription = self.textFieldDescription.text;
    if (stringDescription.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter description" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }
    
    NSString *stringAmount = self.textFieldAmount.text;
    if (stringAmount.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Please enter amount" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
        return;
    }


    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSManagedObject *person = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Purchases"
                                       inManagedObjectContext:context];
    [person setValue:[self.dictionaryCardDetails valueForKey:@"card_identifier"] forKey:@"card_identifier"];
    [person setValue:[self.dictionaryReceiverDetails valueForKey:@"person_identifier"] forKey:@"person_identifier"];
    [person setValue:self.textFieldDescription.text forKey:@"purchasedescription"];
    [person setValue:[NSNumber numberWithFloat:self.textFieldAmount.text.floatValue] forKey:@"amount"];
    [person setValue:self.datePicker.date forKey:@"date"];
    
    NSError *error;
     if (![context save:&error]) {
    NSLog(@"Whoops, couldn't save: %@", error);
    }
     else {
         [self.navigationController popViewControllerAnimated:YES];
     }
}


- (IBAction)resignKeyboard:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.textFieldDescription || textField == self.textFieldAmount) {
        self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);
    }
    else {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
}


- (IBAction)dateChanged:(id)sender {
    
    NSDate *today = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSString *stringDate = [dateFormatter stringFromDate:today];
    self.textFieldDate.text = stringDate;

}


//let today = self.datePicker.date
//let dateFormatter = NSDateFormatter()
//dateFormatter.dateFormat = "d MMM yyyy"
//let stringDate = dateFormatter.stringFromDate(today)
//self.textFieldDate.text = stringDate

@end
