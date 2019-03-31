//
//  FilterSelectionView.h
//  StockScreener
//
//  Created by Mark Windsor on 11/9/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterSelectionView : UIView

@property (weak, nonatomic) IBOutlet UIButton     *exitButton;
@property (weak, nonatomic) IBOutlet UIView       *mainView;
@property (weak, nonatomic) IBOutlet UILabel      *filterLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton     *okButton;
    
    
@end

NS_ASSUME_NONNULL_END
