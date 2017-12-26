//
//  ViewController.swift
//  LinkedIn-SNA
//
//  Created by Egzon Arifi on 12/23/17.
//  Copyright © 2017 Overjump. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var users = [User]()

    var adjancencyMatrix = [[Int]]()
    
    var usersInfo = ""
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var console: NSTextField!
    @IBOutlet weak var skillName: NSTextField!
    @IBOutlet weak var exportButton: NSButton!
    
    @IBOutlet weak var firstOption: NSButton!
    @IBOutlet weak var secondOptiom: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        exportButton.isEnabled = false
        users = LoadFile.loadUser(fromFile: "linkedinProfiles")
    }
    
    @IBAction func firstRadioAction(_ sender: Any) {
    
        secondOptiom.state = 0
    }
    
    @IBAction func secondRadionAction(_ sender: Any) {
        firstOption.state = 0
    }
    
    @IBAction func usersLog(_ sender: Any) {
        saveModal(text: "*Network LinkedIn SNA \n*Vertices      19\n" + usersInfo + "\n*Matrix 1: \"Users with same predefined skills\"\n" + console.stringValue)
//        saveModal(text: console.stringValue)
    }
    
    @IBAction func createAdjacencyMatrix(_ sender: Any) {
        
        adjancencyMatrix = [[Int]]()
        
        let users2 = users
        
        console.stringValue = ""
        
        let skillsArr = skillName.stringValue.components(separatedBy: ",")
        
        usersInfo = ""
        
        for user in users {
            
            usersInfo = usersInfo + "\(user.uId!) \(user.firstName!) \(user.lastName!)\n"
            
            var rowAdjacency = [Int]()
            
            for user2 in users2 {
                
                var existSameSkills = 0
                
                for skill in skillsArr {
                    
//                    let user2Result = user2.skills.binarySearch { $0.name.lowercased() == skill.lowercased() }
//                    let user1Result = user.skills.binarySearch { $0.name.lowercased() == skill.lowercased() }
//                    
//                    print(user1Result,user2Result)
//                    
//                    if user2Result > 0 && user1Result > 0 {
//                        existSameSkills = existSameSkills + 1
//                    }
                    
                    let user2Results = user2.skills.filter { $0.name.lowercased() == skill.lowercased() }
                    let user1Results = user.skills.filter { $0.name.lowercased() == skill.lowercased() }
                    
                    if !user2Results.isEmpty && !user1Results.isEmpty {
                        existSameSkills = existSameSkills + 1
                    }
                }
                
                //print(existSameSkills,skillsArr.count)
                if user2.uId == user.uId {
                    rowAdjacency.append(0)
                    console.stringValue = console.stringValue + "0"
                } else if existSameSkills >= 3 {
                    rowAdjacency.append(1)
                    console.stringValue = console.stringValue + "1"
                } else {
                    rowAdjacency.append(0)
                    console.stringValue = console.stringValue + "0"
                }
                console.stringValue = console.stringValue + "  "
            }
            //print(rowAdjacency)
            console.stringValue = console.stringValue + "\n"
            adjancencyMatrix.append(rowAdjacency)
        }
        collectionView.reloadData()
        exportButton.isEnabled = true
    }
    
    func saveModal(text: String) {
        let alert = NSAlert()
        alert.informativeText = "Do you want to save to documents?"
        alert.messageText = "Save it?"
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: self.view.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSAlertFirstButtonReturn {
                print("Document deleted")
                self.saveToDocumentsFolder(text: text)
            }
        })
    }
    
    func saveToDocumentsFolder(text: String) {
        
        // get the documents folder url
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create the destination url for the text file to be saved
        let fileURL = documentDirectory.appendingPathComponent("linkedin_users_adj_matrix.paj")
        
        do {
            // writing to disk
            try text.write(to: fileURL, atomically: false, encoding: .utf8)
            
            // saving was successful. any code posterior code goes here
            // reading from disk
            do {
                let mytext = try String(contentsOf: fileURL)
                print(mytext)   // "some text\n"
            } catch {
                print("error loading contents of:", fileURL, error)
            }
        } catch {
            print("error writing to url:", fileURL, error)
        }
    }
}

extension ViewController : NSCollectionViewDataSource {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return adjancencyMatrix.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return adjancencyMatrix[section].count
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView,
                        itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
        guard let collectionViewItem = item as? CollectionViewItem else {
            return item
        }
        collectionViewItem.textField?.stringValue = "\(adjancencyMatrix[indexPath.section][indexPath.item])"
        return item
    }
}

extension ViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: floor(collectionView.bounds.size.width/19.1), height: floor(collectionView.bounds.size.height/19.1))
    }
}


