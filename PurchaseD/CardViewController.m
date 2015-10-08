//
//  CardViewController.m
//  PurchaseD
//
//  Created by Office on 17/02/15.
//  Copyright (c) 2015 Charis Communication. All rights reserved.
//

#import "CardViewController.h"
#import <CoreData/CoreData.h>

@interface CardViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewList;
@property (strong, nonatomic) NSMutableArray *arrayItems;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cards";
    // Do any additional setup after loading the view.
    self.arrayItems = [[NSMutableArray alloc] init];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionaryCardDetails = self.arrayItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [dictionaryCardDetails valueForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dictionaryCardDetails valueForKey:@"number"]];
    self.tableViewList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    return cell;
}

#pragma mark - UITableViewDelegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictionaryCardDetails = self.arrayItems[indexPath.row];
    self.addNewPurchaseViewController.dictionaryCardDetails = dictionaryCardDetails;
    [self.addNewPurchaseViewController updateCardDetails];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Cards"
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

@end