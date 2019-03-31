//
//  Constants.h
//  StockScreener
//
//  Created by Tyler Snow on 2018-11-23.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Constants : NSObject

+(id)generateConstArray;
//Display Arrays
@property(nonatomic,strong)NSArray* overviewModelArray;
@property(nonatomic,strong)NSArray* keyStatsModelArray;

//Filter Arrays
@property(nonatomic,strong)NSArray* exchangePickerArray;
@property(nonatomic,strong)NSArray* marketCapPickerArray;
@property(nonatomic,strong)NSArray* sectorModelArray;
@property(nonatomic,strong)NSArray* pePickerArray;
@property(nonatomic,strong)NSArray* pspbPickerArray;
@property(nonatomic,strong)NSArray* roePickerArray;
@property(nonatomic,strong)NSArray* roaCapPickerArray;
@property(nonatomic,strong)NSArray* rocPickerArray;
@property(nonatomic,strong)NSArray* dividendYieldPickerArray;
@property(nonatomic,strong)NSArray* betaPickerArray;

@end

NS_ASSUME_NONNULL_END
