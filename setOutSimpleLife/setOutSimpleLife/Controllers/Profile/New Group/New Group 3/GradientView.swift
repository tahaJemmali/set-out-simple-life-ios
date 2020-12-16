//
//  GradientView.swift
//  setOutSimpleLife
//
//  Created by Fahd on 12/5/20.
//

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0, 0.9]
        backgroundColor = UIColor.clear
    }
}
