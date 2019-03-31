//
//  EarningsCell.h
//  StockScreener
//
//  Created by Mark Windsor on 11/11/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FilterCellDelegate <NSObject>
@optional
- (void)showFilterAction:(UIButton *)sender;

@end

@interface FilterCell : UITableViewCell
    
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel     *filterTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton    *selectButton;
@property (weak, nonatomic) IBOutlet UILabel     *valueLabel;


@property (weak, nonatomic) id<FilterCellDelegate> cellDelegate;

@end

NS_ASSUME_NONNULL_END
