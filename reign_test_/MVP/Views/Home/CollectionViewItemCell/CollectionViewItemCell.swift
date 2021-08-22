//
//  CollectionViewItemCell.swift
//  reign_test_
//
//  Created by Daniel Verdugo Gonzalez on 16-08-21.
//

import UIKit
import SwipeCellKit

protocol CollectionViewItemCellCellDelegate {
    func clickBtnOpenClick(_ data:Item, indexpath:IndexPath)
}

class CollectionViewItemCell: SwipeCollectionViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var story_title: UILabel!
    
    @IBOutlet weak var created_at: UILabel!
    @IBOutlet weak var btnSelectItem: UIButton!
    
    var data:Item!
    var indexpath:IndexPath!
    
    var delegateOpen:CollectionViewItemCellCellDelegate!
    func setData(data:Item, indexpath:IndexPath){
         self.data=data
         self.indexpath=indexpath
     }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnSelectItem.setBackgroundColor(color:  UIColor(named: "white2")!, forState: UIControl.State.highlighted)
        btnSelectItem.addTarget(self, action: #selector(btnClickOpen), for: .touchUpInside)

    }
    
    @objc private func btnClickOpen(_ sender: UIButton?) {
        delegateOpen.clickBtnOpenClick( self.data,indexpath: self.indexpath)
    }

    
    
    func  convert_UTC_date_to_timezone(_ review:String) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
       dateFormatter.locale = Locale(identifier: "en-US")
       dateFormatter.timeZone = TimeZone(identifier: "UTC")
       dateFormatter.isLenient = true
       let date = dateFormatter.date(from: review)!// create   date from string
       //  print ("The formated date is \(date)")
       // change to a readable time format and change to local time zone
       let dateFormatter_ = DateFormatter()
       dateFormatter_.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
       dateFormatter_.dateFormat = "yyyy/MM/dd hh:mm:ss a"
       dateFormatter_.locale = Locale(identifier: "en-US")
       dateFormatter_.timeZone = TimeZone.autoupdatingCurrent
      /** if  date == nil{
           
           return "NOW"
           
       }else{**/
       
           let timeStamp = dateFormatter_.string(from: date)
       return timeStamp
     //  }
       
       
   }
    
    
}

