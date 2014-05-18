//
//  CategoryViewController.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "CategoryViewController.h"
#import "ImportProgressViewController.h"

#import "FoodCategoryDatabaseReader.h"
#import "FoodCategory.h"
#import "FoodCategory+LocalizedViewModel.h"

@interface CategoryViewController ()

@property IBOutlet UITableView *tableView;

@property FoodCategoryDatabaseReader *databaseReader;

@end

@implementation CategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"finishedImport"]) {
        if (!self.databaseReader)
            self.databaseReader = [FoodCategoryDatabaseReader new];
        
        [self.databaseReader setSearchTerm:nil];
        [self.tableView reloadData];
    }
    else {
        ImportProgressViewController *importProgressViewController = [[ImportProgressViewController alloc] initWithNibName:@"ImportProgressView" bundle:nil];
        [self presentViewController:importProgressViewController animated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.databaseReader numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.databaseReader numberOfObjectsInSection:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FoodCategory *foodCategory = [self.databaseReader getObjectAtIndexPath:indexPath];
    cell.textLabel.text = foodCategory.localizedName;
}

#pragma mark - UITableViewDelegate

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.databaseReader getSectionTitleAtSection:section];
}

#pragma mark - Search

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self.databaseReader setSearchTerm:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self.databaseReader setSearchTerm:searchString];
    
    return YES;
}

@end
