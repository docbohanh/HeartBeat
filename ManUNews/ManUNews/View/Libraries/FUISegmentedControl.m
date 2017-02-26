//
//  FUISegmentedControl.m
//  FlatUIKitExample
//
//  Created by Alex Medearis on 5/17/13.
//
//

#import "FUISegmentedControl.h"
#import "UIImage+FlatUI.h"
#import "UIColor+FlatUI.h"

@implementation FUISegmentedControl

//+ (void)initialize {
//    if (self == [FUISegmentedControl class]) {
//        FUISegmentedControl *appearance = [self appearance];
//        [appearance setCornerRadius:5.0f];
//        [appearance setSelectedColor:[UIColor blueColor]];
//        [appearance setDeselectedColor:[UIColor darkGrayColor]];
//        [appearance setSelectedFontColor:[UIColor whiteColor]];
//        [appearance setDeselectedFontColor:[UIColor whiteColor]];
//    }
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSInteger previousSelectedSegmentIndex = self.selectedSegmentIndex;
    [super touchesEnded:touches withEvent:event];
    if (previousSelectedSegmentIndex == self.selectedSegmentIndex) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setDeselectedColor:(UIColor *)deselectedColor {
    _deselectedColor = deselectedColor;
    [self configureFlatSegmentedControl];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self configureFlatSegmentedControl];
}

- (void)setDisabledColor:(UIColor *)disabledColor {
    _disabledColor = disabledColor;
    [self configureFlatSegmentedControl];
}

- (void)setDividerColor:(UIColor *)dividerColor {
    _dividerColor = dividerColor;
    [self configureFlatSegmentedControl];
}

- (void)setHighLightColor:(UIColor *)highLightColor {
    _highLightColor = highLightColor;
    [self configureFlatSegmentedControl];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self configureFlatSegmentedControl];
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    _selectedFont = selectedFont;
    [self setupFonts];
}

- (void)setSelectedFontColor:(UIColor *)selectedFontColor {
    _selectedFontColor = selectedFontColor;
    [self setupFonts];
}

- (void)setDeselectedFont:(UIFont *)deselectedFont {
    _deselectedFont = deselectedFont;
    [self setupFonts];
}

- (void)setDeselectedFontColor:(UIColor *)deselectedFontColor {
    _deselectedFontColor = deselectedFontColor;
    [self setupFonts];
}

- (void)setDisabledFont:(UIFont *)disabledFont {
    _disabledFont = disabledFont;
    [self setupFonts];
}

- (void)setDisabledFontColor:(UIColor *)disabledFontColor {
    _disabledFontColor = disabledFontColor;
    [self setupFonts];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self configureFlatSegmentedControl];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self configureFlatSegmentedControl];
}

- (void)setupFonts {
	// Although iOS 6 supports NSForegroundColorAttributeName,
	// it doesn't seem to apply it to deselected segments but will apply the
	// old UITextAttributeTextColor attribute. We therefore do a runtime version
	// check and use the old attributes when needed

    NSDictionary *selectedAttributesDictionary;
    
	if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        
        selectedAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.selectedFontColor,
                                        NSForegroundColorAttributeName,
                                        self.selectedFont,
                                        NSFontAttributeName,
                                        nil];
    }
    
    [self setTitleTextAttributes:selectedAttributesDictionary forState:UIControlStateSelected];
    
    NSDictionary *deselectedAttributesDictionary;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        // iOS7+ methods
        deselectedAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          self.deselectedFontColor,
                                          NSForegroundColorAttributeName,
                                          self.deselectedFont,
                                          NSFontAttributeName,
                                          nil];
	}
    [self setTitleTextAttributes:deselectedAttributesDictionary forState:UIControlStateNormal];

    NSDictionary *disabledAttributesDictionary;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        // iOS7+ methods
    
        disabledAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                self.disabledFontColor,
                NSForegroundColorAttributeName,
                self.disabledFont,
                NSFontAttributeName,
                nil];
    }

    [self setTitleTextAttributes:disabledAttributesDictionary forState:UIControlStateDisabled];
}

- (void)configureFlatSegmentedControl {
    UIImage *selectedBackgroundImage = [UIImage buttonImageWithColor:self.selectedColor
                                                        cornerRadius:self.cornerRadius
                                                         shadowColor:[UIColor clearColor]
                                                        shadowInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *deselectedBackgroundImage = [UIImage buttonImageWithColor:self.deselectedColor
                                                           cornerRadius:self.cornerRadius
                                                            shadowColor:[UIColor clearColor]
                                                           shadowInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *disabledBackgroundImage = [UIImage buttonImageWithColor:self.disabledColor
                                                          cornerRadius:self.cornerRadius
                                                           shadowColor:[UIColor clearColor]
                                                          shadowInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UIImage *highLightBackgroundImage = [UIImage buttonImageWithColor:self.highLightColor
                                                         cornerRadius:self.cornerRadius
                                                          shadowColor:[UIColor clearColor]
                                                         shadowInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
    
    UIColor *selectedColor = (self.dividerColor) ? self.dividerColor : self.selectedColor;
    UIColor *deselectedColor = (self.dividerColor) ? self.dividerColor : self.deselectedColor;
    UIImage *selectedDividerImage = [[UIImage imageWithColor:selectedColor cornerRadius:0] imageWithMinimumSize:CGSizeMake(1, 1)];
    UIImage *deselectedDividerImage = [[UIImage imageWithColor:deselectedColor cornerRadius:0] imageWithMinimumSize:CGSizeMake(1, 1)];
    
    
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:deselectedBackgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:disabledBackgroundImage forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:highLightBackgroundImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    [self setDividerImage:deselectedDividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setDividerImage:selectedDividerImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setDividerImage:deselectedDividerImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setDividerImage:selectedDividerImage forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.cornerRadius = self.cornerRadius;
}

@end
