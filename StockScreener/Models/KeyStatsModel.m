//
//  KeyStatsModel.m
//  StockScreener
//
//  Created by Mark Windsor on 11/17/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import "KeyStatsModel.h"

@implementation KeyStatsModel


-(instancetype)initWithDict:(NSDictionary *)responseDic {
    self = [super init];
    if(self){
        self.companyName         = [self catchMissingCompanyName:[responseDic valueForKey:@"companyName"]];
        self.ticker              = [responseDic objectForKey:@"symbol"];
        self.marketCap           = [self longValueOrNil:[responseDic valueForKey:@"marketcap"]];
        self.beta                = [self doubleValueOrNil:[responseDic valueForKey:@"beta"]];
        self.yearlyLow           = [self doubleValueOrNil:[responseDic objectForKey:@"week52low"]];
        self.yearlyHigh          = [self doubleValueOrNil:[responseDic objectForKey:@"week52high"]];
        self.dividendYield       = [self doubleValueOrNil:[responseDic objectForKey:@"dividendYield"]];
        self.roe                 = [self doubleValueOrNil:[responseDic objectForKey:@"returnOnEquity"]];
        self.roa                 = [self doubleValueOrNil:[responseDic objectForKey:@"returnOnAssets"]];
        self.roc                 = [self doubleValueOrNil:[responseDic objectForKey:@"returnOnCapital"]];
        self.peHigh              = [self doubleValueOrNil:[responseDic objectForKey:@"peRatioHigh"]];
        self.peLow               = [self doubleValueOrNil:[responseDic objectForKey:@"peRatioLow"]];
        self.priceToSales        = [self doubleValueOrNil:[responseDic objectForKey:@"priceToSales"]];
        self.priceToBook         = [self doubleValueOrNil:[responseDic objectForKey:@"priceToBook"]];
        self.shortRatio          = [self doubleValueOrNil:[responseDic objectForKey:@"shortRatio"]];
        self.revenuePerShare     = [self longValueOrNil:[responseDic objectForKey:@"revenuePerShare"]];
        self.revenuePerEmployee  = [self longValueOrNil:[responseDic objectForKey:@"revenuePerEmployee"]];
        self.fiftyMovingAvg      = [self doubleValueOrNil:[responseDic objectForKey:@"day50MovingAvg"]];
        self.twoHundredMovingAvg = [self doubleValueOrNil:[responseDic objectForKey:@"day200MovingAvg"]];
    }
    return self;
}

- (NSString*)catchMissingCompanyName:(id)value {
    if ([value isMemberOfClass:[NSNull class]]) {
        return @"-";
    } else if([value isKindOfClass:[NSString class]]){
        return value;
    } else {
        return @"-";
    }
}

- (NSString*)longValueOrNil:(id)value {
    if ([value isMemberOfClass:[NSNull class]]) {
        return @"-";
    } else if([value isKindOfClass:[NSString class]]){
        return @"-";
    }
    
    NSString *valueString = [NSString stringWithFormat:@"%ld", [value longValue]];
    return valueString;
}

- (NSString*)doubleValueOrNil:(id)value {
    if ([value isMemberOfClass:[NSNull class]]) {
        return @"-";
    } else if([value isKindOfClass:[NSString class]]){
        return @"-";
        
    }
    NSString *valueString = [NSString stringWithFormat:@"%.2f", [value doubleValue]];
    return valueString;
}



@end
