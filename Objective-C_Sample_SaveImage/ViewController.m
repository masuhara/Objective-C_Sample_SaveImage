//
//  ViewController.m
//  Objective-C_Sample_SaveImage
//
//  Created by Master on 2015/01/31.
//  Copyright (c) 2015年 net.masuhara. All rights reserved.
//
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController {
    
    // Models
    UIImage *stampImage;
    UIImage *rawImage;
    NSMutableArray *stampArray;
    
    // Views
    IBOutlet UIImageView *imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init
    stampImage = [UIImage imageNamed:@"Octocat.png"];
    stampArray = [NSMutableArray new];
    
    imageView.image = [UIImage imageNamed:@"placeholder.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Private

- (IBAction)clearStamps:(id)sender {
    if(imageView.subviews.count > 0)
    {
        int numberOfSubviews = (int)imageView.subviews.count;
        for (int i = 0; i < numberOfSubviews; i++) {
            UIImageView *stamp = stampArray[i];
            [stamp removeFromSuperview];
        }
    }
}

- (IBAction)selectMainImage:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //ipc.allowsEditing = YES;
    ipc.allowsEditing = NO;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (IBAction)saveImageToPhotoLibrary {
    #warning 画質調整ポイント①
    CGRect rect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    //CGRect rect = CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height);
    
    // This Option(last value) is very important for Quority of Photo
#warning 画質調整ポイント②
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    // Decide layer to save
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Get PNG Image Data
#warning 画質調整ポイント③
    NSData *pngData = UIImagePNGRepresentation(UIGraphicsGetImageFromCurrentImageContext());
    //UIImage *jpgImage = UIGraphicsGetImageFromCurrentImageContext();
    //NSData *jpgData = UIImageJPEGRepresentation(jpgImage, 1.0);
    UIImage *captureImage = [UIImage imageWithData:pngData];
    
    // End Context
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(captureImage, nil, nil, nil);
    UIGraphicsEndImageContext();
    
    // Alert
    if (captureImage) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存完了" message:@"保存に成功しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:imageView];
    UIImageView *stampImageView = [[UIImageView alloc] initWithImage:stampImage] ;
    stampImageView.center = CGPointMake(location.x, location.y) ;
    stampArray[imageView.subviews.count] = stampImageView;
    [imageView addSubview:stampImageView];
}



#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
#warning 画質調整ポイント④
    imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];

}

@end
