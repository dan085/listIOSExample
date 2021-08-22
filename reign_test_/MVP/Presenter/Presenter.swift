//
//  Presenter.swift
//  reign_test_
//
//  Created by Daniel Verdugo Gonzalez on 16-08-21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


protocol  ItemPresenterDelegate:AnyObject {
    
    func presentItems(items:[Item])
    func presentAlert(message:String)
}


typealias ItemPresenterDelegatetem = ItemPresenterDelegate & UIViewController
class ItemPresenter{
    
    weak var delegate:ItemPresenterDelegate!
   
    func   getItems(){
        
        AF.request(AppUrl.url,
                   method: .get).responseJSON { [self] (response) in
            switch response.result {
            case .success(let data):
          
                let json = JSON(data)
                if let recs = json["hits"].array {
                var  dataItems : [Item]  = [Item]()
                if(recs.count>0){
                        for i in 0 ..< recs.count {
                        let created_at = recs[i].dictionaryValue["created_at"]?.stringValue
                        let author = recs[i].dictionaryValue["author"]?.stringValue
                            
                            
                            let title = recs[i].dictionaryValue["title"]?.stringValue
                            
                        let story_title = recs[i].dictionaryValue["story_title"]?.stringValue
                        let story_url = recs[i].dictionaryValue["story_url"]?.stringValue
                            
                            
                            
                            
                            dataItems.append(Item(created_at: created_at ?? "NULO",
                                                  author: author ?? "NULLO",
                                                  story_title: (story_title ?? title)!, story_url: story_url ?? "NULLO"))
                        }
                    
                    delegate.presentItems(items: dataItems)
                            
                }
                
                }
       
                    
                
         
            case .failure(let error):
                    print("Request failed with error: \(error)")
                    delegate.presentAlert(message: "connection problem" )
                }
            }
        }
    
    public func setViewDelegate(delegate: ItemPresenterDelegate){
        
        self.delegate = delegate
    }
    
    
}
