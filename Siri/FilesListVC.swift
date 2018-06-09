//
//  FilesListVC.swift
//  Siri
//
//  Created by Shubh on 09/06/18.
//  Copyright © 2018 Sahand Edrisian. All rights reserved.
//

import UIKit
import QuickLook

class FilesListVC : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRecordLabel: UILabel!
    
    var arrayFiles = [FileModel]()
    var selectedFileUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDataFromDirectory()
        // get list of file from document directory
    }
    
    func getDataFromDirectory() {
        do {
            let allItems = try FileManager.default.contentsOfDirectory(atPath: getDocumentsDirectory.path)
            print(allItems)
            self.arrayFiles = allItems.map({ (strFile) -> FileModel in
                return FileModel(title: strFile)
            })
            self.tableView.reloadData()
            if self.arrayFiles.count > 0 {
                self.tableView.isHidden = false
                self.noRecordLabel.isHidden = true
            } else {
                self.tableView.isHidden = true
                self.noRecordLabel.isHidden = false
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func deleteAllTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure", message: "Delete all files?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            // cancel
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            do {
                let allItems = try FileManager.default.contentsOfDirectory(atPath: getDocumentsDirectory.path)
                allItems.forEach({ (item) in
                    do {
                        try FileManager.default.removeItem(at: getDocumentsDirectory.appendingPathComponent(item))
                    }  catch let error {
                        print(error.localizedDescription)
                    }
                })
                self.getDataFromDirectory()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FilesListVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayFiles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        aView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        let aLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
        aLabel.font = UIFont.boldSystemFont(ofSize: 14)
        aLabel.text = arrayFiles[section].title
        aView.addSubview(aLabel)
        return aView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fileCell = self.tableView.dequeueReusableCell(withIdentifier: FileCell.identifier, for: indexPath) as! FileCell
        if indexPath.row == 0 {
            fileCell.labelTitle.text = "Play Audio File"
        } else {
            fileCell.labelTitle.text = "Show Text File"
        }
        return fileCell
    }
}

extension FilesListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            selectedFileUrl = arrayFiles[indexPath.section].audioFilePath
        } else {
            selectedFileUrl = arrayFiles[indexPath.section].textFilePath
        }
        let qlPreviwer = QLPreviewController()
        qlPreviwer.dataSource = self
        qlPreviwer.currentPreviewItemIndex = 0;
        self.navigationController?.pushViewController(qlPreviwer, animated: true)
    }
}

extension FilesListVC: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return selectedFileUrl! as NSURL
    }
}


class FileCell : UITableViewCell {
    
    static let identifier = "FileCell"
    
    @IBOutlet weak var labelTitle: UILabel!
    
}
