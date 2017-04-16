#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PaperCell.h"
#import "PaperCollectionViewController.h"
#import "PaperView.h"
#import "UICollectionView+PaperUtils.h"
#import "UIView+PaperUtils.h"

FOUNDATION_EXPORT double PaperCollectionViewVersionNumber;
FOUNDATION_EXPORT const unsigned char PaperCollectionViewVersionString[];

