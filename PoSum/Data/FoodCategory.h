//
//  FoodCategory.h
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FoodCategory : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * headcategoryid;
@property (nonatomic, retain) NSString * name_fi;
@property (nonatomic, retain) NSString * name_it;
@property (nonatomic, retain) NSString * name_pt;
@property (nonatomic, retain) NSString * name_no;
@property (nonatomic, retain) NSNumber * servingscategory;
@property (nonatomic, retain) NSNumber * name_pl;
@property (nonatomic, retain) NSNumber * name_da;
@property (nonatomic, retain) NSNumber * oid;
@property (nonatomic, retain) NSNumber * photo_version;
@property (nonatomic, retain) NSNumber * lastupdated;
@property (nonatomic, retain) NSString * name_nl;
@property (nonatomic, retain) NSString * name_fr;
@property (nonatomic, retain) NSString * name_ru;
@property (nonatomic, retain) NSString * name_sv;
@property (nonatomic, retain) NSString * name_es;
@property (nonatomic, retain) NSString * name_de;

@end
