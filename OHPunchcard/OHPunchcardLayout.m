//
//  OHPunchcardLayout.m
//  OHPunchcard
//
//  Created by Oskar Hagberg on 2013-05-16.
//  Copyright (c) 2013 Oskar Hagberg. All rights reserved.
//

#import "OHPunchcardLayout.h"

NSString *const OHPunchcardElementKindRowTitle = @"OHPunchcardElementKindRowTitle";

@implementation OHPunchcardLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{

}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* originalAttributes = [super layoutAttributesForElementsInRect:rect];
    
    id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    CGSize headerSize = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:0];
    CGFloat padding = self.minimumInteritemSpacing;
    CGFloat cellHeight = self.itemSize.height;
    CGFloat inset = self.sectionInset.left;
    CGFloat y = floorf(headerSize.height - cellHeight/2.0);
    
    NSInteger sections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    NSMutableArray* attributes = [NSMutableArray array];
    
    // NOTE: This is not optimized for a large amount of sections. The assumptions is that all sections
    // fit inside the rect, ~12 total
    for (int section = 0; section < sections; section++) {
        UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:OHPunchcardElementKindRowTitle withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        
        attr.zIndex = 10;
        attr.frame = CGRectMake(padding, y, inset - padding * 4, cellHeight);
        y+= cellHeight + padding;
        
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [attributes addObject:attr];
        }
        
    }
    
    [attributes addObjectsFromArray:originalAttributes];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([OHPunchcardElementKindRowTitle isEqualToString:kind]) {
        // TODO: make this DRY
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
        CGSize headerSize = [delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:0];
        CGFloat padding = self.minimumInteritemSpacing;
        CGFloat cellHeight = self.itemSize.height;
        CGFloat inset = self.sectionInset.left;
        CGFloat y = floorf(headerSize.height - cellHeight/2.0) + indexPath.section * (cellHeight + padding);
        UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
        
        attr.zIndex = 10;
        attr.frame = CGRectMake(padding, y, inset - padding * 4, cellHeight);
        y+= cellHeight + padding;
        
        return attr;
    } else {
        return [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    }
}

@end
