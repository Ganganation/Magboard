//
//  OrderSingleton.h
//  MagBoard
//
//  Created by Leo Flapper on 05-11-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderSingleton : NSObject
{
    NSString *orderId;
}

@property (nonatomic, retain) NSString *orderId;

+ (id)orderSingleton;
@end
