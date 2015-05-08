/*
 * KZColodeDrawingView: https://github.com/acerbetti/KZColodeDrawingView
 *
 * Copyright (c) 2013 Stefano Acerbetti
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <UIKit/UIKit.h>

#define KZColodeDrawingViewVersion   1.0.0

typedef enum {
    KZColodeDrawingToolTypePen,
    KZColodeDrawingToolTypeLine,
    KZColodeDrawingToolTypeRectagleStroke,
    KZColodeDrawingToolTypeRectagleFill,
    KZColodeDrawingToolTypeEllipseStroke,
    KZColodeDrawingToolTypeEllipseFill,
    KZColodeDrawingToolTypeEraser,
    KZColodeDrawingToolTypeText
} KZColodeDrawingToolType;

@protocol KZColodeDrawingViewDelegate, KZColodeDrawingTool;

@interface KZColodeDrawingView : UIView<UITextViewDelegate>

@property (nonatomic, assign) KZColodeDrawingToolType drawTool;
@property (nonatomic, assign) id<KZColodeDrawingViewDelegate> delegate;

// public properties
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat bltRed;
@property (nonatomic, assign) CGFloat bltBlue;
@property (nonatomic, assign) CGFloat bltGreen;
@property (nonatomic, assign) UIColor *colodeColor;

// get the current drawing
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong) UIImage *prev_image;
@property (nonatomic, readonly) NSUInteger undoSteps;

// load external image
- (void)loadImage:(UIImage *)image;
- (void)loadImageData:(NSData *)imageData;

// erase all
- (void)clear;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;

- (BOOL)canRedo;
- (void)redoLatestStep;

@end

#pragma mark -

@protocol KZColodeDrawingViewDelegate <NSObject>

@optional
- (void)drawingView:(KZColodeDrawingView *)view willBeginDrawUsingTool:(id<KZColodeDrawingTool>)tool;
- (void)drawingView:(KZColodeDrawingView *)view didEndDrawUsingTool:(id<KZColodeDrawingTool>)tool;

@end
