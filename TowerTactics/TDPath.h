//
//  TDPath.h
//  Final Project
//
//  Created by Jonathan Tilley on 3/8/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cell.h"

@interface TDPath : NSObject {
	NSMutableArray * cells;
}

-(id)initWithPList: (NSString*) plist;
-(id)initWithCells:(NSArray*)cells;
-(NSArray *) getCells;
@end
