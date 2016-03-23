//
//  ChartViewController.swift
//  todo
//
//  Created by Nelma Perera on 3/14/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    var dotsCategory: [String]!

    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var earnedLegend: UIView!
    
    @IBOutlet weak var payedLegend: UIView!
    
    @IBOutlet weak var payedAmount: UILabel!
    
    @IBOutlet weak var earnedAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dotsCategory = ["Earned", "Payed"]
        let p = (user["paid"] as? Int)!
        let e = (user["earned"] as? Int)!
        let dotsAmount = [e, p]
        payedAmount.text = String(p)
        earnedAmount.text = String(e)
        
        setChart(dotsCategory, values: dotsAmount)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.pieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Int]) {
        self.pieChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: Double(values[i]), xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "dots")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        self.pieChartView.data = pieChartData
        self.pieChartView.legend.enabled = false
        self.pieChartView.drawSliceTextEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        self.pieChartView.descriptionText = ""
        
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        paragraphStyle.alignment = .Center
        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "dots total\n" + String(user["dots"]!))
        centerText.setAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20.0)!, NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, centerText.length))
        
        self.pieChartView.centerAttributedText = centerText
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        earnedLegend.backgroundColor = colors[0]
        
        payedLegend.backgroundColor = colors[1]
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
