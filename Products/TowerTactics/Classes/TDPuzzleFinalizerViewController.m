//
//  TDPuzzleFinalizer.m
//  TowerTactics
//
//  Created by Jonathan Tilley on 6/3/12.
//  Copyright (c) 2012 Fresh Cookies LLC. All rights reserved.
//

#import "TDPuzzleFinalizerViewController.h"
#import "PuzzleSDK.h"

@implementation TDPuzzleFinalizerViewController
@synthesize enemies,cells, name,slider,moneyLabel;

- (void)viewDidLoad
{
    [self.name setReturnKeyType:UIReturnKeyDone];
    [self.name addTarget:self
                       action:@selector(textEntered)
             forControlEvents:UIControlEventEditingDidEndOnExit];
    [super viewDidLoad];
}

-(IBAction)textEntered{
    self.nextButton.enabled = name.text.length > 0;
}

-(IBAction)sliderMoved:(id)sender {
    
    moneyLabel.text = [NSString stringWithFormat:@"%d", (int)slider.value];
}

-(IBAction)next{
    PuzzleSDK* sdk = [PuzzleSDK sharedInstance];
    NSMutableDictionary* setupData = [NSMutableDictionary dictionaryWithCapacity:2];
    [setupData setObject:self.cells forKey:@"cells"];
    [setupData setObject:self.enemies forKey:@"enemies"];
    [setupData setObject:[NSString stringWithFormat:@"%d", (int)self.slider.value] forKey:@"money"];

    [sdk createPuzzleWithType:@"TowerDefense" name:self.name.text setupData:setupData solutionData:nil isUpdate:nil onCompletionBlock:^(PuzzleAPIResponse response, id data) {
        if(response != PuzzleOperationSuccessful)
            [PuzzleErrorHandler presentErrorForResponse:response];

    }];
}

@end
