//
//  ZXMenuIconCollectionView.h
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  注释：collectionView菜单列表展示，每个item可以展示图标+下面文字+图标右上角的badge数字角标，可以计算出动态数量的item所需要的collectionView总高度；可以使用自定义Model数据数组+代理方法设置cell的UI数据，也可以使用默认ZXMunuIconModel+默认方法设置；

//  2018.2.11; 优化组件；



#import <UIKit/UIKit.h>
#import "ZXMenuIconCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZXMenuIconCollectionViewDelegate,ZXMenuIconCollectionViewDelegateFlowLayout;

@interface ZXMenuIconCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, weak) id<ZXMenuIconCollectionViewDelegate>delegate;
@property (nonatomic, weak) id<ZXMenuIconCollectionViewDelegateFlowLayout> flowLayoutDelegate;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionFlowLayout;

@property (nonatomic, strong) NSMutableArray *dataMArray;

// 设置collectionView的sectionInset;UIEdgeInsetsMake(15, 15, 15, 15)
@property (nonatomic, assign) UIEdgeInsets sectionInset;

// item之间的间距;默认12；
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;

// 行间距;默认12；
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/**
 *  一个屏幕显示多少列；最好小于等于4列；
 */
@property (nonatomic, assign) NSInteger columnsCount;


@property (nonatomic, assign) CGSize itemSize;

// 设置item中的Icon图标的width，height，size；

@property (nonatomic, assign) CGSize iconSize;


@property (nonatomic, strong, nullable) UIImage *placeholderImage;


// 自适应缩放宽度大小：计算出来后用于设置一个总宽度（比如屏幕宽度）下放几个的平均item宽度；
- (CGFloat)getItemAverageWidthInTotalWidth:(CGFloat)totalWidth columnsCount:(NSUInteger)count sectionInset:(UIEdgeInsets)inset minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing;



- (void)setData:(NSArray *)data;

//设置等间距对齐
//- (void)setCollectionViewLayoutWithEqualSpaceAlign:(AlignType)collectionViewCellAlignType withItemEqualSpace:(CGFloat)equalSpace animated:(BOOL)animated;
/**
 获取整个collectionView需要的高度
 
 @param data 数组
 @return 高度
 */
- (CGFloat)getCellHeightWithContentData:(NSArray *)data;
@end


@protocol ZXMenuIconCollectionViewDelegateFlowLayout <UICollectionViewDelegate>
@optional

- (CGSize)zx_menuIconCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ZXMenuIconCollectionViewDelegate <NSObject>

// 如果不实现这些协议，则会用默认的设置；

@optional
/**
 将要展示数据的时候，自定义设置cell的显示；不影响布局的外观设置
 
 @param cell LabelCell
 @param indexPath collectionView中的对应indexPath
 */
- (void)zx_menuIconView:(ZXMenuIconCollectionView *)menuIconView willDisplayCell:(ZXMenuIconCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;


// 代理方法设置cell的数据；
- (void)zx_menuIconView:(ZXMenuIconCollectionView *)menuIconView cell:(ZXMenuIconCell *)cell forItemSetData:(id)data cellForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 自定义 点击添加cell事件回调
 
 @param collectionView collectionView description
 @param indexPath indexPath description
 */
- (void)zx_menuIconView:(ZXMenuIconCollectionView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END


//举例1
/*
#import "BaseTableViewCell.h"
#import "ZXMenuIconCollectionView.h"

@interface MessageStackViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet ZXMenuIconCollectionView *menuIconCollectionView;

@end

*/

/*
@implementation MessageStackViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.menuIconCollectionView.columnsCount = 3;
     self.menuIconCollectionView.minimumInteritemSpacing = 15.f;
 
     CGFloat width = [self.menuIconCollectionView getItemAverageWidthInTotalWidth:LCDW columnsCount:self.menuIconCollectionView.columnsCount sectionInset:self.menuIconCollectionView.sectionInset minimumInteritemSpacing:self.menuIconCollectionView.minimumInteritemSpacing];
     self.menuIconCollectionView.itemSize = CGSizeMake(width,width-LCDScale_iPhone6_Width(20));
 
     self.menuIconCollectionView.placeholderImage = AppPlaceholderImage;
    
}


 - (void)setData:(id)data
 {
     NSArray *dataArray = (NSArray *)data;
     NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:dataArray.count];
     [data enumerateObjectsUsingBlock:^(MessageModelSub *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     
     ZXMenuIconModel *model = [[ZXMenuIconModel alloc] init];
     model.icon = obj.typeIcon;
     model.title = obj.typeName;
     if (obj.num>0) {
     model.sideMarkType = SideMarkType_number;
     }else{
     model.sideMarkType = SideMarkType_none;
     }
     model.sideMarkValue = [NSString stringWithFormat:@"%@",@(obj.num)];
     [mArray addObject:model];
     }];
     [self.menuIconCollectionView setData:mArray];
 }

- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{
    return [self.menuIconCollectionView getCellHeightWithContentData:data];
}
@end
 */


