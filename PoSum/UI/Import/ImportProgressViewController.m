//
//  ImportProgressViewController.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "ImportProgressViewController.h"

#import "DatabaseContentInitializer.h"

#import "Shared.h"

@interface ImportProgressViewController ()

@property IBOutlet UIProgressView *progressIndicator;

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
    self.progressIndicator.progress = 0;
    
    [self.databaseContentInitializer startImportingDataWithProgressCallback:^(float progress) {
        self.progressIndicator.progress = progress;
    }];
}

@end
