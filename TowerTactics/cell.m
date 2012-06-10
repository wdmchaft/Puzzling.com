//
//  cell.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/8/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import "cell.h"


@implementation Cell
@synthesize row, col;
-(id)initWithRow: (int) r Col: (int) c{
	if(self = [super init]){
		self.row = r;
		self.col = c;
	}
	return self;
}

-(id)initWithDict:(NSDictionary*)dict{
    if(self = [super init]){
		self.row = [[dict objectForKey:@"row"] intValue];
		self.col = [[dict objectForKey:@"col"] intValue];
	}
	return self;
}


+(NSArray*) cellArraySerialize:(NSArray*)array{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:[array count]];
    for(Cell* cell in array)
        [result addObject:[cell serialize]];
    return result;
}

+(NSArray*) cellArrayUnserialize:(NSArray*)array{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:[array count]];
    for(NSDictionary* cellDict in array)
        [result addObject:[[[Cell alloc] initWithDict:cellDict]autorelease]];
    return result;
}


-(NSDictionary*)serialize{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%d",self.row], @"row",
            [NSString stringWithFormat:@"%d",self.col], @"col",
            nil];
}

@end
