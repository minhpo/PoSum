//
//  ExerciseViewController.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "ExerciseViewController.h"

#import "ExerciseDatabaseReader.h"
#import "Exercise.h"
#import "Exercise+LocalizedViewModel.h"

@interface ExerciseViewController ()

@property IBOutlet UITableView *tableView;

@property ExerciseDatabaseReader *databaseReader;

@end

@implementation ExerciseViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
        self.databaseReader = [ExerciseDatabaseReader new];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.databaseReader fetchResultForSearchTerm:nil];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Exercise *exercise = [self.databaseReader getObjectAtIndexPath:indexPath];

    cell.textLabel.text = exercise.localizedName;
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
