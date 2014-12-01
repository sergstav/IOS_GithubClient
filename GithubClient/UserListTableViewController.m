//
//  UserListTableViewController.m
//  GithubClient
//
//  Created by Sergey Stavitckii on 12/1/14.
//  Copyright (c) 2014 Sergey Stavitckii. All rights reserved.
//

#import "UserListTableViewController.h"
#import <RestKit/RestKit.h>
#import "User.h"

@interface UserListTableViewController ()

@property NSArray *users;

@end

@implementation UserListTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureRestKit];
    
    [self loadUsers];
    
    UIRefreshControl *refreshControls = [[UIRefreshControl alloc] init];
    [refreshControls addTarget:self action: @selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl: refreshControls];
    
    [self.tableView addSubview:refreshControls];
    
}

- (void)configureRestKit
{
    NSURL *apiUrl = [NSURL URLWithString:@"https://api.github.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: apiUrl];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient: client];
    
    RKObjectMapping *usersMapping = [RKObjectMapping mappingForClass:[User class]];
    [usersMapping addAttributeMappingsFromArray:@[@"login"]];
    [usersMapping addAttributeMappingsFromArray:@[@"avatar_url"]];
    
    RKResponseDescriptor *responceDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:usersMapping method:RKRequestMethodGET pathPattern:@"/users" keyPath:@"" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responceDescriptor];
}

- (void)loadUsers
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/users" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         _users = mappingResult.array;
         [self.tableView reloadData];
     }
     
     
    failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"some error %@", error);
     }
     ];
}

- (void) refresh:(id) sender
{
    [self loadUsers];
    [sender endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_users count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    User *user = _users[indexPath.row];
//    cell.textLabel.text = user.login;
    
    UILabel *loginLabel = (UILabel*)[cell viewWithTag:101];
    loginLabel.text = user.login;
    
    NSURL *avatar_url = [NSURL URLWithString:user.avatar_url];
    [cell.imageView setImageWithURL:avatar_url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
