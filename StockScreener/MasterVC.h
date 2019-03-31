//
//  MasterVC.h
//  StockScreener
//
//  Created by Mark Windsor on 11/9/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZMJGanttChart/ZMJGanttChart.h>
#import "SelectedFilters.h"
#import "Filter.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface MasterVC : UIViewController

@property (weak, nonatomic) IBOutlet SpreadsheetView *spreadsheetView;
@property (weak, nonatomic) IBOutlet UITableView     *tableView;
@property (weak, nonatomic) IBOutlet UIView          *filterView;
@property (weak, nonatomic) IBOutlet UIButton        *filterTypeButton;


//Buttons
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *topNavButtons;


// Data For Spreadsheet
@property (nonatomic, strong) NSMutableArray *header;
@property (nonatomic, strong) NSMutableArray *data;

//Actions
- (IBAction)changeFilterTypeTapped:(UIButton *)sender;
- (IBAction)menuTapped:(id)sender;
- (IBAction)dataTypeTapped:(UIButton *)sender;



@end

NS_ASSUME_NONNULL_END
