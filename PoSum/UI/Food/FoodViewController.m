//
//  FoodViewController.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "FoodViewController.h"
#import "FoodDetailsViewController.h"

#import "FoodDatabaseReader.h"
#import "Food.h"

@interface FoodViewController ()

@property IBOutlet UITableView *tableView;

@property FoodDatabaseReader *databaseReader;

@end

@implementation FoodViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
        self.databaseReader = [FoodDatabaseReader new];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.databaseReader fetchResultForSearchTerm:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = TableViewCellTextFont;
        
        cell.detailTextLabel.font = TableViewCellDetailTextFont;
        cell.detailTextLabel.textColor = LifesumGreen;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Food *food = [self.databaseReader getObjectAtIndexPath:indexPath];
    
    cell.textLabel.text = food.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f kcal", [food.calories doubleValue]];
}

#pragma mark - UITableViewDelegate

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.databaseReader getSectionTitleAtSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Food *food = [self.databaseReader getObjectAtIndexPath:indexPath];
    FoodDetailsViewController *detailsViewController = [[FoodDetailsViewController alloc] initWithNibName:@"FoodDetailsView" bundle:nil];
    detailsViewController.food = food;
    
    [self presentViewController:detailsViewController animated:YES completion:nil];
}

#pragma mark - Search

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self.databaseReader fetchResultForSearchTerm:nil];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self.databaseReader fetchResultForSearchTerm:searchString];
    
    return YES;
}

@end
