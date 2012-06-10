//
//  TDEnemyChooserViewController.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 5/19/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDEnemyChooserViewController.h"
#import "TDPathCreationViewController.h"

@implementation TDEnemyChooserViewController
@synthesize pauseTimeLabel, enemies,selectedEnemy, pauseTimeSlider, enemyTable;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.enemies = [NSMutableArray array];
    }
    return self;
}

-(void) viewDidLoad{
    self.enemyTable.backgroundColor = [UIColor clearColor];
}

-(IBAction)sliderMoved:(id)sender {

    UISlider* slider = sender;
    pauseTimeLabel.text = [NSString stringWithFormat:@"%d", (int)slider.value];
}


-(IBAction)next {
   
    TDPathCreationViewController* mv = (TDPathCreationViewController*)self.nextPage;
    if(!mv){
        mv = [[TDPathCreationViewController alloc] initWithNibName:@"TDPathCreationViewController" bundle:[NSBundle mainBundle]];
        self.nextPage = mv;
        [mv autorelease];
    }
    mv.introPage = self;
    mv.enemies = self.enemies;
    [self presentModalViewController:self.nextPage animated:NO];
}


-(IBAction)addEnemy{
    [self.nextButton setEnabled:YES];
    int type = [selectedEnemy selectedSegmentIndex];
    int pauseTime = pauseTimeSlider.value;
    NSLog(@"%d",pauseTime);
    NSDictionary* enemyDict = [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithInt: type], @"enemyType",
     [NSNumber numberWithFloat:1.5], @"enemyMovement",
     [NSNumber numberWithInt:20], @"enemyHealth",
     [NSNumber numberWithInt:pauseTime], @"pauseTime", 
     nil];
    [self.enemies addObject:enemyDict];
    [self.view setNeedsLayout];
    [self.enemyTable reloadData];

}

/////////////////////////////////////////////
//      UITABLE VIEW DATASOURCE METHODS    //
/////////////////////////////////////////////

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.enemies.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = [indexPath row];
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%d", index]];
    cell.textLabel.text = [NSString stringWithFormat:@"enemy %d",[[[self.enemies objectAtIndex:index] objectForKey:@"enemyType"] intValue]];
    cell.textLabel.font = [UIFont fontWithName:@"Eraser" size:16];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}
@end
