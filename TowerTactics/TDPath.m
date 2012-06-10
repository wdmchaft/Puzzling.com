//
//  TDPath.m
//  Final Project
//
//  Created by Jonathan Tilley on 3/8/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import "TDPath.h"


@implementation TDPath
-(id)initWithPList: (NSString*) plist{
	if(self = [super init]){
		cells = [[NSMutableArray alloc] init];
		NSBundle * bundle = [NSBundle mainBundle];
		NSArray * data = [NSArray arrayWithContentsOfFile:[bundle pathForResource:plist ofType:@"plist"]];
		for(NSDictionary * dict in data){
			Cell * c = [[Cell alloc] initWithRow:[[dict valueForKey:@"row"] intValue]
											 Col:[[dict valueForKey:@"col"] intValue]];
			[cells addObject:c];
			[c release];
		}
	}
	return self;
}


-(id)initWithCells:(NSArray*)c{
    if(self = [super init]){
        cells = [c mutableCopy];
    }
    return self;
}

-(NSArray *) getCells{
	return [NSArray arrayWithArray:cells];
}

-(void) dealloc{
	[cells release];
	[super dealloc];
}
@end
