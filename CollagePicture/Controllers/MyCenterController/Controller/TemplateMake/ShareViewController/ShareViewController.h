//
//  ShareViewController.h
//  CollagePicture
//
//  Created by 朱新明 on 16/10/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UICollectionViewController

@property (nonatomic,strong)UIImage *shareImage;

- (IBAction)shareAction:(UIBarButtonItem *)sender;

@end
