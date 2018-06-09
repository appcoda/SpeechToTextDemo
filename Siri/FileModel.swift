//
//  FileModel.swift
//  Siri
//
//  Created by Shubh on 09/06/18.
//  Copyright © 2018 Sahand Edrisian. All rights reserved.
//

import Foundation

class FileModel {
  
    var title : String!
    private var path : URL!
    
    var textFilePath : URL! {
     return self.path.appendingPathComponent(TEXT_FILE_DEFAULT_NAME)
    }
    
    var audioFilePath : URL! {
        return self.path.appendingPathComponent(AUDIO_FILE_DEFAULT_NAME)
    }
    
    init(title: String) {
        self.title = title
        self.path = getDocumentsDirectory.appendingPathComponent(title)
    }
}
