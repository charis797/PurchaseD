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

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLDrive.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSString *const kKeychainItemName = @"PurchaseD";
static NSString *const kClientID = @"76868206957-m0qlrlcev7j8gsiiqkg0913e9eg9fllm.apps.googleusercontent.com";
static NSString *const kClientSecret = @"10UtX9AAoLljMVaBqMREw-Fu";

@interface PurchaseViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableViewList;
@property (strong, nonatomic) NSMutableArray *arrayItems;
@property (nonatomic, retain) GTLServiceDrive *driveService;

@end

@implementation PurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Name";
    // Do any additional setup after loading the view.
    self.arrayItems = [[NSMutableArray alloc] init];
    
    // Initialize the drive service & load existing credentials from the keychain if available
    self.driveService = [[GTLServiceDrive alloc] init];
    self.driveService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
    clientID:kClientID
    clientSecret:kClientSecret];
    //www.oodlestechnologies.com/blogs/Google-Drive-integration-in-Native-iOS#sthash.N2mXirXR.dpuf
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
        dateFormatter.dateFormat = @"d MM yyyy";
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
-(void)fetchData {
//    UIDataDetectorTypeAll *dataFetch = [[UIDataDetectorTypeAll alloc] init];
}
#pragma mark - Viewdidapper methods
//- (void)viewDidAppear:(BOOL)animated
//{
//    // Always display the camera UI.
////    [self showCamera];
//}
//- (void)showData {
//    
//}
//- (void)showCamera
//{
//    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else
//    {
//        // In case we're running the iPhone simulator, fall back on the photo library instead.
//        cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//        {
//            [self showAlert:@"Error" message:@"Sorry, iPad Simulator not supported!"];
//            return;
//        }
//    };
//    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
//    cameraUI.allowsEditing = YES;
//    cameraUI.delegate = self;
//    [self presentModalViewController:cameraUI animated:YES];
//    
//    if (![self isAuthorized])
//    {
//        // Not yet authorized, request authorization and push the login UI onto the navigation stack.
//        [cameraUI pushViewController:[self createAuthController] animated:YES];
//    }
//}

// Handle selection of an image
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//    [self dismissModalViewControllerAnimated:YES];
//    [self uploadPhoto:image];
//}
//
//// Handle cancel from image picker/camera.
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissModalViewControllerAnimated:YES];
//}

// Helper to check if user is authorized
- (BOOL)isAuthorized
{
    return [((GTMOAuth2Authentication *)self.driveService.authorizer) canAuthorize];
}
//
//// Creates the auth controller for authorizing access to Google Drive.
- (GTMOAuth2ViewControllerTouch *)createAuthController
{
    GTMOAuth2ViewControllerTouch *authController;
    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeDriveFile
                                                                clientID:kClientID
                                                            clientSecret:kClientSecret
                                                        keychainItemName:kKeychainItemName
                                                                delegate:self
                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}

// Handle completion of the authorization process, and updates the Drive service
// with the new credentials.
- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error
{
    if (error != nil)
    {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.driveService.authorizer = nil;
    }
    else
    {
        self.driveService.authorizer = authResult;
    }
}

//
//// Uploads a photo to Google Drive
//- (void)uploadPhoto:(UIImage*)image
//{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"'Quickstart Uploaded File ('EEEE MMMM d, YYYY h:mm a, zzz')"];
//    
//    GTLDriveFile *file = [GTLDriveFile object];
//    file.title = [dateFormat stringFromDate:[NSDate date]];
//    file.descriptionProperty = @"Uploaded from the Google Drive iOS Quickstart";
//    file.mimeType = @"image/png";
//    
//    NSData *data = UIImagePNGRepresentation((UIImage *)image);
//    GTLUploadParameters *uploadParameters = [GTLUploadParameters uploadParametersWithData:data MIMEType:file.mimeType];
//    GTLQueryDrive *query = [GTLQueryDrive queryForFilesInsertWithObject:file
//                                                       uploadParameters:uploadParameters];
//    
//    UIAlertView *waitIndicator = [self showWaitIndicator:@"Uploading to Google Drive"];
//    
//    [self.driveService executeQuery:query
//                  completionHandler:^(GTLServiceTicket *ticket,
//                                      GTLDriveFile *insertedFile, NSError *error) {
//                      [waitIndicator dismissWithClickedButtonIndex:0 animated:YES];
//                      if (error == nil)
//                      {
//                          NSLog(@"File ID: %@", insertedFile.identifier);
//                          [self showAlert:@"Google Drive" message:@"File saved!"];
//                      }
//                      else
//                      {
//                          NSLog(@"An error occurred: %@", error);
//                          [self showAlert:@"Google Drive" message:@"Sorry, an error occurred!"];
//                      }
//                  }];
//}
//
//// Helper for showing a wait indicator in a popup
- (UIAlertView*)showWaitIndicator:(NSString *)title
{
    UIAlertView *progressAlert;
    progressAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:@"Please wait..."
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
    [progressAlert show];
    
    UIActivityIndicatorView *activityView;
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.center = CGPointMake(progressAlert.bounds.size.width / 2,
                                      progressAlert.bounds.size.height - 45);
    
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle: title
                                       message: message
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
    [alert show];
}
////www.oodlestechnologies.com/blogs/Google-Drive-integration-in-Native-iOS#sthash.N2mXirXR.dpuf

@end
