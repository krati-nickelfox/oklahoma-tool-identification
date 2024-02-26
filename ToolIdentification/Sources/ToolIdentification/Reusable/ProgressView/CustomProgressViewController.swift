//
//  CustomProgressViewController.swift
//  
//
//  Created by Krati Mittal on 26/02/24.
//

import UIKit

class CustomProgressViewController: UIViewController {
    
    var skippedCircularProgress: KDCircularProgress?
    var incorrectCircularProgress: KDCircularProgress?
    var correctCircularProgress: KDCircularProgress?
    
    var dataModel: ResultDataModel?
    
    static var newInstance: CustomProgressViewController {
        return CustomProgressViewController(nibName: "CustomProgressViewController",
                                            bundle: .module)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        if let item = self.dataModel {
            self.setupProgressViews(with: item)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let item = self.dataModel {
            self.animateProgressView(with: item)
        }
    }
    
    private func setupProgressViews(with model: ResultDataModel) {
        let superViewWidth: CGFloat = 112
        
        let skippedCircularProgress = KDCircularProgress()
        skippedCircularProgress.frame = CGRect(x: 0, y: 0, 
                                               width: superViewWidth,
                                               height: superViewWidth)
        skippedCircularProgress.contentMode = .scaleAspectFit
        
        skippedCircularProgress.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            skippedCircularProgress.widthAnchor.constraint(equalToConstant: superViewWidth),
            skippedCircularProgress.heightAnchor.constraint(equalToConstant: superViewWidth)
        ])
        self.skippedCircularProgress = skippedCircularProgress
        self.view.addSubview(skippedCircularProgress)
        
        let correctCircularProgress = KDCircularProgress()
        correctCircularProgress.frame = CGRect(x: 0, y: 0, 
                                               width: superViewWidth,
                                               height: superViewWidth)
        correctCircularProgress.contentMode = .scaleAspectFit
        
        correctCircularProgress.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            correctCircularProgress.widthAnchor.constraint(equalToConstant: superViewWidth),
            correctCircularProgress.heightAnchor.constraint(equalToConstant: superViewWidth)
        ])
        self.correctCircularProgress = correctCircularProgress
        self.view.addSubview(correctCircularProgress)
        
        let incorrectCircularProgress = KDCircularProgress()
        incorrectCircularProgress.frame = CGRect(x: 0, y: 0,
                                                 width: superViewWidth,
                                                 height: superViewWidth)
        incorrectCircularProgress.contentMode = .scaleAspectFit
        
        incorrectCircularProgress.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            incorrectCircularProgress.widthAnchor.constraint(equalToConstant: superViewWidth),
            incorrectCircularProgress.heightAnchor.constraint(equalToConstant: superViewWidth)
        ])
        self.incorrectCircularProgress = incorrectCircularProgress
        self.view.addSubview(incorrectCircularProgress)
        
        
        let correctAngle: Double = Double((model.correctPercentage * 360) / 100) - 89
        let skippedAngle: Double = Double(((model.correctPercentage + model.skippedPercentage) * 360) / 100) - 89
        let progressViews = [
            self.correctCircularProgress,
            self.skippedCircularProgress,
            self.incorrectCircularProgress
        ]
        let progressThicknesses: [CGFloat] = [0.6, 0.5, 0.4]
        let progressColors: [UIColor] = [Colors.correctOptionColor,
                                         Colors.primaryYellow,
                                         Colors.incorrectOptionColor]
        let startAngles: [Double] = [-90, correctAngle, skippedAngle]
        
        for index in 0..<progressViews.count {
            self.setupProgressView(circularProgress: progressViews[index]!,
                                   progressThickness: progressThicknesses[index],
                                   progressColor: progressColors[index],
                                   startAngle: startAngles[index])
        }
    }
    
    private func setupProgressView(circularProgress: KDCircularProgress,
                                   progressThickness: CGFloat,
                                   progressColor: UIColor,
                                   startAngle: Double) {
        circularProgress.gradientRotateSpeed = 2
        circularProgress.glowMode = .noGlow
        circularProgress.clockwise = true
        circularProgress.roundedCorners = false
        circularProgress.trackThickness = progressThickness
        circularProgress.progressThickness = progressThickness
        circularProgress.startAngle = startAngle
        circularProgress.progressInsideFillColor = UIColor.clear
        circularProgress.trackColor = UIColor.clear
        circularProgress.progressColors = [progressColor]
    }
    
    private func animateProgressView(with model: ResultDataModel) {
        self.incorrectCircularProgress?.isHidden = model.incorrectPercentage == 0.0
        self.skippedCircularProgress?.isHidden = model.skippedPercentage == 0.0
        self.correctCircularProgress?.isHidden = model.correctPercentage == 0.0
        
        let skippedAangle: Double = Double((model.skippedPercentage * 360) / 100)
        let incorrectAngle: Double = Double((model.incorrectPercentage * 360) / 100)
        let correctAngle: Double = Double((model.correctPercentage * 360) / 100)
        
        let animationDuration: Double = 0.1
        
        self.correctCircularProgress?.animateFromAngle(0, 
                                                       toAngle: correctAngle - 1,
                                                       duration: animationDuration,
                                                       completion: { completed in
            if completed {
                self.skippedCircularProgress?.animateFromAngle(0, 
                                                               toAngle: skippedAangle - 1,
                                                               duration: animationDuration,
                                                               completion: { completed in
                    if completed {
                        self.incorrectCircularProgress?.animateFromAngle(0, 
                                                                         toAngle: incorrectAngle - 1,
                                                                         duration: animationDuration,
                                                                         completion: { completed in
                            if completed {
                                HapticFeedback.success()
                            }
                        })
                    }
                })
            }
        })
    }
    
}
