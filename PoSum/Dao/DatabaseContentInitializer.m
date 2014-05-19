//
//  DatabaseContentInitializer.m
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "DatabaseContentInitializer.h"

#import "DatabaseContext.h"

#import "DatabaseImportOperation.h"

#import "Food.h"
#import "FoodCategory.h"
#import "Exercise.h"

@interface DatabaseContentInitializer ()

@property float importFoodProgress;
@property float importFoodCategoryProgress;
@property float importExerciseProgress;

@property (strong) ProgressCallback progressCallback;
@property (nonatomic, strong) NSOperationQueue* operationQueue;

@end

@implementation DatabaseContentInitializer

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.operationQueue = [NSOperationQueue new];
    }
    
    return self;
}

#pragma mark - Import data

- (void)startImportingDataWithProgressCallback:(ProgressCallback)progressCallback {
    self.progressCallback = progressCallback;
    
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
    DatabaseImportOperation* operation = [[DatabaseImportOperation alloc] initWithFileName:fileName
                                                                                  forClass:objectClass
                                                                      withProgressCallback:^(float progress) {
                                                                          if (progressCallback)
                                                                              progressCallback(progress);
                                                                      }];
    [self.operationQueue addOperation:operation];
}

- (void)updateProgress {
    float progress = (self.importFoodProgress + self.importFoodCategoryProgress + self.importExerciseProgress)/3;
    if (self.progressCallback)
        self.progressCallback(progress);
    
    if (progress < 1)
        return;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"finishedImport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishedImportNotification object:self];
}

@end
