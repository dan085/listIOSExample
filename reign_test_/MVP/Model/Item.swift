//
//  Item.swift
//  reign_test_
//
//  Created by Daniel Verdugo Gonzalez on 16-08-21.
//

import Foundation



struct Item:Codable {
    var created_at:String = ""
    var author:String = ""
    var story_title:String = ""
    var story_url:String = ""
    init(created_at:String,
         author:String,
         story_title:String,
         story_url:String) {
        self.created_at=created_at
        self.author=author
        self.story_title=story_title
        self.story_url=story_url
    }
    
    
}

