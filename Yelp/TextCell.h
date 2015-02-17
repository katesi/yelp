//
//  TextCell.h
//  Yelp
//
//  Created by Katerina Simonova on 2/17/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TextCell;

@protocol TextCellDelegate <NSObject>
- (void) textCell:(TextCell *)cell didUpdateValue:(NSString *)value;
@end

@interface TextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (nonatomic, weak) id<TextCellDelegate> delegate;


@end
