//
//  OverviewModel.h
//  StockScreener
//
//  Created by Mark Windsor on 11/9/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface OverviewModel : NSObject
    
@property(nonatomic, retain) NSString *ticker;
@property(nonatomic, retain) NSString *sector;
@property(nonatomic, retain) NSString *industry;
@property(nonatomic, retain) NSString *exchange;
@property(nonatomic, retain) NSString *companyName;
@property(nonatomic, retain) NSString *ceo;
@property(nonatomic, retain) NSString *website;
@property(nonatomic, retain) NSString *companyDescription;

-(instancetype)initWithDict:(NSDictionary*)responseDic;
-(BOOL)hasNullValues;

@end

NS_ASSUME_NONNULL_END
