//
//  FiltersViewController.h
//  Yelp
//
//  Created by Katerina Simonova on 2/16/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;

@protocol  FiltersViewControllerDelegate <NSObject>

-(void)filtersViewController:(FiltersViewController *) filtersViewController didChange: (NSDictionary *) filters;

@end

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end
