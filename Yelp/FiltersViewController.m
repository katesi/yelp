//
//  FiltersViewController.m
//  Yelp
//
//  Created by Katerina Simonova on 2/16/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

typedef NS_ENUM(NSInteger, Sections) {
    SectionDeals,
    SectionDistances,
    SectionGeneralFeatures,
    SectionCategories
    
};

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, readonly) NSDictionary *filters;

@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSArray* distances;
@property (nonatomic, strong) NSArray* sortBys;
@property (nonatomic, strong) NSArray* generalFeatures;

@property (nonatomic, strong) NSMutableSet* selectedCategories;
@property (nonatomic, strong) NSMutableSet* selectedDistances;
@property (nonatomic, strong) NSMutableSet* selectedSortBys;
@property (nonatomic, strong) NSMutableSet* selectedGeneralFeatures;


- (void) initCategories;

@end

@implementation FiltersViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        self.selectedDistances = [NSMutableSet set];
        self.selectedSortBys = [NSMutableSet set];
        self.selectedGeneralFeatures = [NSMutableSet set];
        
        [self initAllFilters];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SectionCategories) {
        return self.categories.count;
    } else if (section == SectionDeals) {
        return self.generalFeatures.count;
    } else if (section == SectionDistances) {
        return self.distances.count;
    } else {
        return self.sortBys.count;
    }
        
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == SectionCategories) {
        return @"Food Categories";
    } else if (section == SectionDeals) {
        return @"General Filters";
    } else if (section == SectionDistances) {
        return @"Distance";
    } else {
        return @"Sort by";
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SectionCategories) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
        cell.titleLabel.text = self.categories[indexPath.row][@"name"];
        cell.delegate = self;
        return cell;

    } else if (indexPath.section == SectionDeals) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.on = [self.selectedGeneralFeatures containsObject:self.categories[indexPath.row]];
        cell.titleLabel.text = self.generalFeatures[indexPath.row][@"label"];
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == SectionDistances) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.on = [self.selectedDistances containsObject:self.categories[indexPath.row]];
        cell.titleLabel.text = self.distances[indexPath.row][@"label"];
        cell.delegate = self;
        return cell;

    } else {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.on = [self.selectedSortBys containsObject:self.categories[indexPath.row]];
        cell.titleLabel.text = self.sortBys[indexPath.row][@"label"];
        cell.delegate = self;
        return cell;

    }
   
}

#pragma mark - Switch cell delegate methods
- (void) switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == SectionCategories) {
        if (value) {
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
    } else if (indexPath.section == SectionDeals) {
        if (value) {
            [self.selectedGeneralFeatures addObject:self.generalFeatures[indexPath.row]];
        } else {
            [self.selectedGeneralFeatures removeObject:self.generalFeatures[indexPath.row]];
        }
    } else if (indexPath.section == SectionDistances) {
        if (value) {
            [self.selectedDistances addObject:self.distances[indexPath.row]];
        } else {
            [self.selectedDistances removeObject:self.distances[indexPath.row]];
        }
        
    } else {
        if (value) {
            [self.selectedSortBys addObject:self.sortBys[indexPath.row]];
        } else {
            [self.selectedSortBys removeObject:self.sortBys[indexPath.row]];
        }

    }

}

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        
        for (NSDictionary *distance in self.selectedDistances) {
            [names addObjectsFromArray:distance[@"id"]];
        }
        
        for (NSDictionary* sortBy in self.selectedSortBys) {
            [names addObjectsFromArray:sortBy[@"id"]];
        }
        
        for (NSDictionary* generalFilter in self.selectedGeneralFeatures) {
            [names addObjectsFromArray:generalFilter];
        }
        
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    return filters;
}

#pragma mark - Private methods
- (void) onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyButton {
    [self.delegate filtersViewController:self didChange:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) initAllFilters {
    
    self.categories =
      @[
          @{@"name" : @"Afgan", @"code" : @"afgani"},
          @{@"name":  @"African", @"code" : @"african" },
          @{@"name" : @"American (New)", @"code" : @"newamerican"},
          @{@"name" : @"American (Traditional)", @"code" : @"tradamerican"},
          @{@"name" : @"Argentine", @"code" : @"argentine"},
          @{@"name" : @"Asian Fusion", @"code" : @"asianfusion"},
          @{@"name" : @"Australian", @"code" : @"australian"},
          @{@"name" : @"Barbeque", @"code" : @"bbq"},
          @{@"name" : @"Breakfast & Brunch", @"code" : @"breakfast_brunch"},
          @{@"name" : @"British", @"code" : @"british"},
          @{@"name" : @"Buffets", @"code" : @"buffets"},
          @{@"name" : @"Burgers", @"code" : @"burgers"},
          @{@"name" : @"Cafes", @"code" : @"cafes"},
          @{@"name" : @"Cambodian", @"code" : @"cambodian"},
          @{@"name" : @"Canadian (New)", @"code" : @"newcanadian"},
          @{@"name" : @"Comfort Food", @"code" : @"comfortfood"},
          @{@"name" : @"Fast Food", @"code" : @"hotdogs"},
          @{@"name" : @"German", @"code" : @"german"},
          @{@"name" : @"Indian", @"code" : @"indpak"},
          @{@"name" : @"Japanese", @"code" : @"japanese"},
          @{@"name" : @"Korean", @"code" : @"korean"},
          @{@"name" : @"Mexican", @"code" : @"mexican"},
          @{@"name" : @"Russian", @"code" : @"russian"},
          @{@"name" : @"Salad", @"code" : @"salad"},
          @{@"name" : @"Sandwiches", @"code" : @"sandwiches"},
          @{@"name" : @"Taiwanese", @"code" : @"taiwanese"},
          @{@"name" : @"Soup", @"code" : @"soup"},
          @{@"name" : @"Vietnamese", @"code" : @"vietnamese"},
          @{@"name" : @"Wraps", @"code" : @"wraps"}
      ];
    
    self.distances = @[
                                                                                                  @{@"id": @"2_blocks", @"enabled": @(NO), @"label": @"2 blocks", @"api_value": @"160"},
                                                                                                  @{@"id": @"6_blocks", @"enabled": @(NO), @"label": @"6 blocks", @"api_value": @"480"},
                                                                                                  @{@"id": @"1_miles", @"enabled": @(NO), @"label": @"1 mile", @"api_value": @"1609"},
                                                                                                  @{@"id": @"5_miles", @"enabled": @(NO), @"label": @"5 miles", @"api_value": @"8046"},
                                                                                                  ];

    
    self.sortBys = @[
                     @{@"id": @"best_match", @"enabled": @(NO), @"label": @"Best Match", @"api_value": @"0"},
                     @{@"id": @"distance", @"enabled": @(NO), @"label": @"Distance", @"api_value": @"1"},
                     @{@"id": @"rating", @"enabled": @(NO), @"label": @"Rating", @"api_value": @"2"},
                     ];
    
    self.generalFeatures = @[
                             @{@"id": @"deals", @"enabled": @(NO), @"label": @"Deals", @"api_value": @"1"},
                             ];
    

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
