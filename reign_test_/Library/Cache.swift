//
//  Cache.swift
//  reign_test_
//
//  Created by Daniel Verdugo Gonzalez on 16-08-21.
//

import Foundation

class Cache {
  
  static var cache: Cache? = nil
  
  class func newInstance() -> Cache {
       if (cache == nil) {
        cache = Cache()
           return cache!
       }else{
           return cache!
       }
   }
  
  var mUserDefaults:UserDefaults? = nil
  
  init() {
      if(mUserDefaults==nil){
        mUserDefaults = UserDefaults.standard
      }
  }
  
  var requiringSecureCoding:Bool = true
  var CACHE_LIST = "Cache_List"
   func   GetCacheListItems()->[Item]{
    
    if let data = UserDefaults.standard.value(forKey:CACHE_LIST) as? Data {
        let items = try? PropertyListDecoder().decode([Item].self, from: data)
        return items!
    }else{
        
        return [Item]()
        
    }
      
      
  }
   func setCacheListItems( data:[Item] ){
    UserDefaults.standard.set(try? PropertyListEncoder().encode(data), forKey:CACHE_LIST)
 }


}
