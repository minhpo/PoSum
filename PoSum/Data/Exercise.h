//
//  Exercise.h
//  PoSum
//
//  Created by Po Sam on 17/05/14.
//  Copyright (c) 2014 Po Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exercise : NSManagedObject

@property (nonatomic, retain) NSString * name_pl;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * downloaded;
@property (nonatomic, retain) NSString * name_da;
@property (nonatomic, retain) NSNumber * photo_version;
@property (nonatomic, retain) NSNumber * custom;
@property (nonatomic, retain) NSString * name_pt;
@property (nonatomic, retain) NSNumber * oid;
@property (nonatomic, retain) NSString * name_no;
@property (nonatomic, retain) NSString * name_sv;
@property (nonatomic, retain) NSString * name_es;
@property (nonatomic, retain) NSNumber * lastupdated;
@property (nonatomic, retain) NSString * name_ru;
@property (nonatomic, retain) NSNumber * addedbyuser;
@property (nonatomic, retain) NSString * name_de;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * name_fr;
@property (nonatomic, retain) NSString * name_nl;
@property (nonatomic, retain) NSNumber * calories;
@property (nonatomic, retain) NSString * name_it;

@end
