//
//  FoodDetailsViewController.m
//  PoSum
//
//  Created by Po Sam on 19/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import "FoodDetailsViewController.h"

#import "Food.h"

@interface FoodDetailsViewController ()

@property IBOutlet UILabel *titleLabel;

@property IBOutlet UILabel *nutritionValueLabel;

@property IBOutlet UILabel *proteinValueLabel;

@property IBOutlet UILabel *carbsValueLabel;
@property IBOutlet UILabel *fibersValueLabel;
@property IBOutlet UILabel *sugarsValueLabel;

@property IBOutlet UILabel *fatValueLabel;
@property IBOutlet UILabel *saturatedFatValueLabel;
@property IBOutlet UILabel *unsaturatedFatValueLabel;

@property IBOutlet UILabel *cholesterolValueLabel;
@property IBOutlet UILabel *sodiumValueLabel;
@property IBOutlet UILabel *potassiumValueLabel;

@property IBOutlet AsyncImageView *imageView;

@end

@implementation FoodDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = self.food.title;
    
    self.nutritionValueLabel.text = [NSString stringWithFormat:@"Nutrition information: %.f g/%@", [self.food.calories doubleValue], self.food.pcstext];
    
    self.proteinValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.protein doubleValue]];
    
    self.carbsValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.carbohydrates doubleValue]];
    self.fibersValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.fiber doubleValue]];
    self.sugarsValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.sugar doubleValue]];
    
    self.fatValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.fat doubleValue]];
    self.saturatedFatValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.saturatedfat doubleValue]];
    self.unsaturatedFatValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.unsaturatedfat doubleValue]];
    
    self.cholesterolValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.cholesterol doubleValue]];
    self.sodiumValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.sodium doubleValue]];
    self.potassiumValueLabel.text = [NSString stringWithFormat:@"%.f g", [self.food.potassium doubleValue]];
    
    self.imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:kFoodCategoryImageUrlTemplate, [self.food.categoryid integerValue]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
