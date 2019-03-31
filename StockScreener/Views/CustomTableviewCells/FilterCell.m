//
//  EarningsCell.m
//  StockScreener
//
//  Created by Mark Windsor on 11/11/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)filterTapped:(id)sender {
    [self.cellDelegate showFilterAction:sender];
}


@end
