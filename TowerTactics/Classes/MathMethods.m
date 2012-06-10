/*
 *  ConvenienceMethods.h
 *  Final Project
 *
 *  Created by Jonathan Tilley on 3/8/10.
 *  Copyright 2010 Stanford. All rights reserved.
 *
 */
#ifndef __CONVENIENCE__

#define __CONVENIENCE__

int max(int a, int b){
	return (a < b) ? b : a;
}

int min(int a, int b){
	return (a < b) ? a : b;
}
int distance(int x1, int y1, int x2, int y2){
	return (int)sqrt((double)((x1 -x2)*(x1 -x2)) + ((y1 -y2)*(y1 -y2)));
}

int gridSnap(int val){
	return (int)(val / 40);
}
int unsnap(int val){
	return val * 40;
}



#endif