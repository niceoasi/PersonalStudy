//
//  ProfileViewController.swift
//  DoitDiet
//
//  Created by Daeyun Ethan Kim on 20/10/2016.
//  Copyright © 2016 Daeyun Ethan Kim. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    
    // Storyboard의 UITextField와 UILabel을 사용하기 위한 연결
    
    @IBOutlet weak var bmiAge: UITextField!
    @IBOutlet weak var bmiGender: UITextField!
    @IBOutlet weak var bmiHeight: UITextField!
    @IBOutlet weak var bmiWeight: UITextField!
    @IBOutlet weak var bmi: UILabel!
    @IBOutlet weak var bmiStatus: UILabel!
    
    
    
    // 로그 파일 생성
    // 사용자 등록 정보 저장 파일
    
    let logFile = FileUtils(fileName: "bmilog.csv")
    let customFile = FileUtils(fileName: "customfile.csv")
    
    
    
    // 사용자가 데이터를 저장한 시간을 저장 하기 위해 datePivkerView사용
    
    @IBAction func textFieldEditing(sender: UITextField) {
        let datePivkerView:UIDatePicker = UIDatePicker()
        datePivkerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePivkerView
        
        datePivkerView.addTarget(self, action: Selector("datePickerValueChanged:"), for: UIControlEvents.valueChanged)
    }
    
    
    // 시간포멧을 커스터마이징
    
    func setDateTimeTextEdit(date: NSDate) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        let nowDate = dateFormatter.string(from: date as Date)
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let nowTime = dateFormatter.string(from: date as Date)
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        setDateTimeTextEdit(date: sender.date as NSDate)
    }
    
    
    // 사용자 등록 정보를 버튼을 이용하여 저장하는 부분
    
    @IBAction func saveData(_ sender: UIButton) {
        var height : Double = 0
        var weight : Double = 0
        
        if let bmiH = Double(bmiHeight.text!) {
            height = Double(bmiH)
        }
        if let bmiW = Double(bmiWeight.text!) {
            weight = Double(bmiW)
        }
        
        
        // bmi를 계산하여 저장함
        
        let bmiCal = (weight) / ((height * height) * 0.0001)
        
        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(bmiCal * multiplier) / multiplier
        
        bmi.text = String(rounded)
        
        //        String(format: "%.2f", bmiCal)
        var status = getBMIStatus(bmi: bmiCal)
        
        print("Saving Log Data ...")
        
        let now = NSDate()
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "yy/MM/dd"
        let dateStr = customFormatter.string(from: now as Date)
        
        let logEntry = "\(bmiHeight.text!), \(bmiWeight.text!), \(bmi.text!), \(dateStr)\n"
        
        let retVal = logFile.appendFile(outputData: logEntry)
        print("Entire File : \n")
//        print(logFile.readFile())
        
        print(retVal ? "File Saved" : "File Error")
        
        
        customFile.clearFile()
        
        let customEntry = "\(bmiAge.text!), \(bmiGender.text!), \(bmiHeight.text!), \(bmiWeight.text!), \(bmi.text!)\n"
        
        let retVal1 = customFile.appendFile(outputData: customEntry)
        print("Entire File : \n")
//        print(customFile.readFile())
        
        print(retVal1 ? "File Saved" : "File Error")
        

    }
    
    
    // 저장된 사용자 정보를 삭제하는 부분
    
    @IBAction func clearLogFile(_ sender: UIButton) {
        logFile.clearFile()
        customFile.clearFile()
    }
    
    
    // 사용자의 현재 상태를 보여줌 (정상, 저체중, 과체중 등)
    
    func getBMIStatus(bmi: Double) {
        var status = ""
        
        if(bmi < 18.5) {
            status = "저체중 입니다."
        } else if (18.5 <= bmi && bmi < 23) {
            status = "정상 입니다."
        } else if (23 <= bmi && bmi < 25) {
            status = "과체중 입니다."
        } else {
            status = "비만 입니다."
        }
        
        bmiStatus.text = status
    }
        
    func handleTap(_ gesture: UITapGestureRecognizer) {
        if let firstRespoder = self.findFirstResponder() {
            firstRespoder.resignFirstResponder()
        }
    }
    
    
    // 터치를 인식하여 키보드가 나타나고 사라지는 부분
    
    func keyboardWillShow(_ noti: Notification) {
        if let rectObj = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = rectObj.cgRectValue
            
            let textField = findFirstResponder() as! UITextField
            
            if keyboardRect.contains(textField.frame.origin) {
                let dy = keyboardRect.origin.y - textField.frame.origin.y - textField.frame.size.height - 10
                self.view.transform = CGAffineTransform(translationX: 0, y: dy)
            }
            else {
                
            }
        }
    }
    
    func keyboardWillHide(_ noti: Notification) {
        self.view.transform = CGAffineTransform.identity
    }
    
    func findFirstResponder() -> UIResponder? {
        for v in self.view.subviews {
            if v.isFirstResponder {
                return (v as UIResponder)
            }
        }
        return nil
    }
    
    
    // NotificationCenter를 이용하여 터치를 감시
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap(_:)))
        
        self.view.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Inside segue prepare")
        
        let BMILogController = segue.destination as! BMILogViewController
        
        BMILogController.IncomingBMI = bmi.text!
        BMILogController.IncomingWeight = bmiWeight.text!
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // 테스트 부분
    
//    @IBAction func calculateBMI(_ sender: Any) {
//        var height : Double = 0
//        var weight : Double = 0
//        
//        if let bmiH = Double(bmiHeight.text!) {
//            height = Double(bmiH)
//        }
//        if let bmiW = Double(bmiWeight.text!) {
//            weight = Double(bmiW)
//        }
//        
//        let bmiCal = (weight) / ((height * height) * 0.0001)
//        
//        let numberOfPlaces = 2.0
//        let multiplier = pow(10.0, numberOfPlaces)
//        let rounded = round(bmiCal * multiplier) / multiplier
//        
//        bmi.text = String(rounded)
//        
//        //        String(format: "%.2f", bmiCal)
//        var status = getBMIStatus(bmi: bmiCal)
//    }
    

}
