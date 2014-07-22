//
//  DoImagePickerController.h
//  DoImagePickerController
//
//  Created by Donobono on 2014. 1. 23..
//

#import <UIKit/UIKit.h>

@interface DoImagePickerController : UIViewController

@property (assign, nonatomic) id            delegate;

@property (readwrite)   NSInteger           nMaxCount;      // -1 : no limit
@property (readwrite)   NSInteger           nColumnCount;   // 2, 3, or 4
@property (readwrite)   NSInteger           nResultType;    // default : DO_PICKER_RESULT_UIIMAGE

@property (weak, nonatomic) IBOutlet UICollectionView   *cvPhotoList;
@property (weak, nonatomic) IBOutlet UITableView        *tvAlbumList;
@property (weak, nonatomic) IBOutlet UIView             *vDimmed;//展示图片的view


// init
- (void)initControls;
- (void)readAlbumList:(BOOL)bFirst;

// bottom menu
@property (weak, nonatomic) IBOutlet UIView             *vBottomMenu;
@property (weak, nonatomic) IBOutlet UIButton           *btSelectAlbum; //选择图片按钮
@property (weak, nonatomic) IBOutlet UIButton           *btOK; //对号按钮
@property (weak, nonatomic) IBOutlet UIImageView        *ivLine1; //左分割线
@property (weak, nonatomic) IBOutlet UIImageView        *ivLine2; //右分割线
@property (weak, nonatomic) IBOutlet UILabel            *lbSelectCount; //选择数
@property (weak, nonatomic) IBOutlet UIImageView        *ivShowMark;//小箭头

- (void)initBottomMenu;
- (IBAction)onSelectPhoto:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSelectAlbum:(id)sender;
- (void)hideBottomMenu;


// side buttons
@property (weak, nonatomic) IBOutlet UIButton           *btUp;
@property (weak, nonatomic) IBOutlet UIButton           *btDown;

- (IBAction)onUp:(id)sender;
- (IBAction)onDown:(id)sender;


// photos
@property (strong, nonatomic)   UIImageView             *ivPreview;//展示图片的imageview

- (void)showPhotosInGroup:(NSInteger)nIndex;    // nIndex : index in album array
- (void)showPreview:(NSInteger)nIndex;          // nIndex : index in photo array
- (void)hidePreview;


// select photos
@property (strong, nonatomic)   NSMutableDictionary     *dSelected;
@property (strong, nonatomic)	NSIndexPath				*lastAccessed;

@end

@protocol DoImagePickerControllerDelegate

- (void)didCancelDoImagePickerController;
- (void)didSelectPhotosFromDoImagePickerController:(DoImagePickerController *)picker result:(NSArray *)aSelected;

@end
