//
//  FilterModel.h
//  StockScreener
//
//  Created by Mark Windsor on 11/24/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterModel : NSObject

@property(nonatomic, retain) NSString    *filterName;
@property(nonatomic, retain) NSString    *filterValue;

-(instancetype)init:(NSString *)filterName with:(NSString*)filterValue;

@end

NS_ASSUME_NONNULL_END
