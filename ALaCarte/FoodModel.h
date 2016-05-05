//
//  FoodModel.h
//  ALaCarte
//
//  Created by Shane Rosse on 5/4/15.
//  Copyright (c) 2015 Shane Rosse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodModel : NSObject

+ (instancetype) sharedModel;
- (NSString*) setLabel;
- (NSString*) setLabelToNext;
- (NSString*) currentPlace;
- (NSUInteger*) favLength;
- (void) addToFav;

@property (nonatomic, strong) NSMutableArray *favPlaces;
@property (nonatomic, strong) NSMutableArray *favURLs;
@property (nonatomic) NSUInteger* loaded;


@end
