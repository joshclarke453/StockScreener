//
//  FilterModel.m
//  StockScreener
//
//  Created by Mark Windsor on 11/24/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel

-(instancetype)init:(NSString *)filterName with:(NSString*)filterValue{
    self = [super init];
    if(self){
        self.filterName  = filterName;
        self.filterValue = filterValue;        
    }
    return self;
}

@end
