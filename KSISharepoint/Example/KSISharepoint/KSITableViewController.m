//
//  KSITableViewController.m
//  KSISharepoint
//
//  Created by Santi Fernández Muñoz on 23/10/14.
//  Copyright (c) 2014 Santi Fdez Muñoz. All rights reserved.
//
#import <KSISharepoint.h>

#import "KSITableViewController.h"

@interface KSITableViewController ()

@end

@implementation KSITableViewController

{
    NSString *site;
    NSString *user;
    NSString *password;
    
    NSArray *lists;
    KSISharepointSessionManager *manager;
    UIAlertController *alert;
}

#pragma mark - table view lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    site = [storage stringForKey:@"site"];
    user = [storage stringForKey:@"user"];
    password = [storage stringForKey:@"password"];

    alert = [UIAlertController alertControllerWithTitle:@"Sharepoint URL" message:@"URL for your Sharepoint Online site" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        site = ((UITextField *) alert.textFields.firstObject).text;
        user = ((UITextField *) [alert.textFields objectAtIndex:1]).text;
        password = ((UITextField *) alert.textFields.lastObject).text;
        
        [storage setObject:site forKey:@"site"];
        [storage setObject:user forKey:@"user"];
        [storage setObject:password forKey:@"password"];
        
        [storage synchronize];
        
        [self getData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"URL Sharepoint site", @"");
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Username", @"");
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = NSLocalizedString(@"Password", @"");
        textField.secureTextEntry = YES;
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (site == nil || [site isEqualToString:@""]) {
        [self presentViewController:alert animated:YES completion:nil];
    } else if (user == nil || [user isEqualToString:@""]) {
        [self presentViewController:alert animated:YES completion:nil];
    } else if (user == nil || [user isEqualToString:@""]) {
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self getData];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([lists objectAtIndex:indexPath.row]) {
        cell.textLabel.text = [lists objectAtIndex:indexPath.row];
    }

    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [manager fetchListByName:[lists objectAtIndex:indexPath.row] withBlock:^(KSISPList *list, NSError *error) {
        NSLog(@"content of the list %@: %@", [lists objectAtIndex:indexPath.row], list);
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Aux Methods

- (void) getData {
    
    manager = [[KSISharepointSessionManager sharedInstance] initWithBaseURL:[NSURL URLWithString:site]];
    [manager authenticateVersion:kAuthSharepointOffice365 withUser:user withPassword:password withSuccessBlock:^{
        NSLog(@"success");
        
        NSDictionary *newListAttributes = @{
                                            @"title": @"prueba",
                                            @"listDescription": @"Nueva lista de prueba creada desde codigo Obj-C",
                                            @"baseTemplate" : [NSNumber numberWithInt:kListTemplateContacts]
                                            };
        NSError *error;
        KSISPList *newList = [[KSISPList alloc] initWithDictionary:newListAttributes error:&error];
        if (error) {
            NSLog(@"Error parsing new list object: %@", error);
        }
        
        [manager createList:newList withBlock:^{
            NSLog(@"List created succesfully");
        } failure:^(NSError *error) {
            NSLog(@"Error creating list: %@", error);
        }];
        [manager fetchSitesWithBlock:^(NSArray *sites, NSError *error) {
            if (error) {
#ifdef DEBUG
                NSLog(@"ERROR: %@", error);
#endif
            }
        }];
        [manager fetchListsWithBlock:^(NSArray *spLists, NSError *error) {
            if (error) {
#ifdef DEBUG
                NSLog(@"ERROR: %@", error);
#endif
            }
            lists = [spLists valueForKeyPath:@"title"];
            [self.tableView reloadData];
        }];
    } andFailBlock:^(NSError *fail) {
#ifdef DEBUG
        NSLog(@"ERROR: %@", fail);
#endif
    }];

}

@end
