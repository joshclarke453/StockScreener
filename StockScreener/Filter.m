//
//  Filter.m
//  StockScreener
//
//  Created by Joshua on 2018-11-22.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Filter.h"
#import "Constants.h"

@interface Filter ()

@end

@implementation Filter {
    Constants *constArray;
}

//This method reads the filterTag and filterPicked by the user and creates a new filter object based on which one is selected.
-(id)initWithTags:(NSInteger)filterTag filterPicked:(NSInteger)filterPicked {
    self->constArray = [Constants generateConstArray];
    switch (filterTag) {
        case 0:
            self.filterName = @"Exchange";
            self.comparingTo = [constArray.exchangePickerArray objectAtIndex:filterPicked];
            self.selectedOperation = 0;
            return self;
            break;
        case 1:
            self.filterName = @"Market Cap";
            [self parseFilterSelected:[constArray.marketCapPickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 2:
            self.filterName = @"Sector";
            self.comparingTo = [constArray.sectorModelArray objectAtIndex:filterPicked];
            self.selectedOperation = 0;
            return self;
            break;
        case 3:
            self.filterName = @"Industry";
            //[self parseFilterSelected:[marketCapArrayFilters objectAtIndex:filterPicked]];
            return self;
            break;
        case 4:
            self.filterName = @"Latest EPS";
            [self parseFilterSelected:[constArray.pePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 5:
            self.filterName = @"P/E Low";
            [self parseFilterSelected:[constArray.pePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 6:
            self.filterName = @"P/E High";
            [self parseFilterSelected:[constArray.pePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 7:
            self.filterName = @"Price to Sales";
            [self parseFilterSelected:[constArray.pspbPickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 8:
            self.filterName = @"Price to Book";
            [self parseFilterSelected:[constArray.pspbPickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 9:
            self.filterName = @"Return On Equity";
            [self parseFilterSelected:[constArray.roePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 10:
            self.filterName = @"Return on Assets";
            [self parseFilterSelected:[constArray.roePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 11:
            self.filterName = @"Return on Capital";
            [self parseFilterSelected:[constArray.roePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 12:
            self.filterName = @"Profit Margin";
            [self parseFilterSelected:[constArray.roePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 13:
            self.filterName = @"Revenue per Share";
            [self parseFilterSelected:[constArray.pspbPickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 14:
            self.filterName = @"Dividend Yield";
            [self parseFilterSelected:[constArray.dividendYieldPickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 15:
            self.filterName = @"Beta";
            [self parseFilterSelected:[constArray.betaPickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 16:
            self.filterName = @"50 Day Moving Avg.";
            [self parseFilterSelected:[constArray.pePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        case 17:
            self.filterName = @"200 Day Moving Avg.";
            [self parseFilterSelected:[constArray.pePickerArray objectAtIndex:filterPicked]];
            return self;
            break;
        default:
            return self;
    }
}

//This parses the content of the filter picked to see what exactly it should be filtering for.
-(void)parseFilterSelected:(NSString*) filterString {
    if ([filterString isEqualToString:@"Any"]) {
        self.comparingTo = @"Any";
    }
    BOOL isNegative = false;
    NSString* stringEdited = filterString;
    stringEdited = [stringEdited stringByReplacingOccurrencesOfString:@"(" withString:@""];
    stringEdited = [stringEdited stringByReplacingOccurrencesOfString:@")" withString:@""];
    stringEdited = [stringEdited stringByReplacingOccurrencesOfString:@"$" withString:@""];
    stringEdited = [stringEdited stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSArray* parsedArray = [stringEdited componentsSeparatedByString:@" "];
    NSMutableArray* parsedDoubles = [[NSMutableArray alloc] initWithObjects: nil];
    NSMutableArray* parsedDoubleMultipliers = [[NSMutableArray alloc] initWithObjects: nil];
    for (NSString* comp in parsedArray) {
        if ([[comp stringByTrimmingCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"->"] invertedSet]] isEqualToString:@"-"]) {
            isNegative = true;
        }
        if ([comp isEqualToString:@"Under"] || [comp isEqualToString:@"under"]) {
            self.selectedOperation = 1;
        } else if ([comp isEqualToString:@"Over"] || [comp isEqualToString:@"over"]) {
            self.selectedOperation = 2;
        } else if ([comp isEqualToString:@"->"]) {
            self.selectedOperation = 3;
        } else if ([comp isEqualToString:@"More"] || [comp isEqualToString:@"more"]) {
            self.selectedOperation = 2;
        } else if ([comp isEqualToString:@"None"]) {
            self.selectedOperation = 0;
        }
        NSString* numHolder = [comp stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        if (![numHolder isEqualToString:@""]) {
            NSString *negIdent = @"";
            if (isNegative) {
                negIdent = @"-";
            }
            [parsedDoubles addObject:[negIdent stringByAppendingString:numHolder]];
        }
        NSString* holder = [comp stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        if ([holder isEqualToString:@"Mil"] || [holder isEqualToString:@"mil"]){
            [parsedDoubleMultipliers addObject:@"000000"];
        } else if ([holder isEqualToString:@"Bln"] || [holder isEqualToString:@"bln"]) {
            [parsedDoubleMultipliers addObject:@"000000000"];
        }
    }
    if ([parsedDoubles count] != 0){
        if ([parsedDoubleMultipliers count] != 0){
            self.comparingTo = [[parsedDoubles objectAtIndex:0] stringByAppendingString:[parsedDoubleMultipliers objectAtIndex:0]];
        } else {
            self.comparingTo = [parsedDoubles objectAtIndex:0];
        }
    }
    if ([parsedDoubles count] >= 2){
        if ([parsedDoubleMultipliers count] >= 2){
            self.comparingToOther = [[parsedDoubles objectAtIndex:1] stringByAppendingString:[parsedDoubleMultipliers objectAtIndex:1]];
        } else {
            self.comparingTo = [parsedDoubles objectAtIndex:1];
        }
    }
}

//This method checks if the filter selected complys with the data it is given from the Master View Controller.
-(BOOL)complysWith:(NSString*) dataIn {
    if ([self.comparingTo isEqualToString:@"Any"]) {
        return TRUE;
    } else {
        switch (self.selectedOperation) {
            case 0:
                return [self isEqualTo:dataIn];
                break;
            case 1:
                return [self isLessThan:dataIn];
                break;
            case 2:
                return [self isGreaterThan:dataIn];
                break;
            case 3:
                return [self isBetween: dataIn];
                break;
            default:
                return [self isEqualTo:dataIn];
                break;
        }
    }
}

//Checks if the strings are equal
-(BOOL)isEqualTo:(NSString*) dataIn{
    if ([self.comparingTo isEqualToString:@"NYSE"]) {
        if ([dataIn isEqualToString:@"New York Stock Exchange"] || [dataIn isEqualToString:@"NYSE American"] || [dataIn isEqualToString:@"NYSE Arca"]) {
            return true;
        } else {
            return false;
        }
    } else if ([self.comparingTo isEqualToString:@"Nasdaq"]) {
        if ([dataIn isEqualToString:@"NASDAQ Global Market"] || [dataIn isEqualToString:@"Nasdaq Global Select"] || [dataIn isEqualToString:@"NASDAQ Caital Market"]) {
            return true;
        } else {
            return false;
        }
    } else if ([dataIn isEqualToString:self.comparingTo]){
        return true;
    } else {
        return false;
    }
}

//Checks Greater than.
-(BOOL)isGreaterThan:(NSString*) dataIn{
    double compNum = [self.comparingTo doubleValue];
    double numData = [dataIn doubleValue];
    if (numData >= compNum) {
        return true;
    } else {
        return false;
    }
}

//Checks Less than.
-(BOOL)isLessThan:(NSString*) dataIn{
    double compNum = [self.comparingTo doubleValue];
    double numData = [dataIn doubleValue];
    if (numData <= compNum) {
        return true;
    } else {
        return false;
    }
}

//Checks for filters such as "Between 2 and 10 Billion".
-(BOOL)isBetween:(NSString*) dataIn{
    double compLow = [self.comparingTo doubleValue];
    double compHigh = [self.comparingToOther doubleValue];
    double numData = [dataIn doubleValue];
    if ((numData >= compLow) && (numData <= compHigh)) {
        return true;
    } else {
        return false;
    }
}

@end
