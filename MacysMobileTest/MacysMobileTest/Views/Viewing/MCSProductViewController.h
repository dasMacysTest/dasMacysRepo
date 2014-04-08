//
//  MCSProductViewController.h
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/6/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSViewControllerInterface.h"

@class MCSProduct;

@interface MCSProductViewController : UIViewController<MCSViewControllerInterface, UITextFieldDelegate, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property MCSProduct *product;
@property (weak) IBOutlet UITextField *productNameTextField;
@property (weak) IBOutlet UITextView *productDescriptionTextView;
@property (weak) IBOutlet UITextField *productPriceTextField;
@property (weak) IBOutlet UITextField *productSalePriceTextField;
@property (weak) IBOutlet UIImageView *productImageView;
@property (weak) IBOutlet UICollectionView *productColorCollectionView;

- (id)initWithProduct:(MCSProduct*)product productStore:(MCSProductStore*)store;

@end
