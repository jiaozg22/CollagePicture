//
//  TemplateListController.h
//  CollagePicture
//
//  Created by simon on 16/9/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateListController : UICollectionViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *testBarItem;

- (IBAction)shareTestAction:(UIBarButtonItem *)sender;
@end
