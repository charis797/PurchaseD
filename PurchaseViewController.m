//
//  PurchaseViewController.m
//  PurchaseD
//
//  Created by Office on 17/02/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import "PurchaseViewController.h"
#import "TableViewCellPurchase.h"
#import "AddCardViewController.h"
#import <CoreData/CoreData.h>
#import "AddNewPurchaseViewController.h"
#import "CardViewController.h"
#import "ReceiverViewController.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface PurchaseViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewList;
@property (strong, nonatomic) NSMutableArray *arrayItems;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Name";
    // Do any additional setup after loading the view.
    self.arrayItems = [[NSMutableArray alloc] init];
    
    // Initialize the drive service & load existing credentials from the keychain if available
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addCard:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New purchase" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        UITextField *textFieldName = alert.textFields[0];
        UITextField *textFieldAmount = alert.textFields[0];
        [self savePurchase:textFieldName.text amount:textFieldAmount.text];
        
        [self.tableViewList reloadData];
        
    }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                       }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Description";
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Amount";
//            textField.secureTextEntry = YES;
        }];
        
        [alert addAction:saveAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - Customs method

- (void) savePurchase:(NSString *)name amount:(NSString *)amount {
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *person = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Purchases"
                               inManagedObjectContext:context];
    [person setValue:name forKey:@"purchasedescription"];
    [person setValue:[NSNumber numberWithFloat:amount.floatValue] forKey:@"amount"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dictionaryPurchaseDetails = self.arrayItems[indexPath.row];

    TableViewCellPurchase *tableViewCellPurchase = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellPurchase"];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Cards"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"card_identifier == %@", [dictionaryPurchaseDetails valueForKey:@"card_identifier"]];
    fetchRequest.predicate = predicate;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
    if (fetchedObjects
        && [fetchedObjects isKindOfClass:[NSArray class]]
        && fetchedObjects.count > 0) {
        NSManagedObject *object = fetchedObjects.lastObject;
        tableViewCellPurchase.labelCardName.text = [object valueForKey:@"name"];
    }
    else{
        tableViewCellPurchase.labelCardName.text = @"";
    }
    
    NSFetchRequest *fetchRequestPerson = [NSFetchRequest fetchRequestWithEntityName:@"Receiver"];
    NSPredicate *predicatePerson = [NSPredicate predicateWithFormat:@"person_identifier == %@", [dictionaryPurchaseDetails valueForKey:@"person_identifier"]];
    fetchRequestPerson.predicate = predicatePerson;
    NSArray *fetchedObjectsPerson = [context executeFetchRequest:fetchRequestPerson error:nil];
    if (fetchedObjects
        && [fetchedObjectsPerson isKindOfClass:[NSArray class]]
        && fetchedObjectsPerson.count > 0) {
        NSManagedObject *object = fetchedObjectsPerson.lastObject;
        NSString *personName = [object valueForKey:@"name"];
        tableViewCellPurchase.labelPerson.text = [NSString stringWithFormat:@"For %@", personName];
        
    }
    else{
        tableViewCellPurchase.labelPerson.text = @"";
    }
    tableViewCellPurchase.labelDescription.text = [dictionaryPurchaseDetails valueForKey:@"purchasedescription"];
    tableViewCellPurchase.labelAmount.text = [NSString stringWithFormat:@"%@", [dictionaryPurchaseDetails valueForKey:@"amount"]];    
    tableViewCellPurchase.labelDate.text = @"";
    NSDate *purchaseDate = [dictionaryPurchaseDetails valueForKey:@"date"];
    if (purchaseDate != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"d MMM yyyy";
        NSString *stringDate = [dateFormatter stringFromDate:purchaseDate];
        if (stringDate != nil) {
            tableViewCellPurchase.labelDate.text = stringDate;
        }
    }

    return tableViewCellPurchase;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Purchases"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    if(fetchedObjects
       && [fetchedObjects isKindOfClass:[NSArray class]]
       && fetchedObjects.count > 0) {
        [self.arrayItems removeAllObjects];
        [self.arrayItems addObjectsFromArray:fetchedObjects];
    }
    [self.tableViewList reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.arrayItems objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.arrayItems removeObjectAtIndex:indexPath.row];
        [self.tableViewList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"PurchaseD"];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *stringExportData = @"";
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Purchases"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    if(fetchedObjects
       && [fetchedObjects isKindOfClass:[NSArray class]]
       && fetchedObjects.count > 0) {
        stringExportData = [stringExportData stringByAppendingFormat:@"Description, Card, Amount, Person, Date \n"];

        
        for (NSDictionary *dictionaryPurchaseDetails in fetchedObjects) {
            stringExportData = [stringExportData stringByAppendingString:[dictionaryPurchaseDetails valueForKey:@"purchasedescription"]];
            stringExportData = [stringExportData stringByAppendingString:@","];
            
            NSManagedObjectContext *context = [appDelegate managedObjectContext];
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Cards"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"card_identifier == %@", [dictionaryPurchaseDetails valueForKey:@"card_identifier"]];
            fetchRequest.predicate = predicate;
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:nil];
            if (fetchedObjects
                && [fetchedObjects isKindOfClass:[NSArray class]]
                && fetchedObjects.count > 0) {
                NSManagedObject *object = fetchedObjects.lastObject;
                
                stringExportData = [stringExportData stringByAppendingFormat:@"%@,", [object valueForKey:@"name"]];
            }
            stringExportData = [stringExportData stringByAppendingFormat:@"%@,", [dictionaryPurchaseDetails valueForKey:@"amount"]];

            
            
            NSFetchRequest *fetchRequestPerson = [NSFetchRequest fetchRequestWithEntityName:@"Receiver"];
            NSPredicate *predicatePerson = [NSPredicate predicateWithFormat:@"person_identifier == %@", [dictionaryPurchaseDetails valueForKey:@"person_identifier"]];
            fetchRequestPerson.predicate = predicatePerson;
            NSArray *fetchedObjectsPerson = [context executeFetchRequest:fetchRequestPerson error:nil];
            if (fetchedObjects
                && [fetchedObjectsPerson isKindOfClass:[NSArray class]]
                && fetchedObjectsPerson.count > 0) {
                NSManagedObject *object = fetchedObjectsPerson.lastObject;
                
                stringExportData = [stringExportData stringByAppendingFormat:@"%@,", [object valueForKey:@"name"]];
                
                NSDate *purchaseDate = [dictionaryPurchaseDetails valueForKey:@"date"];
                if (purchaseDate != nil) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"d MMM yyyy";
                    NSString *stringDate = [dateFormatter stringFromDate:purchaseDate];
                    if (stringDate != nil) {
                        stringExportData = [stringExportData stringByAppendingFormat:@"%@,", stringDate];
                    }
                }
                
            }
            stringExportData = [stringExportData stringByAppendingString:@"\n"];
        }
        
    }
    NSData *myData = [stringExportData dataUsingEncoding:NSASCIIStringEncoding];
    [picker addAttachmentData:myData mimeType:@"Purchase" fileName:@"PurchaseD.csv"];
    
    // Fill out the email body text
    NSString *emailBody = @"My purchase is attached";
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)exportClicked:(id)sender {
    [self displayComposerSheet];
}

@end