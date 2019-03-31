//
//  KeyStatsModel.h
//  StockScreener
//
//  Created by Mark Windsor on 11/17/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyStatsModel : NSObject


@property(nonatomic, retain) NSString    *ticker;
@property(nonatomic, retain) NSString    *companyName;
@property(nonatomic, retain) NSString    *marketCap;
@property(nonatomic, retain) NSString    *beta;
@property(nonatomic, retain) NSString    *yearlyHigh;
@property(nonatomic, retain) NSString    *yearlyLow;
@property(nonatomic, retain) NSString    *dividendYield;
@property(nonatomic, retain) NSString    *roe;
@property(nonatomic, retain) NSString    *roa;
@property(nonatomic, retain) NSString    *roc;
@property(nonatomic, retain) NSString    *peHigh;
@property(nonatomic, retain) NSString    *peLow;
@property(nonatomic, retain) NSString    *priceToSales;
@property(nonatomic, retain) NSString    *priceToBook;
@property(nonatomic, retain) NSString    *shortRatio;
@property(nonatomic, retain) NSString    *revenuePerShare;
@property(nonatomic, retain) NSString    *revenuePerEmployee;
@property(nonatomic, retain) NSString    *fiftyMovingAvg;
@property(nonatomic, retain) NSString    *twoHundredMovingAvg;

-(instancetype)initWithDict:(NSDictionary *)responseDic;

@end

NS_ASSUME_NONNULL_END
