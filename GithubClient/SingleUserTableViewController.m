//
//  SingleUserTableViewController.m
//  GithubClient
//
//  Created by Sergey Stavitckii on 12/1/14.
//  Copyright (c) 2014 Sergey Stavitckii. All rights reserved.
//

#import "SingleUserTableViewController.h"
#import <RestKit/RestKit.h>
#import "Repository.h"

@interface SingleUserTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property NSArray *repositories;

@end

@implementation SingleUserTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureRestKit];
    
    [self loadRepos];
}

//Вынести в один файлик!!! В UserList'e такой же метод есть!
- (void) configureRestKit
{
    NSURL *apiUrl = [NSURL URLWithString:@"https://api.github.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: apiUrl];
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient: client];
    
    RKObjectMapping *reposMapping = [RKObjectMapping mappingForClass:[Repository class]];
    [reposMapping addAttributeMappingsFromArray:@[@"name"]];
    
    RKResponseDescriptor *responceDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:reposMapping method:RKRequestMethodGET pathPattern:@"/users/{username}/repos" keyPath:@"" statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responceDescriptor];
}

- (void) loadRepos
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/repos" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         _repositories = mappingResult.array;
         [self.tableView reloadData];
     }
     
     
    failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"some error %@", error);
     }
     ];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleUserCell" forIndexPath:indexPath];
    
     Repository *rep = _repositories[indexPath.row];
     
     cell.textLabel.text = rep.name;
    
    // Configure the cell...
    
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
