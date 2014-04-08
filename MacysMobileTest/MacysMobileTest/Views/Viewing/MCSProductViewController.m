//
//  MCSProductViewController.m
//  MacysMobileTest
//
//  Created by David Steinwedel on 4/6/14.
//  Copyright (c) 2014 David Steinwedel. All rights reserved.
//

#import "MCSProductViewController.h"
#import "MCSProduct.h"
#import "MCSProductStore.h"

@interface MCSProductViewController ()
@property (nonatomic) BOOL isEditing;
@property (nonatomic) BOOL imageIsFullscreen;
@property CGRect productImageStandardPosition;
@property CGRect productViewStandardPosition;
@property (weak) UIView *activeEditingView;
@end

@implementation MCSProductViewController
@synthesize productStore;
@synthesize product;
@synthesize productNameTextField;
@synthesize productDescriptionTextView;
@synthesize productPriceTextField;
@synthesize productSalePriceTextField;
@synthesize productImageView;
@synthesize isEditing;
@synthesize imageIsFullscreen;
@synthesize productImageStandardPosition;
@synthesize productViewStandardPosition;
@synthesize activeEditingView;
@synthesize productColorCollectionView;

#pragma mark – Initialization

- (id)initWithProduct:(MCSProduct*)prod productStore:(MCSProductStore*)store
{
    self = [self initWithNibName:nil bundle:nil productStore:store];
    if(self){
        self.product = prod;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productStore:(MCSProductStore *)store
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.productStore = store;
        isEditing = NO;
        imageIsFullscreen = NO;
    }
    return self;
}

#pragma mark – View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTouched)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    imageTap.numberOfTapsRequired = 1;
    self.productImageView.userInteractionEnabled = YES;
    [self.productImageView addGestureRecognizer:imageTap];
    [self.view bringSubviewToFront:self.productImageView];

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];

    UINib *collectionCellNib = [UINib nibWithNibName:@"MCSProductColorCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.productColorCollectionView registerNib:collectionCellNib forCellWithReuseIdentifier:@"MCSProductColorCollectionViewCell"];
    [self setUIEnabled:NO];
    [self pushProductDataToUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.productImageStandardPosition = self.productImageView.frame;
    self.productViewStandardPosition = self.view.frame;
}

#pragma mark – Private Interface

- (void)pushProductDataToUI
{
    self.productNameTextField.text = product.productName;
    self.productDescriptionTextView.text = product.productDescription;
    self.productPriceTextField.text = [self formatPrice:[NSNumber numberWithUnsignedLongLong:product.productPrice]];
    self.productSalePriceTextField.text = [self formatPrice:[NSNumber numberWithUnsignedLongLong:product.productSalePrice]];
    
    UIImage* productImage = [UIImage imageNamed:product.productPhotoName];
    self.productImageView.image = productImage;
}

#pragma mark – Bar Button Methods

- (void)editButtonTouched
{
    [self setEditing:!isEditing animated:YES];
    isEditing = !isEditing;
}

- (void)deleteButtonTouched
{
    [self.navigationController popViewControllerAnimated:YES];
    [productStore removeProductWithId:product.productId];
}

- (void)imageTapped:(UITapGestureRecognizer*)gesture
{
    NSLog(@"Image Tapped");
    if(gesture.state == UIGestureRecognizerStateEnded){
        CGRect animateToFrame = self.productImageStandardPosition;
        UIColor *animateToBackgroundColor = [UIColor whiteColor];
        if(!self.imageIsFullscreen){
            animateToFrame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            animateToBackgroundColor = [UIColor blackColor];
        }
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             self.productImageView.frame = animateToFrame;
                             self.productImageView.backgroundColor = animateToBackgroundColor;
                             [self.navigationController setNavigationBarHidden:!self.imageIsFullscreen animated:YES];
                         }
                         completion:^(BOOL finished){
                             self.imageIsFullscreen = !self.imageIsFullscreen;
                         }];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    UIColor *backgroundColor = [UIColor whiteColor];
    
    if(editing){
        backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5f];
    }
    
    [UIView animateWithDuration:0.66f
                     animations:^{
                        self.productNameTextField.backgroundColor = backgroundColor;
                        self.productDescriptionTextView.backgroundColor = backgroundColor;
                         self.productSalePriceTextField.backgroundColor = backgroundColor;
                         self.productPriceTextField.backgroundColor = backgroundColor;
                    }
                     completion:^(BOOL finished){
                         [self setUIEnabled:editing];
                     }];
    
    if(editing){
        UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonTouched)];
        UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonTouched)];
        [self.navigationItem setRightBarButtonItems:@[deleteBarButton, editBarButton] animated:YES];
        self.navigationItem.rightBarButtonItem = editBarButton;
    }
    else{
        UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTouched)];
        [self.navigationItem setRightBarButtonItem:editBarButton animated:YES];
    }

    
}

- (void)setUIEnabled:(BOOL)enabled
{
    productPriceTextField.enabled = enabled;
    productNameTextField.enabled = enabled;
    productDescriptionTextView.editable = enabled;
    productSalePriceTextField.enabled = enabled;
    productColorCollectionView.allowsSelection = enabled;
}

- (NSString*)formatPrice:(NSNumber*)price
{
    NSNumberFormatter *currencyFormatter = [self defaultNumberFormatter];
    return [currencyFormatter stringFromNumber:price];
}

- (NSNumber*)priceFromFormattedString:(NSString*)priceString
{
    NSNumberFormatter *currencyFormatter = [self defaultNumberFormatter];
    return [currencyFormatter numberFromString:priceString];
}

- (NSNumberFormatter*)defaultNumberFormatter
{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMultiplier:@.01];
    return currencyFormatter;
}

#pragma mark – Notification Handlers

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardBounds = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardBounds CGRectValue];
    
    int distanceFromKeyboardToEditingControl = CGRectGetMaxY(self.activeEditingView.frame) - CGRectGetMinY(keyboardRect);
    if(distanceFromKeyboardToEditingControl > 0){
        double animationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect newFrame = CGRectMake(CGRectGetMinX(self.view.frame),
                                     CGRectGetMinY(self.view.frame) - distanceFromKeyboardToEditingControl,
                                     CGRectGetWidth(self.view.frame),
                                     CGRectGetHeight(self.view.frame));
        
        [UIView animateWithDuration:animationTime
                         animations:^{
                             self.view.frame = newFrame;
                         }];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    if(CGRectGetMinY(self.view.frame) != CGRectGetMinY(productViewStandardPosition)){
        NSDictionary *userInfo = notification.userInfo;
        double animationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:animationTime
                         animations:^{
                             self.view.frame = productViewStandardPosition;
                         }];
    }
}

#pragma mark – UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeEditingView = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    uint64_t priceInCents = 0;
    if(textField == self.productPriceTextField || textField == self.productSalePriceTextField){
        textField.text = [self formatPrice:[NSNumber numberWithFloat:[textField.text floatValue]]];
        NSNumber *floatFromText = [self priceFromFormattedString:textField.text];
        priceInCents = [floatFromText floatValue];
    }
    
    if(textField == productSalePriceTextField){
        product.productSalePrice = priceInCents;
    }
    else if(textField == productPriceTextField){
        product.productPrice = priceInCents;
    }
    else if(textField == productNameTextField){
        product.productName = textField.text;
    }
    
    [productStore saveProduct:product];
}

#pragma mark – UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeEditingView = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    product.productDescription = textView.text;
    [productStore saveProduct:product];
}

#pragma mark – UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [product.productColors count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MCSProductColorCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [product.productColors objectAtIndex:indexPath.row];
    cell.userInteractionEnabled = YES;
    return cell;
}

#pragma mark – UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected color at index: %lu", (long)indexPath.row);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
