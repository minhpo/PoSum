//
//  ImportProgressViewController.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "ImportProgressViewController.h"

#import "ImportOperation.h"

#import "Food.h"
#import "FoodCategory.h"
#import "Exercise.h"

@interface ImportProgressViewController ()

@property float importFoodProgress;
@property float importFoodCategoryProgress;
@property float importExerciseProgress;

@property IBOutlet UIProgressView *progressIndicator;
@property (nonatomic, strong) NSOperationQueue* operationQueue;

@end

@implementation ImportProgressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self startImport];
}

- (void)startImport {
    self.progressIndicator.progress = 0;
    
    [self startImportingFoodData];
    [self startImportingFoodCategoryData];
    [self startImportingExerciseData];
}

- (void)startImportingFoodData {
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"foodStatic" ofType:@"json"];
    [self startImportForFileName:fileName
                        forClass:[Food class]
            withProgressCallback:^(float progress) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^() {
                    self.importFoodProgress = progress;
                    [self updateProgress];
                }];
            }];
}

- (void)startImportingFoodCategoryData {
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"categoriesStatic" ofType:@"json"];
    [self startImportForFileName:fileName
                        forClass:[FoodCategory class]
            withProgressCallback:^(float progress) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^() {
                    self.importFoodCategoryProgress = progress;
                    [self updateProgress];
                }];
            }];
}

- (void)startImportingExerciseData {
    NSString* fileName = [[NSBundle mainBundle] pathForResource:@"exercisesStatic" ofType:@"json"];
    [self startImportForFileName:fileName
                        forClass:[Exercise class]
            withProgressCallback:^(float progress) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^() {
                    self.importExerciseProgress = progress;
                    [self updateProgress];
                }];
            }];
}

- (void)startImportForFileName:(NSString*)fileName forClass:(Class)objectClass withProgressCallback:(void (^)(float))progressCallback {
    ImportOperation* operation = [[ImportOperation alloc] initWithFileName:fileName
                                                                  forClass:objectClass
                                                      withProgressCallback:^(float progress) {
                                                          if (progressCallback)
                                                              progressCallback(progress);
                                                      }];
    [self.operationQueue addOperation:operation];
}

- (void)updateProgress {
    float progress = (self.importFoodProgress + self.importFoodCategoryProgress + self.importExerciseProgress)/3;
    self.progressIndicator.progress = progress;
    
    if (progress < 1)
        return;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"finishedImport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
