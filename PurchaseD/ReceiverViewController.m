//
//  ReceiverViewController.m
//  PurchaseD
//
//  Created by Office on 17/02/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import "ReceiverViewController.h"
#import <CoreData/CoreData.h>

@interface ReceiverViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewList;
@property (strong, nonatomic) NSMutableArray *arrayItems;

@end

@implementation ReceiverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Persons";
    // Do any additional setup after loading the view.
    self.arrayItems = [[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"UpdateReceiver"]) {
        NSManagedObject *selectedReceiver = [self.arrayItems objectAtIndex:[[self.tableViewList indexPathForSelectedRow] row]];
        UpdateReceiverViewController *updateReceiverViewController = segue.destinationViewController;
        updateReceiverViewController.receiverName = selectedReceiver;
    }
}

#pragma mark - UITableViewDelegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionaryReceiverDetails = self.arrayItems[indexPath.row];
    self.addNewPurchaseViewController.dictionaryReceiverDetails = dictionaryReceiverDetails;
    [self.addNewPurchaseViewController updateReceiverDetails];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - UITableViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionaryReceiverDetails = self.arrayItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [dictionaryReceiverDetails valueForKey:@"name"];
    self.tableViewList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return cell;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Receiver"
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
            NSLog(@"Can't Delete! %@", error);
            return;
        }
        
        // Remove device from table view
        [self.arrayItems removeObjectAtIndex:indexPath.row];
        [self.tableViewList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
