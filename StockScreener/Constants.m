//
//  Constants.m
//  StockScreener
//
//  Created by Tyler Snow on 2018-11-23.
//  Copyright © 2018 FLO. All rights reserved.
//

#import "Constants.h"

@implementation Constants

@synthesize overviewModelArray, keyStatsModelArray, exchangePickerArray, marketCapPickerArray, sectorModelArray, pePickerArray, pspbPickerArray, betaPickerArray, dividendYieldPickerArray, roePickerArray;
-(id)init{
    if(self=[super init])
    {
        self->overviewModelArray=[[NSArray alloc] initWithObjects:@"Company Name", @"Ticker", @"Exchange", @"Sector", @"Industry", @"CEO", @"Website", @"Description",nil];
        self->keyStatsModelArray=[[NSArray alloc]initWithObjects:@"Company Name", @"Ticker", @"Market Cap", @"Beta", @"52w High", @"52w Low", @"Dividend Yield", @"Return On Equity", @"Return on Assets", @"Return on Capital", @"P/E High", @"P/E Low", @"Price to Sales", @"Price to Book", @"Short Ratio", @"Revenue per Share", @"Short Ratio", @"50 Day Moving Avg.", nil];
        self->exchangePickerArray=[[NSArray alloc]initWithObjects:@"Any", @"Nasdaq", @"NYSE", nil];
        self->marketCapPickerArray=[[NSArray alloc]initWithObjects:@"Any", @"Micro (Under $300Mil)", @"Micro (Over $50Mil)", @"Small (Under $2bln)", @"Small (Over $300Mil)", @"Mid (Under $10bln)", @"Mid (Over $2bln)", @"Large (under $200bln)", @"Large (over $10bln)", @"Nano (under $50mil)", @"Small ($300mil -> $2bln)", @"Mid ($2bln -> $10bln)", @"Large ($10bln -> $200bln)", @"Mega $1bln or more", nil];
        self->sectorModelArray = [[NSArray alloc] initWithObjects:@"Any", @"Basic Materials", @"Conglomerates", @"Consumer Goods", @"Financial Services", @"Healthcare", @"Industrials", @"Services", @"Technology", @"Utilities", nil];
        self->pePickerArray=[[NSArray alloc]initWithObjects:@"Any", @"Over 0", @"Under 10", @"Over 10", @"Under 20", @"Over 20", @"Under 30", @"Over 30", @"Under 40", @"Over 40", @"Under 50", @"Over 50", nil];
        self->pspbPickerArray = [[NSArray alloc]initWithObjects:@"Any", @"Under 1", @"Under 2", @"Under 3", @"Under 4", @"Under 5", @"Under 6", @"Under 7", @"Under 8", @"Under 9", @"Under 10",  @"Over 1", @"Over 2", @"Over 3", @"Over 4", @"Over 5", @"Over 6", @"Over 7", @"Over 8", @"Over 9", @"Over 10",  nil];
        self->betaPickerArray = [[NSArray alloc]initWithObjects:@"Any", @"Under 0", @"Under 0.5", @"Under 1", @"Under 1.5", @"Under 2", @"Over 0", @"Over 0.5", @"Over 1", @"Over 1.5", @"Over 2", @"Over 2.5", @"Over 3", @"Over 4", @"0 -> 0.5", @"0 -> 1", @"0.5 -> 1", @"0.5 -> 1.5", @"1 -> 1.5", @"1 -> 2",  nil];
        self->dividendYieldPickerArray = [[NSArray alloc]initWithObjects:@"Any", @"None (0%)", @"Over 0%", @"Over 1%", @"Over 2%", @"Over 3%", @"Over 4%", @"Over 5%", @"Over 6%", @"Over 7%", @"Over 8%", @"Over 9%", @"Over 10%", nil];
        self->roePickerArray = [[NSArray alloc]initWithObjects:@"Any", @"Over 0%)", @"Under 0%)", @"Under -50%", @"Under -40%", @"Under -30%", @"Under -20%", @"Under -15%)", @"Under -10%", @"Over +10%", @"Over +20%", @"Over +30%", @"Over +40%", @"Over +50%", nil];
        
    }
    return self;
}
+(Constants *)generateConstArray
{
    Constants* constantArray=[[self alloc]init];
    return constantArray;
}
@end

