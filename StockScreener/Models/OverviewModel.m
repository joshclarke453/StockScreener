//
//  OverviewModel.m
//  StockScreener
//
//  Created by Mark Windsor on 11/9/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import "OverviewModel.h"

@implementation OverviewModel

-(instancetype)initWithDict:(NSDictionary*)responseDic{
    self = [super init];
    if(self){
        self.ticker             = [responseDic objectForKey:@"symbol"];
        self.sector             = [responseDic objectForKey:@"sector"];
        self.industry           = [responseDic objectForKey:@"industry"];
        self.exchange           = [responseDic objectForKey:@"exchange"];
        self.companyName        = [responseDic objectForKey:@"companyName"];
        self.ceo                = [responseDic objectForKey:@"CEO"];
        self.website            = [responseDic objectForKey:@"website"];
        self.companyDescription = [responseDic objectForKey:@"description"];
    }
    return self;
}

-(BOOL)hasNullValues {
    if ([self.ticker isKindOfClass:[NSNull class]] || [self.ticker isEqualToString:nil]) {
        self.ticker = @"-";
    }
    if ([self.sector isKindOfClass:[NSNull class]]) {
        self.sector = @"-";
    }
    if ([self.industry isKindOfClass:[NSNull class]] || [self.industry isEqualToString:nil]) {
        self.industry = @"-";
    }
    if ([self.exchange isKindOfClass:[NSNull class]]) {
        self.exchange = @"-";
    }
    if ([self.companyName isKindOfClass:[NSNull class]]) {
        self.companyName = @"-";
    }
    if ([self.ceo isKindOfClass:[NSNull class]]) {
        self.ceo = @"-";
    }
    if ([self.website isKindOfClass:[NSNull class]]) {
        self.website = @"-";
    }
    if ([self.companyDescription isKindOfClass:[NSNull class]]) {
        self.companyDescription = @"-";
    }
    return true;
}

@end
