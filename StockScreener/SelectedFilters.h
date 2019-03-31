//
//  SelectedFilters.h
//  StockScreener
//
//  Created by Joshua on 2018-11-22.
//  Copyright © 2018 FLO. All rights reserved.
//

#ifndef currentSelectedFilters_h
#define currentSelectedFilters_h
#import "Filter.h"

@interface SelectedFilters : NSObject

@property (strong, nonatomic) NSMutableArray<Filter*>* selFilters;

-(id)init;
-(void)addFilter:(Filter*)newFilter;
-(void)removeFilter:(NSString*)filterToRemove;

@end

#endif
