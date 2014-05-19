//
//  ImportProgressViewController.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "ImportProgressViewController.h"

#import "CircularProgressView.h"

#import "DatabaseContentInitializer.h"

@interface ImportProgressViewController ()

@property IBOutlet UILabel *progressLabel;
@property IBOutlet CircularProgressView *innerCircularView;
@property IBOutlet CircularProgressView *circularProgressView;

@property DatabaseContentInitializer *databaseContentInitializer;

@end

@implementation ImportProgressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        self.databaseContentInitializer = [DatabaseContentInitializer new];
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.progressLabel.text = [NSString stringWithFormat:@"0%%"];
    
    [self.innerCircularView setValue:100];
    [self.innerCircularView setDrawColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
    
    [self.circularProgressView setLineWidth:20];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startListeningToNotifications];
    
    [self startImport];
}

- (void)startListeningToNotifications {
    [[NSNotificationCenter defaultCenter] addObserverForName:kFinishedImportNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      [self stopListeningToNotifications];
                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                  }];
}

- (void)stopListeningToNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startImport {
    [self.circularProgressView setValue:0];
    self.progressLabel.text = [NSString stringWithFormat:@"0%%"];
    
    [self.databaseContentInitializer startImportingDataWithProgressCallback:^(float progress) {
        float progressInPercentage = progress*100;
        [self.circularProgressView setValue:progressInPercentage];
        
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", progressInPercentage];
    }];
    
    
}

@end
