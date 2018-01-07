//
//  FileManagerHelper.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 07/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import Foundation

class FileUtils {
    var fileName = ""
    var defaultDirectory: URL
    var pathUrl: URL
    var fileMgr: FileManager
    
    init(fileName: String) {
        self.fileName = fileName
        fileMgr = FileManager.default
        defaultDirectory = try! fileMgr.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        pathUrl = defaultDirectory.appendingPathComponent(fileName)
        
        print("pathUrl : \(pathUrl.path)")
    }
    
    convenience init(fileName: String, location: String) {
        let path = location + "/" + fileName
        
        self.init(fileName: path)
    }
    
    private func creatFile(outputData: String) {
        fileMgr.createFile(atPath: pathUrl.path, contents: outputData.data(using: String.Encoding.utf8), attributes: nil)
    }
    
    func fileExists() -> Bool {
        return fileMgr.fileExists(atPath: pathUrl.path)
    }
    
    func appendFile(outputData: String) -> Bool {
        var retVal = false
        if(!fileExists()) {
            creatFile(outputData: outputData)
        }
        do {
            let file: FileHandle? = try FileHandle(forWritingTo: pathUrl)
            file?.seekToEndOfFile()
            file?.write(outputData.data(using: String.Encoding.utf8)!)
            file?.closeFile()
            retVal = true
        } catch let error as NSError {
            print("File Error in appending: \(error)")
        }
        
        return retVal
    }
    
    func readFile() -> String {
        var retStr = ""
        
        let content = NSData(contentsOf: pathUrl)
        let dataString = String(data: content! as Data, encoding: String.Encoding.utf8)
        
        if let c = dataString {
            retStr = c
        }
        return retStr
    }
    
    func writeFile(data: String) -> Bool {
        var retVal = false
        
        do {
            try data.write(to: pathUrl, atomically: true, encoding: String.Encoding.utf8)
            retVal = true
        } catch let error as NSError{
            print("Error : \(error)")
        }
        
        return retVal
    }
    
    func clearFile() {
        do {
            let file: FileHandle? = try FileHandle(forWritingTo: pathUrl)
            file?.truncateFile(atOffset: 0)
            file?.closeFile()
        } catch let error as NSError {
            print("File Error in clearFile : \(error)")
        }
    }
}


func readFileTest() {
    var xaxis: [String] = []
    var yaxis: [Double] = []
    
    let logFile = FileUtils(fileName: "log.csv")
    if logFile.fileExists() {
        let rawLogData = logFile.readFile()
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
    }
}

func appendFileTest() {
    let logFile = FileUtils(fileName: "log.csv")
    
    let logEntry = "Test\n"
    let retVal = logFile.appendFile(outputData: logEntry)
    
    print(retVal ? "File Saved" : "File Error")
}

func clearFileTest() {
    let logFile = FileUtils(fileName: "log.csv")
    
    logFile.clearFile()
}


