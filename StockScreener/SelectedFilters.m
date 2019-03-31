//
//  currentSelectedFilters.m
//  StockScreener
//
//  Created by Joshua on 2018-11-22.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectedFilters.h"

@interface SelectedFilters ()

@end

@implementation SelectedFilters

//Initializes the object.
-(id)init {
    self.selFilters = [[NSMutableArray alloc] initWithObjects:nil];
    return self;
}

//Adds new filter to the filter list.
-(void)addFilter:(Filter *)newFilter {
    [self removeFilter:newFilter.filterName];
    [self.selFilters addObject:newFilter];
}

//Removes filter from the filter list.
-(void)removeFilter:(NSString*)filterToRemove {
    for (Filter* f in self.selFilters) {
        if ([f.filterName isEqual:filterToRemove]) {
            [self.selFilters removeObject:f];
            break;
        }
    }
}
@end
