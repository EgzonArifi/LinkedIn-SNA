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
    var skillToUserString = ""
    var userToUserString = ""
    
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
        skillName.stringValue = "Swift,Objective-C,Java,Xcode,iOS Development,Unit Testing,Javascript,node.js,jQuery,Ruby on Rails,.Net,iOS Design,Adobe Photoshop,SQL,iOS Design,Mobile Applications,OAuth,Core Data,Git"
    }
    
    @IBAction func usersLog(_ sender: Any) {
        if skillToUserString.isEmpty {
            saveModal(text: "*Network LinkedIn SNA \n*Vertices      \(adjancencyMatrix.count)\n" + usersInfo + "\n*Matrix 1: \"Users with same predefined skills\"\n" + userToUserString)
        } else {
            saveModal(text: "*Network LinkedIn SNA \n*Vertices      \(adjancencyMatrix.count)\n" + usersInfo + "\n*Matrix 1: \"Users to user\"\n" + userToUserString + "\n*Matrix 2: \"Skill to user\"\n" + skillToUserString)
        }
        //        saveModal(text: console.stringValue)
    }
    
    @IBAction func createAdjacencyMatrix(_ sender: Any) {
        
        console.stringValue = ""
        
        usersInfo = ""
        adjancencyMatrix = [[Int]]()
        
        if firstOption.state == 1 {
            userToUserString = ""
            userToUser()
        } else {
            skillToUserString = ""
            skillToUser()
        }
        
        collectionView.reloadData()
        exportButton.isEnabled = true
    }
    
    func userToUser() {
        
        let users2 = users
        let skillsArr = skillName.stringValue.components(separatedBy: ",")
        
        var i = 0
        for user in users {
            i = i + 1
            usersInfo = usersInfo + "\(i) \(user.firstName!) \(user.lastName!)\n"
            
            var rowAdjacency = [Int]()
            
            for user2 in users2 {
                
                var existSameSkills = 0
                
                for skill in skillsArr {
                    
                    let user2Results = user2.skills.filter { $0.name.lowercased() == skill.lowercased() }
                    let user1Results = user.skills.filter { $0.name.lowercased() == skill.lowercased() }
                    
                    if !user2Results.isEmpty && !user1Results.isEmpty {
                        existSameSkills = existSameSkills + 1
                    }
                }
                
                if user2.uId == user.uId {
                    rowAdjacency.append(0)
                    userToUserString = userToUserString + "0"
                } else if existSameSkills >= 3 {
                    rowAdjacency.append(1)
                    userToUserString = userToUserString + "1"
                } else {
                    rowAdjacency.append(0)
                    userToUserString = userToUserString + "0"
                }
                userToUserString = userToUserString + "  "
            }
            userToUserString = userToUserString + "\n"
            adjancencyMatrix.append(rowAdjacency)
        }
    }
    
    func skillToUser() {
        
        let skillsArr = skillName.stringValue.components(separatedBy: ",")
        
        for user in users {
            
            var rowAdjacency = [Int]()
            usersInfo = usersInfo + "\(user.uId!) \(user.firstName!) \(user.lastName!)\n"
            
            for skill in skillsArr {
                
                let user1Results = user.skills.filter { $0.name.lowercased() == skill.lowercased() }
                
                if !user1Results.isEmpty {
                    rowAdjacency.append(1)
                    skillToUserString = skillToUserString + "1"
                } else {
                    rowAdjacency.append(0)
                    skillToUserString = skillToUserString + "0"
                }
                skillToUserString = skillToUserString + "  "
            }
            skillToUserString = skillToUserString + "\n"
            adjancencyMatrix.append(rowAdjacency)
        }

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
                print(mytext)
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
        collectionViewItem.textField?.stringValue = ""
        collectionViewItem.textField?.stringValue = "\(adjancencyMatrix[indexPath.section][indexPath.item])"
        return item
    }
}

extension ViewController : NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: floor(collectionView.bounds.size.width/CGFloat(adjancencyMatrix.count)), height: floor(collectionView.bounds.size.height/CGFloat(adjancencyMatrix.count)))
    }
}
