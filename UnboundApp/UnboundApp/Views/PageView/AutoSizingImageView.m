/*
     File: AutoSizingImageView.m 
 Abstract: Main image view properly sized within its scroll view.
  
  Version: 1.1 
  
 */

#import "AutoSizingImageView.h"

@interface AutoSizingImageView ()

@end

@implementation AutoSizingImageView 

// The imageView should always be the same size as the enclosing scrollview regardless of
// the bounds of the clipView. We need to do this manually because auto-layout would try
// to size the view to the bounds of the clipview effectively nulling the magnification.
//

+ (BOOL)isCompatibleWithResponsiveScrolling
{
    return NO;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setEditable:YES];
}

//- (void)setFrameSize:(NSSize)newSize {
//
//    NSScrollView *scrollView = [self enclosingScrollView];
//    if (scrollView) {
//        [super setFrameSize:scrollView.frame.size];
//    } else {
//        [super setFrameSize:newSize];
//    }
//}

-(void)rightMouseDown:(NSEvent *)theEvent {
    DLog(@"rightMouseDown:%@", theEvent);
    [[self nextResponder] rightMouseDown:theEvent];
}

-(void)mouseDown:(NSEvent *)theEvent{
    
    // not sure why, but we need to manually support ctrl+click for right mouse
    if (theEvent.modifierFlags & NSEventModifierFlagControl)
        return [self rightMouseDown:theEvent];
    
    DLog(@"mouseDown:%@", theEvent);
    [[self nextResponder] mouseDown:theEvent];
    
    if (theEvent.clickCount ==2) {
        NSScrollView *scrollView = [self enclosingScrollView];
        CGFloat curMagnification = [scrollView magnification];
        CGFloat maxMagnification = [scrollView maxMagnification];
        if (maxMagnification<=0) {
            maxMagnification = 4.0f;
        }
        CGFloat thresholdMagnification = maxMagnification/2.0f;
        DLog(@"double click received. curMagnification : %f - maxMagnification : %f", curMagnification, maxMagnification);
        if (curMagnification < thresholdMagnification) {
            DLog(@"zooming to max magnification : %f", maxMagnification);
            
            [scrollView setMagnification:maxMagnification centeredAtPoint:(NSPoint)theEvent.locationInWindow];
            
        } else {
            [scrollView magnifyToFitRect:self.bounds];
        }
    }

    
}

-(void)keyDown:(NSEvent *)theEvent
{
    [self.delegate keyDown:theEvent];
}

-(void)setImage:(NSImage *)newImage
{
    if(newImage == nil)
    {
        newImage = [NSImage imageNamed:@"fullnophoto"];
        [self setImageScaling:NSImageScaleProportionallyDown];
    }
    
    else
    {
        [self setImageScaling:NSImageScaleProportionallyUpOrDown];
    }
    
    [super setImage:newImage];
}

@end
