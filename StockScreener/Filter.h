//
//  Filter.h
//  StockScreener
//
//  Created by Joshua on 2018-11-22.
//  Copyright © 2018 FLO. All rights reserved.
//

#define EQUALS        0
#define LESSTHAN      1
#define GREATERTHAN   2
#define BETWEEN       3

@interface Filter : NSObject

@property (strong, nonatomic) NSString *filterName;
@property int selectedOperation;
@property (strong, nonatomic) NSString *comparingTo;
@property (strong, nonatomic) NSString *comparingToOther;

-(id)initWithTags:(NSInteger)filterTag filterPicked:(NSInteger)filterPicked;
-(void)parseFilterSelected:(NSString*) filterString;
-(BOOL)complysWith:(NSString*) dataIn;
-(BOOL)isEqualTo:(NSString*) dataIn;
-(BOOL)isGreaterThan:(NSString*) dataIn;
-(BOOL)isLessThan:(NSString*) dataIn;
-(BOOL)isBetween:(NSString*) dataIn;

@end
