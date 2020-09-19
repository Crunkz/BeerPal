//
//  Theme+Colors.swift
//  BeerPal
//
//  Created by Krzysztof Babis on 07.09.2020 r..
//  Copyright © 2020 Krzysztof Babis. All rights reserved.
//

import UIKit

struct Theme {
    enum Colors {
        enum Background {
            static var primary: UIColor {
                return .getProperColor(lightModeColor: .white, darkModeColor: .black)
            }
            
            static var secondary: UIColor {
                return .getProperColor(lightModeColor: .black, darkModeColor: .black)
            }
        }
        
        enum Components {
            static var background: UIColor {
                return .systemYellow
            }
            
            static var foreground: UIColor {
                return .brown
            }
        }
        
        enum Reactions {
            enum Affirmation {
                static var primary: UIColor {
                    return .systemGreen
                }
            }
            
            enum Negation {
                static var primary: UIColor {
                    return .systemRed
                }
            }
            
            enum Warning {
                static var primary: UIColor {
                    return .systemYellow
                }
            }
        }
        
        enum Shadows {
            static var primary: UIColor {
                return .systemGray
            }
        }
        
        enum Texts {
            static var primary: UIColor {
                return .getProperColor(lightModeColor: .white, darkModeColor: .black)
            }
            
            static var secondary: UIColor {
                return .systemGray // adapts automatically to the current trait mode
            }
        }
    }
}

private extension UIColor {
    static func getProperColor(lightModeColor: UIColor, darkModeColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return (traits.userInterfaceStyle == .dark) ? darkModeColor : lightModeColor
            }
        } else {
            return lightModeColor
        }
    }
}
