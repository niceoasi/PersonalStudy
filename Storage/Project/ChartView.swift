//
//  ChartView.swift
//  DoitDiet
//
//  Created by Daeyun Ethan Kim on 02/11/2016.
//  Copyright © 2016 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class ChartView: UIViewController {
    
    // StoryBoard와 연결 부분
    
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    var graphView = ScrollableGraphView()
    var graphConstraints = [NSLayoutConstraint]()
    
    // Data
    
    // DotChart 생성
    
    private func createDotGraph(_ frame: CGRect) -> ScrollableGraphView {
        
        let graphView = ScrollableGraphView(frame:frame)
        
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#00BFFF")
        graphView.lineColor = UIColor.clear
        
        graphView.dataPointSize = 5
        graphView.dataPointSpacing = 80
        graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.dataPointLabelColor = UIColor.white
        graphView.dataPointFillColor = UIColor.white
        
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
        
        graphView.numberOfIntermediateReferenceLines = 4
        
        graphView.rangeMax = 100
        
        return graphView
    }
    
    
    // ChartView의 Constraints를 설정하는 부분
    
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.view.addConstraints(graphConstraints)
    }
    
    // Adding and updating the graph switching label in the top right corner of the screen.
    
    // Data Generation
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        if self.revealViewController() != nil {
            sideMenuButton.target = self.revealViewController()
            sideMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Chart Test 부분
        /*
                let months = [
                "Jan", "Feb", "Mar", "Apr",
                "May", "Jun", "Jul", "Aug",
                "Sep", "Oct", "Nov", "Dec"]
                let weightPoints = [
                70.0, 65.0, 66.0, 88.5,
                90.0, 85.0, 80.0, 75.0,
                77.0, 66.0, 63.0, 60.0]
        
                setChart(xAxisLabels: months, values: weightPoints)
        */
        
        // Do any additional setup after loading the view.
        var xaxis: [String] = [] // 날짜
        var yaxis: [Double] = [] // 값
        
        // 저장된 사용자 데이터를 불러 오는 부분
        
        let logFile = FileUtils(fileName: "bmilog.csv")
        if(logFile.fileExists()) {
            var rawLogData = logFile.readFile()
            let logEntries: Array = rawLogData.components(separatedBy: "\n")
            for record: String in logEntries {
                //            let trimmedString = record.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if record != "" {
                    let entry: Array = record.components(separatedBy: ", ")
                    xaxis.append(entry[3])
                    var yvalue = 0.0
                    if let y = Double(entry[1]) {
                        yvalue = y
                    }
                    yaxis.append(yvalue)
                }
            }
            //        var labels: [String] = self.generateSequentialLabels(xaxis.count, text: "날짜")
            
            // 받아온 사용자 값을 사용하여 chart 생성
            
            graphView = ScrollableGraphView(frame: self.view.frame)
            graphView = createDotGraph(self.view.frame)
            
            graphView.set(data: yaxis, withLabels: xaxis)
            self.view.addSubview(graphView)
            
            setupConstraints()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
