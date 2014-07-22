//
//  SecretPhotosLibCollectionViewController.m
//  私人相册
//
//  Created by Qiqingnan on 14-7-1.
//  Copyright (c) 2014年 qingnan qi. All rights reserved.
//

#import "SecretPhotosLibCollectionViewController.h"
#import "DoImagePickerController.h"
#import "AssetHelper.h"
#import <CoreData/CoreData.h>
#import "Photo.h"
#import "UICollectionViewWaterfallLayout.h"
#import "PageViewControllerData.h"
#import "MyPageViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define COLLECTION_CELL_WEITH 158
#define COLLECTION_COLUMN_COUNT 2

@interface SecretPhotosLibCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateWaterfallLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backgrondBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSMutableArray *chosenPhotos;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *cellHeights;
@property (nonatomic, strong) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *takePicButton;
@property (weak, nonatomic) IBOutlet UIButton *alumBotton;
@property (strong, nonatomic) SLComposeViewController *slComposerSheet;


@end

@implementation SecretPhotosLibCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.imageView.image = nil;
    [self.navigationController setNavigationBarHidden:NO];
    self.backgrondBtn.alpha = 0.98;
    self.takePicButton.alpha = 1;
    self.alumBotton.alpha = 1;
    [self.imageView removeFromSuperview];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}
-(void)viewWillDisappear:(BOOL)animated
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.mainCollectionView.contentSize.width+50, self.mainCollectionView.contentSize.height + 50)];
    _imageView.image = [UIImage imageNamed:@"Default.png"];
    [self.mainCollectionView addSubview:_imageView];
    [self.mainCollectionView bringSubviewToFront:_imageView];
    self.backgrondBtn.alpha = 0;
    self.takePicButton.alpha = 0;
    self.alumBotton.alpha = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.labelView setBackgroundColor:DO_MENU_BACK_COLOR];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    layout.columnCount = COLLECTION_COLUMN_COUNT;
    layout.itemWidth = COLLECTION_CELL_WEITH;
    layout.delegate = self;
    self.mainCollectionView.collectionViewLayout = layout;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self initCollectionData];
}

-(void)initCollectionData
{
    self.photos = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO selector:@selector(localizedStandardCompare:)]];
    self.photos = [NSArray arrayWithArray:[self.context executeFetchRequest:request error:nil]];
    
}
- (NSManagedObjectModel *)createManagedModel
{
    NSManagedObjectModel *managedObjectModel = nil;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Photo" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    NSError *error = nil;
    // 添加数据存储
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // 创建一个SQLite数据库作为数据存储
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:@"datastore.sqlite"];
    NSURL *databaseURL = [NSURL fileURLWithPath:filePath];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self createManagedModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseURL options:nil error:&error]) {
        NSLog(@"error = %@ %@",error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}

- (NSURL *)applicationDocmentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext *)context
{
    if (!_context) {
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [self createPersistentStoreCoordinator];
        if (persistentStoreCoordinator) {
            _context = [[NSManagedObjectContext alloc] init];
            [_context setPersistentStoreCoordinator:persistentStoreCoordinator];
        }
    }
    return _context;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - addPhotosMethod

- (IBAction)pickImagesFromLib:(id)sender {
    DoImagePickerController *cont = [[DoImagePickerController alloc] initWithNibName:@"DoImagePickerController" bundle:nil];
    cont.delegate = self;
    cont.nResultType = DO_PICKER_RESULT_UIIMAGE;
    cont.nMaxCount = DO_NO_LIMIT_SELECT;
    cont.nResultType = DO_PICKER_RESULT_ASSET;
    cont.nColumnCount = 4;
    [self presentViewController:cont animated:YES completion:nil];
}

+ (BOOL)canAddPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            return YES;
        }
    }
    return NO;
}
- (IBAction)takePhoto:(id)sender {
    if (![SecretPhotosLibCollectionViewController canAddPhoto]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"此设备相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
    [uiipc setDelegate:self];
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    uiipc.allowsEditing = NO;
    [self presentViewController:uiipc animated:YES completion:NULL];

}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    dispatch_queue_t savesQ = dispatch_queue_create("savesQ",NULL);
    dispatch_async(savesQ, ^{
            UIImage *image = info[UIImagePickerControllerEditedImage];
            if (!image) image = info[UIImagePickerControllerOriginalImage];
            image = [self scaleImage:image toScale:0.4];
            float rate=(COLLECTION_CELL_WEITH/image.size.width);
            [self.cellHeights insertObject:@(image.size.height*rate) atIndex:0];
            NSDate *imageDate = [NSDate date];
            NSString *dataToString = [NSString stringWithFormat:@"%@",imageDate];
            NSString *imagePath =[self saveImageToDocument:image andImageName:dataToString];
            [self saveImageToDatabase:imagePath andImageName:dataToString];//照片信息存入数据库
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initCollectionData];
            [self.mainCollectionView reloadData];
            [ASSETHELPER clearData];
        });
    });
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - DoImagePickerControllerDelegate

- (void)didCancelDoImagePickerController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.nResultType == DO_PICKER_RESULT_UIIMAGE)
    {
        NSLog(@"DO_PICKER_RESULT_UIIMAGE");
        [self.chosenPhotos addObjectsFromArray:aSelected];
    }
    else if (picker.nResultType == DO_PICKER_RESULT_ASSET)
    {
        dispatch_queue_t saveQ = dispatch_queue_create("saveQ",NULL);
        dispatch_async(saveQ, ^{
            for (int i = 0; i < aSelected.count; i++)
            {
                
                UIImage *image = [ASSETHELPER getImageFromAsset:aSelected[i] type:ASSET_PHOTO_SCREEN_SIZE];
                float rate=(COLLECTION_CELL_WEITH/image.size.width);
                
                [self.cellHeights insertObject:@(image.size.height*rate) atIndex:0];
                
                NSDate *imageDate = [aSelected[i] valueForProperty:ALAssetPropertyDate]; //数据库检索图片根据时间先后
                NSString *dataToString = [NSString stringWithFormat:@"%@",imageDate]; //同一张照片一样，那么数据库检索条件一样日期也一样，
                NSString *imagePath =[self saveAssetToDocument:aSelected[i]];
                [self saveImageToDatabase:imagePath andImageName:dataToString];//照片信息存入数据库
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initCollectionData];
                [self.mainCollectionView reloadData];
                [ASSETHELPER clearData];
            });
        });
    }
}

-(void)saveImageToDatabase:(NSString *)url andImageName:(NSString *)name
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"    inManagedObjectContext:self.context];
    photo.imageURL = url;
    photo.name = name;
    photo.date = [NSDate date];
    NSError *error = nil;
    [self.context save:&error];
    if (![self.context save:&error]) {
        NSLog(@"%@ %@",error, [error userInfo]);
        abort();
    }
}

-(NSString *)saveAssetToDocument:(ALAsset *)asset
{
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDate *date = [NSDate date];
    NSString *dateString = [NSString stringWithFormat:@"%@",date];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[representation filename], dateString]];
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSOutputStream *outPutStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    
    [outPutStream open];
    
    long long offset = 0;
    long long bytesRead = 0;
    
    NSError *error;
    uint8_t * buffer = malloc(131072);
    while (offset<[representation size] && [outPutStream hasSpaceAvailable]) {
        bytesRead = [representation getBytes:buffer fromOffset:offset length:131072 error:&error];
        [outPutStream write:buffer maxLength:bytesRead];
        offset = offset+bytesRead;
    }
    [outPutStream close];
    free(buffer);
    return filePath;
}

-(NSString *)saveImageToDocument:(UIImage *)image andImageName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager createFileAtPath:filePath contents:data attributes:nil]) {
        return filePath;
    } else {
        return nil;
    }
}

-(void)deleteObjectInDatabase:(NSIndexPath *)indexPath
{
    Photo *photo = self.photos[indexPath.row];
    [self.cellHeights removeObjectAtIndex:indexPath.row];
    self.photos = nil;
    dispatch_queue_t deleteQ = dispatch_queue_create("deleteQ",NULL);
    dispatch_async(deleteQ, ^{
        if ([[NSFileManager defaultManager] fileExistsAtPath:photo.imageURL]) {
            [[NSFileManager defaultManager] removeItemAtPath:photo.imageURL error:NULL];
        }
        [self.context deleteObject:photo];
        NSError *error = nil;
        [self.context save:&error];
        if (![self.context save:&error]) {
            NSLog(@"%@ %@",error, [error userInfo]);
            abort();
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initCollectionData];
        [self.mainCollectionView reloadData];
        [ASSETHELPER clearData];
        });
    });
    
}

-(UIImage *)getImageFromPhotosAtIndex:(NSIndexPath *)indexPath
{
    Photo *photo = self.photos[indexPath.row];
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:photo.imageURL]];
}

-(void)sharePicWithIndexPath:(NSIndexPath *)index
{
    [self.slComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        }
        if (result != SLComposeViewControllerResultCancelled)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Weibo Message" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
    {
        self.slComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [self.slComposerSheet setInitialText:@"#我的小秘密#"];
        [self.slComposerSheet addImage:[self getImageFromPhotosAtIndex:index]];
        [self.slComposerSheet addURL:[NSURL URLWithString:@"http://www.weibo.com/"]];
        [self presentViewController:self.slComposerSheet animated:YES completion:^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            [self performSelector:@selector(endNetWorkActivity) withObject:nil afterDelay:2.0f];
        }];
    }

}
-(void)beginNetWorkActivity
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self performSelector:@selector(endNetWorkActivity) withObject:nil afterDelay:2.0f];
}

-(void)endNetWorkActivity
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return scaledImage;
    
}
#pragma mark - UICollectionViewDelegates for photos
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[self.mainCollectionView dequeueReusableCellWithReuseIdentifier:@"photo cell" forIndexPath:indexPath];
    __block UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = [self getImageFromPhotosAtIndex:indexPath];
    return cell;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIMenuItem* delete = [[UIMenuItem alloc] initWithTitle:@"删除"
                                                action:NSSelectorFromString(@"deletePic:")];
    UIMenuItem* share = [[UIMenuItem alloc] initWithTitle:@"分享"
                                                action:NSSelectorFromString(@"share:")];
    [[UIMenuController sharedMenuController] setMenuItems:@[share, delete]];
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"deletePic:"] || [NSStringFromSelector(action) isEqualToString:@"share:"])
    return YES;
    return NO;
}
-(void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"deletePic:"]) {
        [self deleteObjectInDatabase:indexPath];
    } else if([NSStringFromSelector(action) isEqualToString:@"share:"]){
        [self sharePicWithIndexPath:indexPath];
    }
    
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate

- (NSMutableArray *)cellHeights
{
    if (!_cellHeights) {
        _cellHeights = [[NSMutableArray alloc] initWithCapacity:self.photos.count];
        for (NSInteger i = 0; i < self.photos.count; i++) {
            Photo *photo = self.photos[i];
            float rate;
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:photo.imageURL]];
            rate=(COLLECTION_CELL_WEITH/image.size.width);
            _cellHeights[i] = @(image.size.height*rate);
        }
    }
    return _cellHeights;
}

-(void)reloadCellHeights
{
    _cellHeights = nil;
    _cellHeights = [[NSMutableArray alloc] initWithCapacity:self.photos.count];
    for (NSInteger i = 0; i < self.photos.count; i++) {
        Photo *photo = self.photos[i];
        float rate;
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:photo.imageURL]];
        rate=(COLLECTION_CELL_WEITH/image.size.width);
        _cellHeights[i] = @(image.size.height*rate);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeights[indexPath.row] floatValue];
}

#pragma mark - Segue support

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showPhoto"]) {
        // hand off the assets of this album to our singleton data source
        [PageViewControllerData sharedInstance].photos = self.photos;
        // start viewing the image at the appropriate cell index
        MyPageViewController *pageViewController = [segue destinationViewController];
        NSIndexPath *selectedCell = [self.mainCollectionView indexPathsForSelectedItems][0];
        pageViewController.startingIndex = selectedCell.row;
    }
}

@end
