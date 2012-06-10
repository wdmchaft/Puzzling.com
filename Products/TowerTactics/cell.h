//
//  cell.h
//  Final Project
//
//  Created by Jonathan Tilley on 3/8/10.
//  Copyright 2010 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Cell : NSObject {
	int row;
	int col;
}

@property int row;
@property int col;
+(NSArray*) cellArraySerialize:(NSArray*)array;
+(NSArray*) cellArrayUnserialize:(NSArray*)array;


-(id)initWithRow: (int) r Col: (int) c;
-(id)initWithDict:(NSDictionary*)dict;
-(NSDictionary*)serialize;

@end
