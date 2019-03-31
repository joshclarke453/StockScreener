//
//  MasterVC.m
//  StockScreener
//
//  Created by Mark Windsor on 11/9/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import "MasterVC.h"
#import <ZMJGanttChart/ZMJGanttChart.h>
#import "ZMJCells.h"
#import "SWNetworking.h"
#import "OverviewModel.h"
#import "KeyStatsModel.h"
#import "FilterSelectionView.h"
#import "Filter.h"
#import "SelectedFilters.h"
#import "FilterCell.h"
#import "FilterModel.h"
#import "Constants.h"

typedef NS_ENUM(NSInteger, ZMJSorting) {
    ZMJAscending = 0,
    ZMJDsescending
};

static NSString * getSymbol(ZMJSorting sorting) {
    switch (sorting) {
        case ZMJAscending:
            return @"\u25B2";
            break;
        case ZMJDsescending:
            return @"\u25BC";
            break;
        default:
            break;
    }
}

typedef struct SortedColumn {
    NSInteger column;
    ZMJSorting sorting;
} SortedColumn;

@interface MasterVC () <SpreadsheetViewDelegate, SpreadsheetViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, FilterCellDelegate>

@property (nonatomic, assign) SortedColumn    sortedColumn;
@property (weak, nonatomic) IBOutlet UILabel  *tickerNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *next25Button;
@property (weak, nonatomic) IBOutlet UIButton *previous25Button;

@end

@implementation MasterVC {
    
    NSString *tickerString;
    NSMutableArray *tickerArray;
    int tickerNumbers;
    int tickerNumbersChange;
    
    NSMutableArray *filterModelArray;

    Constants *constArray;
    
    FilterSelectionView *filterSelectionView;
    SelectedFilters     *selectedFilters;
    NSInteger currentDataType;
    
    //Header Arrays
    NSMutableArray *keyStatsHeaders;
    NSMutableArray *overviewHeaders;
    
    //Filter Picker Array
    NSMutableArray *filterArray;
}

@synthesize spreadsheetView, header, data, tableView, filterView, topNavButtons, filterTypeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self->data                      = [NSMutableArray new];
    self->tickerNumbers             = 0;
    self->tickerNumbersChange       = 0;
    
    //Spreadsheet view set up
    self.spreadsheetView.delegate   = self;
    self.spreadsheetView.dataSource = self;
    [self.spreadsheetView registerClass:[HeaderCell class] forCellWithReuseIdentifier:NSStringFromClass([HeaderCell class])];
    [self.spreadsheetView registerClass:[TextCell class] forCellWithReuseIdentifier:NSStringFromClass([TextCell class])];
    
    //Filter view
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    self.sortedColumn = (SortedColumn){0, ZMJAscending};
    
    filterTypeButton.layer.cornerRadius = 5.0;   
    
    self->constArray = [Constants generateConstArray];

    self.header = [NSMutableArray arrayWithArray:constArray.overviewModelArray];
    self->selectedFilters = [[SelectedFilters alloc] init];
    
    filterArray = [NSMutableArray new];
    
    //Top Nav Set up
    [[self->topNavButtons objectAtIndex:5] setBackgroundImage:[UIImage imageNamed:@"dataTypeSelect.pdf"] forState:UIControlStateSelected];
    [[self->topNavButtons objectAtIndex:5] setSelected:YES];
    
    //
    [self getFilterModels];
    [self getTickers];
}

#pragma mark - Populate Table View Cell Models


//Filter Models whose purpose is to change the table view values
-(void)getFilterModels{
    
    FilterModel *exchangeModel  = [[FilterModel alloc] init:@"Exchange" with:@"Any"];
    FilterModel *marketCapModel = [[FilterModel alloc] init:@"Market Cap" with:@"Any"];
    FilterModel *sectorModel    = [[FilterModel alloc] init:@"Sector" with:@"Any"];
    FilterModel *industryModel  = [[FilterModel alloc] init:@"Industry" with:@"Any"];
    
    FilterModel *latestEPSModel   = [[FilterModel alloc] init:@"Latest EPS" with:@"Any"];
    FilterModel *peLowModel       = [[FilterModel alloc] init:@"P/E Low" with:@"Any"];
    FilterModel *peHighModel      = [[FilterModel alloc] init:@"P/E High" with:@"Any"];
    FilterModel *priceSalesModel  = [[FilterModel alloc] init:@"Price to Sales" with:@"Any"];
    FilterModel *priceBookModel   = [[FilterModel alloc] init:@"Price to Book" with:@"Any"];
    
    FilterModel *roeModel          = [[FilterModel alloc] init:@"Return on Equity" with:@"Any"];
    FilterModel *roaModel          = [[FilterModel alloc] init:@"Return on Assets" with:@"Any"];
    FilterModel *rocModel          = [[FilterModel alloc] init:@"Return on Capital" with:@"Any"];
    FilterModel *profitModel       = [[FilterModel alloc] init:@"Profit Margin" with:@"Any"];
    FilterModel *revPerShareModel  = [[FilterModel alloc] init:@"Revenue per Share" with:@"Any"];
    FilterModel *dividendModel     = [[FilterModel alloc] init:@"Dividend Yield" with:@"Any"];
    
    FilterModel *betaModel         = [[FilterModel alloc] init:@"Beta" with:@"Any"];
    FilterModel *fiftyDayModel     = [[FilterModel alloc] init:@"50d Moving Avg" with:@"Any"];
    FilterModel *twoHundredModel   = [[FilterModel alloc] init:@"200d Moving Avg" with:@"Any"];

    filterModelArray = [[NSMutableArray alloc] initWithObjects:exchangeModel, marketCapModel, sectorModel, industryModel, latestEPSModel, peLowModel, peHighModel, priceSalesModel, priceBookModel, roeModel, roaModel, rocModel, profitModel, revPerShareModel, dividendModel, betaModel, fiftyDayModel, twoHundredModel,  nil];
}


#pragma mark - Networking Methods


//Initial API request to get ticker symbols to be used in other requests
-(void)getTickers {
    
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startDataTaskWithURL:@"https://api.iextrading.com/1.0/ref-data/symbols" parameters:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSError* error;
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        self->tickerArray = [NSMutableArray new];
        for(int i = self->tickerNumbers; i < (self->tickerNumbers + 500); i++){
            NSDictionary *jsonDic  = jsonArray[i];
            NSString *tickerString = [jsonDic objectForKey:@"symbol"];
            [self->tickerArray addObject:tickerString];
        }
        self->tickerString = [self->tickerArray componentsJoinedByString:@","];
        [self getCurrentPageData];
        
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
}

//Calls either getKeyStats or getOverviewData based off what data you are currently looking at.
-(void)getCurrentPageData {
    switch (currentDataType) {
        case 10:
            [self getOverviewData:self->tickerArray withString:self->tickerString];
            break;
        case 50:
            [self getKeyStats:self->tickerArray withString:self->tickerString];
            break;
        default:
            [self getOverviewData:self->tickerArray withString:self->tickerString];
            break;
    }
}

//API Request to get descriptive data
-(void)getOverviewData:(NSArray*)tickerArray withString:(NSString*)tickerString{
    [self->data removeAllObjects];
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startDataTaskWithURL:[NSString stringWithFormat:@"https://api.iextrading.com/1.0/stock/market/batch?symbols=%@&types=company", tickerString] parameters:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSError* error;
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:kNilOptions
                                                                  error:&error];
        int i = self->tickerNumbers;
        NSString* lastTicker;
        for(NSString *ticker in tickerArray){
            if (i >= self->tickerNumbers+25) {
                lastTicker = ticker;
                break;
            }
            NSDictionary *responseDic        = [[jsonDic objectForKey:ticker] objectForKey:@"company"];
            if (responseDic != nil) {
                OverviewModel *overviewModel     = [[OverviewModel alloc] initWithDict:responseDic];
                if ([overviewModel hasNullValues]) {
                    NSMutableArray *overviewRow      = [[NSMutableArray alloc] initWithObjects:overviewModel.companyName, overviewModel.ticker, overviewModel.exchange,     overviewModel.sector, overviewModel.industry, overviewModel.ceo, overviewModel.website, overviewModel.companyDescription, nil];
                    if ([self constrainToFilters:overviewRow]) {
                        [self.data addObject:overviewRow];
                        i++;
                    }
                }
            }
            lastTicker = ticker;
        }
        self->tickerNumbersChange = [self->tickerArray indexOfObjectIdenticalTo:lastTicker];
        [self.spreadsheetView reloadData];
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    [self.spreadsheetView reloadData];
}

//API request to get key stats data
-(void)getKeyStats:(NSArray*)tickerArray withString:(NSString*)tickerString{
    
    [self->data removeAllObjects];
    SWGETRequest *getRequest = [[SWGETRequest alloc]init];
    [getRequest startDataTaskWithURL:[NSString stringWithFormat:@"https://api.iextrading.com/1.0/stock/market/batch?symbols=%@&types=stats", tickerString] parameters:nil success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
        NSError* error;
        NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                options:kNilOptions
                                                                  error:&error];
        int i = self->tickerNumbers;
        NSString* lastTicker;
        for(NSString *ticker in self->tickerArray){
            if (i >= self->tickerNumbers+25) {
                lastTicker = ticker;
                break;
            }
            NSDictionary *responseDic         = [[jsonDic objectForKey:ticker] objectForKey:@"stats"];
            if (responseDic != nil) {
                KeyStatsModel *keyStatsModel      = [[KeyStatsModel alloc] initWithDict:responseDic];
                NSMutableArray *keyStatsRow       = [[NSMutableArray alloc] initWithObjects: keyStatsModel.companyName, keyStatsModel.ticker, keyStatsModel.marketCap, keyStatsModel.beta, keyStatsModel.yearlyLow, keyStatsModel.yearlyHigh, keyStatsModel.dividendYield,
                                                 keyStatsModel.roe, keyStatsModel.roa, keyStatsModel.roc, keyStatsModel.peLow, keyStatsModel.peHigh, keyStatsModel.priceToSales, keyStatsModel.priceToBook, keyStatsModel.revenuePerShare,  keyStatsModel.shortRatio, keyStatsModel.fiftyMovingAvg, keyStatsModel.twoHundredMovingAvg, nil];
                if ([self constrainToFilters:keyStatsRow]) {
                    [self.data addObject:keyStatsRow];
                    i++;
                }
            }
            lastTicker = ticker;
        }
        self->tickerNumbersChange = [self->tickerArray indexOfObjectIdenticalTo:lastTicker];
        [self->spreadsheetView reloadData];
    } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
        
    }];
    
    [self.spreadsheetView reloadData];
}

#pragma mark Filtering Methods

//A method to see if the cell complys with the filters the user has selected.
-(BOOL)constrainToFilters:(NSMutableArray*)row {
    BOOL complys = TRUE;
    for (NSString* h in self.header) {
        for (Filter* f in self->selectedFilters.selFilters) {
            if ([f.filterName isEqualToString:h]) {
                NSUInteger index = [header indexOfObject:h];
                if (![f complysWith:[row objectAtIndex:index]]) {
                    complys = FALSE;
                }
            }
        }
    }
    return complys;
}

//A method to create a new filter and change the look of the filter view.
-(void)addFilter:(UIButton *)sender {
    Filter* newFilter = [[Filter alloc] initWithTags:sender.tag filterPicked:[filterSelectionView.pickerView selectedRowInComponent:0]];
    [self->selectedFilters addFilter:newFilter];
    [filterSelectionView removeFromSuperview];
    [self getCurrentPageData];
    
    FilterModel *filterModel = [FilterModel new];
    NSInteger *row           = [filterSelectionView.pickerView selectedRowInComponent:0];
    filterModel              = [filterModelArray objectAtIndex:sender.tag];
    filterModel.filterValue  = [filterArray objectAtIndex:row];
    
    
    [tableView reloadData];
    [filterSelectionView removeFromSuperview];
    
}

// MARK: Model Methods

-(void)showFilterSelectionView{
    filterSelectionView                             = [[[NSBundle mainBundle] loadNibNamed:@"FilterSelectionView" owner:self options:nil] objectAtIndex:0];
    filterSelectionView.filterLabel.text            = @"Select Filter Type";
    filterSelectionView.mainView.layer.cornerRadius = 8.0;
    filterSelectionView.okButton.layer.cornerRadius = 8.0;
    filterSelectionView.pickerView.delegate         = self;
    filterSelectionView.pickerView.dataSource       = self;
    [filterSelectionView.exitButton addTarget:self action:@selector(hideFilterSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:filterSelectionView];
}


#pragma mark - Selectors

-(void)hideFilterSelect{
    [filterSelectionView removeFromSuperview];
}


#pragma mark - Actions
- (IBAction)changeFilterTypeTapped:(UIButton *)sender {
    [self showFilterSelectionView];
}

//This method opens and closes the filter selection menu
- (IBAction)menuTapped:(id)sender {
    
    if([sender isSelected]){
        [sender setSelected:NO];
        [UIView animateWithDuration:.3 animations:^{
            
            [self->filterView setFrame:CGRectMake(0, 94, self->filterView.frame.size.width, self->filterView.frame.size.height)];
            [self->tableView setFrame:CGRectMake(0, 224, self->tableView.frame.size.width, self->tableView.frame.size.height)];
            [self->spreadsheetView setFrame:CGRectMake(254, 94, self->spreadsheetView.frame.size.width, self->spreadsheetView.frame.size.height)];
        }];
    } else {
        [sender setSelected:YES];
        [UIView animateWithDuration:.3 animations:^{
            
            [self->filterView setFrame:CGRectMake(-254, 94, self->filterView.frame.size.width, self->filterView.frame.size.height)];
            [self->tableView setFrame:CGRectMake(-254, 224, self->tableView.frame.size.width, self->tableView.frame.size.height)];
            [self->spreadsheetView setFrame:CGRectMake(0, 94, 1366, self->spreadsheetView.frame.size.height)];
            
        }];
    }
}

//Connected to the button to get the next 25 tickers.
- (IBAction)getNext25:(UIButton *)sender {
    self->tickerNumbers += tickerNumbersChange;
    [self getTickers];
    [self changeTickerNumLabel];
}

//Connected to the button to get the previous 25 tickers.
- (IBAction)getPrevious25:(UIButton *)sender {
    if ((self->tickerNumbers - (tickerNumbersChange)) <= 0) {
        self->tickerNumbers = 0;
    } else {
        self->tickerNumbers -= tickerNumbersChange;
    }
    [self getTickers];
    [self changeTickerNumLabel];
}

//Changes the label showing what tickers are being viewed.
- (void)changeTickerNumLabel {
    NSString* newLabel = [NSString stringWithFormat:@"Displaying Ticker Numbers %d - %d", self->tickerNumbers, self->tickerNumbers+self->tickerNumbersChange];
    self.tickerNumberLabel.text = newLabel;
}

//Controls which data is shown depending on what button you click
- (IBAction)dataTypeTapped:(UIButton *)sender {
    
    for(UIButton *button in topNavButtons){
        [button setSelected:NO];
    }
    [self.spreadsheetView setContentOffset:CGPointMake(0, 0)];
    currentDataType = sender.tag;
    switch (sender.tag) {
        case 10:
            self->header = [[NSMutableArray alloc] initWithArray:constArray.overviewModelArray];
            [self getOverviewData:self->tickerArray withString:self->tickerString];
            if ([sender isSelected]){
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                [sender setSelected:NO];
            }
            else {
                [sender setBackgroundImage:[UIImage imageNamed:@"dataTypeSelect.pdf"] forState:UIControlStateSelected];
                [sender setSelected:YES];
            }
            break;
        case 20:
            if ([sender isSelected]){
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                [sender setSelected:NO];
            }
            else {
                [sender setBackgroundImage:[UIImage imageNamed:@"dataTypeSelect.pdf"] forState:UIControlStateSelected];
                [sender setSelected:YES];
            }
            break;
        case 30:
            if ([sender isSelected]){
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                [sender setSelected:NO];
            }
            else {
                [sender setBackgroundImage:[UIImage imageNamed:@"dataTypeSelect.pdf"] forState:UIControlStateSelected];
                [sender setSelected:YES];
            }
            break;
        case 40:
            if ([sender isSelected]){
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                [sender setSelected:NO];
            }
            else {
                [sender setBackgroundImage:[UIImage imageNamed:@"dataTypeSelect.pdf"] forState:UIControlStateSelected];
                [sender setSelected:YES];
            }
            break;
        case 50:
            self->header = [[NSMutableArray alloc] initWithArray:constArray.keyStatsModelArray];
            [self getKeyStats:self->tickerArray withString:self->tickerString];
            if ([sender isSelected]){
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                [sender setSelected:NO];
            }
            else {
                [sender setBackgroundImage:[UIImage imageNamed:@"dataTypeSelect.pdf"] forState:UIControlStateSelected];
                [sender setSelected:YES];
            }
            break;
        case 60:
            if ([sender isSelected]){
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                [sender setSelected:NO];
            }
            else {
                [sender setBackgroundImage:[UIImage imageNamed:@"dataTypeSelect.pdf"] forState:UIControlStateSelected];
                [sender setSelected:YES];
            }
            break;
        default:
            break;
    }
}


#pragma mark - Spreadsheet Delegate & Datasource
- (NSInteger)numberOfColumns:(SpreadsheetView *)spreadsheetView {
    return self.header.count;
}

- (NSInteger)numberOfRows:(SpreadsheetView *)spreadsheetView {
    return self.data.count + 1;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSInteger)column {
    return 140;
}

- (CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSInteger)row {
    return row == 0 ? 60 : 40;
}

- (NSInteger)frozenRows:(SpreadsheetView *)spreadsheetView {
    return 1;
}

- (NSInteger)frozenColumns:(SpreadsheetView *)spreadsheetView {
    return 1;
}

- (ZMJCell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HeaderCell *cell = (HeaderCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HeaderCell class])
                                                                                    forIndexPath:indexPath];
        cell.label.text = self.header[indexPath.column];
        
        if (indexPath.column == self.sortedColumn.column) {
            cell.sortArrow.text = getSymbol(self.sortedColumn.sorting);
        } else {
            cell.sortArrow.text = @"";
        }
        return cell;
    } else {
        TextCell *cell = (TextCell *)[spreadsheetView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TextCell class])
                                                                                forIndexPath:indexPath];
        cell.label.text = self.data[indexPath.row - 1][indexPath.column];
        return cell;
    }
}



#pragma mark - PickerView Delegate Datasource
//Methods for the filter pickerviews.
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 100;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return filterArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [filterArray objectAtIndex:row];
}


#pragma mark: TableView Delegate & Datasource

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 254, 0.1)];
    view.backgroundColor = [UIColor grayColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

//The method to initialize the filter table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Switch Case for Sections.
    switch (indexPath.section) {
        case 0: {
            FilterCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
            if(filterCell == nil){
                filterCell = [[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil] objectAtIndex:0];
            }
            
            filterCell.cellDelegate = self;
            
            if(indexPath.row == 0){
                
                FilterModel *exchangeModel       = [filterModelArray objectAtIndex:0];
                filterCell.filterTitleLabel.text = exchangeModel.filterName;
                filterCell.valueLabel.text       = exchangeModel.filterValue;
                filterCell.selectButton.tag      = 0;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 1){
                
                FilterModel *marketCapModel      = [filterModelArray objectAtIndex:1];
                filterCell.filterTitleLabel.text = marketCapModel.filterName;
                filterCell.valueLabel.text       = marketCapModel.filterValue;
                filterCell.selectButton.tag      = 1;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 2){
                FilterModel *sectorModel         = [filterModelArray objectAtIndex:2];
                filterCell.filterTitleLabel.text = sectorModel.filterName;
                filterCell.valueLabel.text       = sectorModel.filterValue;
                filterCell.selectButton.tag      = 2;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 3){
                FilterModel *industryModel       = [filterModelArray objectAtIndex:3];
                filterCell.filterTitleLabel.text = industryModel.filterName;
                filterCell.valueLabel.text       = industryModel.filterValue;
                filterCell.selectButton.tag      = 3;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            }
            
            return filterCell;
        }

        break;
          
        case 1: {

            FilterCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
            if(filterCell == nil){
                filterCell = [[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil] objectAtIndex:0];
            }
            
            filterCell.cellDelegate = self;
            
            if(indexPath.row == 0){
                
                FilterModel *latestEPSModel      = [filterModelArray objectAtIndex:4];
                filterCell.filterTitleLabel.text = latestEPSModel.filterName;
                filterCell.valueLabel.text       = latestEPSModel.filterValue;
                filterCell.selectButton.tag      = 4;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 1){
                
                FilterModel *peLowModel          = [filterModelArray objectAtIndex:5];
                filterCell.filterTitleLabel.text = peLowModel.filterName;
                filterCell.valueLabel.text       = peLowModel.filterValue;
                filterCell.selectButton.tag      = 5;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 2){
                FilterModel *peHighModel         = [filterModelArray objectAtIndex:6];
                filterCell.filterTitleLabel.text = peHighModel.filterName;
                filterCell.valueLabel.text       = peHighModel.filterValue;
                filterCell.selectButton.tag      = 6;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 3){
                FilterModel *priceSalesModel     = [filterModelArray objectAtIndex:7];
                filterCell.filterTitleLabel.text = priceSalesModel.filterName;
                filterCell.valueLabel.text       = priceSalesModel.filterValue;
                filterCell.selectButton.tag      = 7;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 4){
                FilterModel *priceBookModel      = [filterModelArray objectAtIndex:8];
                filterCell.filterTitleLabel.text = priceBookModel.filterName;
                filterCell.valueLabel.text       = priceBookModel.filterValue;
                filterCell.selectButton.tag      = 8;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            }
            return filterCell;

        }
            break;
    
        case 2: {

            FilterCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
            if(filterCell == nil){
                filterCell = [[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil] objectAtIndex:0];
                
            }
            
            filterCell.cellDelegate = self;
            
            if(indexPath.row == 0){
                
                FilterModel *roeModel            = [filterModelArray objectAtIndex:9];
                filterCell.filterTitleLabel.text = roeModel.filterName;
                filterCell.valueLabel.text       = roeModel.filterValue;
                filterCell.selectButton.tag      = 9;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 1){
                
                FilterModel *roaModel            = [filterModelArray objectAtIndex:10];
                filterCell.filterTitleLabel.text = roaModel.filterName;
                filterCell.valueLabel.text       = roaModel.filterValue;
                filterCell.selectButton.tag      = 10;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 2){
                FilterModel *rocModel            = [filterModelArray objectAtIndex:11];
                filterCell.filterTitleLabel.text = rocModel.filterName;
                filterCell.valueLabel.text       = rocModel.filterValue;
                filterCell.selectButton.tag      = 11;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 3){
                FilterModel *profitMarginModel   = [filterModelArray objectAtIndex:12];
                filterCell.filterTitleLabel.text = profitMarginModel.filterName;
                filterCell.valueLabel.text       = profitMarginModel.filterValue;
                filterCell.selectButton.tag      = 12;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 4){
                FilterModel *revModel            = [filterModelArray objectAtIndex:13];
                filterCell.filterTitleLabel.text = revModel.filterName;
                filterCell.valueLabel.text       = revModel.filterValue;
                filterCell.selectButton.tag      = 13;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 5){
                FilterModel *dividendModel       = [filterModelArray objectAtIndex:14];
                filterCell.filterTitleLabel.text = dividendModel.filterName;
                filterCell.valueLabel.text       = dividendModel.filterValue;
                filterCell.selectButton.tag      = 14;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            }
            return filterCell;
        }  case 3: {
           
            FilterCell *filterCell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
            if(filterCell == nil){
                filterCell = [[[NSBundle mainBundle] loadNibNamed:@"FilterCell" owner:self options:nil] objectAtIndex:0];
                
            }
            
            filterCell.cellDelegate = self;

            if(indexPath.row == 0){
                
                FilterModel *betaModel           = [filterModelArray objectAtIndex:15];
                filterCell.filterTitleLabel.text = betaModel.filterName;
                filterCell.valueLabel.text       = betaModel.filterValue;
                filterCell.selectButton.tag      = 15;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 1){
                
                FilterModel *fiftyModel          = [filterModelArray objectAtIndex:16];
                filterCell.filterTitleLabel.text = fiftyModel.filterName;
                filterCell.valueLabel.text       = fiftyModel.filterValue;
                filterCell.selectButton.tag      = 16;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            } else if(indexPath.row == 2){
                FilterModel *twoHundredModel     = [filterModelArray objectAtIndex:17];
                filterCell.filterTitleLabel.text = twoHundredModel.filterName;
                filterCell.valueLabel.text       = twoHundredModel.filterValue;
                filterCell.selectButton.tag      = 17;
                if(![filterCell.valueLabel.text isEqualToString:@"Any"]){
                    filterCell.backgroundImage.image      = [UIImage imageNamed:@"FilterSelectView.pdf"];
                    filterCell.filterTitleLabel.textColor = [UIColor whiteColor];
                    filterCell.valueLabel.textColor       = [UIColor whiteColor];
                }
                
            }
            return filterCell;
        }
            
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 5;
            break;
        case 2:
            return 6;
            break;
        case 3:
            return 3;
            break;
        default:
            return 5;
            break;
    }
    return 0;
}

#pragma mark - Filter Cell Delegate

//This method determines what is diplayed in each filter pickerview.
-(void)showFilterAction:(UIButton *)sender{
    
    filterSelectionView                             = [[[NSBundle mainBundle] loadNibNamed:@"FilterSelectionView" owner:self options:nil] objectAtIndex:0];
    filterSelectionView.mainView.layer.cornerRadius = 8.0;
    filterSelectionView.okButton.layer.cornerRadius = 8.0;
    filterSelectionView.pickerView.delegate         = self;
    filterSelectionView.pickerView.dataSource       = self;
    [filterSelectionView.exitButton addTarget:self action:@selector(hideFilterSelect) forControlEvents:UIControlEventTouchUpInside];
    
    
    switch (sender.tag) {
        case 0:
            filterSelectionView.filterLabel.text     = @"Exchange";
            filterArray                              = [NSMutableArray arrayWithArray:constArray.exchangePickerArray];
            filterSelectionView.okButton.tag         = 0;
            break;
        case 1:
            filterSelectionView.filterLabel.text     = @"Market Cap";
            filterArray                              = [NSMutableArray arrayWithArray:constArray.marketCapPickerArray];
            filterSelectionView.okButton.tag         = 1;
            break;
        case 2:
            filterSelectionView.filterLabel.text     = @"Sector";
            filterArray                              = [NSMutableArray arrayWithArray:constArray.sectorModelArray];
            filterSelectionView.okButton.tag         = 2;
            break;
        case 3:
            filterSelectionView.filterLabel.text     = @"Industry";
            filterSelectionView.okButton.tag         = 3;
            break;
        
        case 4:
            filterSelectionView.filterLabel.text     = @"Latest EPS";
            filterArray                              = [NSMutableArray arrayWithArray:constArray.pePickerArray];
            filterSelectionView.okButton.tag         = 4;
            break;
        case 5:
            filterSelectionView.filterLabel.text     = @"P/E Low";
            filterSelectionView.okButton.tag         = 5;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.pePickerArray];
            break;
        case 6:
            filterSelectionView.filterLabel.text     = @"P/E High";
            filterSelectionView.okButton.tag         = 6;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.pePickerArray];
            break;
        case 7:
            filterSelectionView.filterLabel.text     = @"Price to Sales";
            filterSelectionView.okButton.tag         = 7;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.pspbPickerArray];
            break;
        case 8:
            filterSelectionView.filterLabel.text     = @"Price to Book";
            filterSelectionView.okButton.tag         = 8;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.pspbPickerArray];
            break;
        case 9:
            filterSelectionView.filterLabel.text     = @"Return on Equity";
            filterSelectionView.okButton.tag         = 9;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.roePickerArray];
            break;
        case 10:
            filterSelectionView.filterLabel.text     = @"Return on Assets";
            filterSelectionView.okButton.tag         = 10;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.roePickerArray];
            break;
        case 11:
            filterSelectionView.filterLabel.text     = @"Return on Capital";
            filterSelectionView.okButton.tag         = 11;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.roePickerArray];
            break;
        case 12:
            filterSelectionView.filterLabel.text     = @"Profit Margin";
            filterSelectionView.okButton.tag         = 12;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.roePickerArray];
            break;
        case 13:
            filterSelectionView.filterLabel.text     = @"Revenue per Share";
            filterSelectionView.okButton.tag         = 13;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.pspbPickerArray];
            break;
        case 14:
            filterSelectionView.filterLabel.text     = @"Dividend Yield";
            filterSelectionView.okButton.tag         = 14;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.dividendYieldPickerArray];
            break;
        case 15:
            filterSelectionView.filterLabel.text     = @"Beta";
            filterSelectionView.okButton.tag         = 15;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.betaPickerArray];
            break;
        case 16:
            filterSelectionView.filterLabel.text     = @"50d Moving Avg";
            filterSelectionView.okButton.tag         = 16;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.pePickerArray];
            break;
        case 17:
            filterSelectionView.filterLabel.text     = @"200d Moving Avg";
            filterSelectionView.okButton.tag         = 17;
            filterArray                              = [NSMutableArray arrayWithArray:constArray.pePickerArray];
            break;
            
        default:
            
            break;
    }
    
    [filterSelectionView.okButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:filterSelectionView];
    
}

@end
