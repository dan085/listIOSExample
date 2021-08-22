//
//  IntroViewController.swift
//  reign_test_
//
//  Created by Daniel Verdugo Gonzalez on 21-08-21.
//

import UIKit

import UIKit
import ESPullToRefresh
import SwipeCellKit
import TTGSnackbar
import PanModal
import MagazineLayout

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,SwipeCollectionViewCellDelegate, ItemPresenterDelegate,CollectionViewItemCellCellDelegate {
    func clickBtnOpenClick(_ data: Item, indexpath: IndexPath) {
        let vc = SmartWKWebViewController()
        vc.stringLoading = NSLocalizedString("loading", comment: "Loading")
        vc.url = URL(string:  data.story_url)
        vc.isShortFormEnabled=false
        presentPanModal(vc)
        
        
    }
    
 
    
    private var cache:Cache!
    private var  items = [Item]()
  
    func presentItems(items: [Item]) {
        self.items = items
        cache.setCacheListItems(data: items)
        self.collectionView.es.stopPullToRefresh()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        
    }
    
    func presentAlert( message: String) {
        
        
        let snackbar = TTGSnackbar(message: message, duration: .middle)
        snackbar.leftMargin = 16
        snackbar.rightMargin = 16
        snackbar.cornerRadius = 20
        snackbar.messageContentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        snackbar.animationType = .slideFromTopBackToTop
        snackbar.backgroundColor = UIColor(named: "green_minimalist")
        snackbar.show()
    }
    

    
    
    
    private let cellIdentifier = "CollectionViewItemCell"
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private let presenter = ItemPresenter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cache = Cache.newInstance() // Init cache
        // Do any additional setup after loading the view.
        presenter.setViewDelegate(delegate: self)
        // Do any additional setup after loading the view, typically from a nib
        // let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let layout = MagazineLayout()
      //  layout.sectionInset = UIEdgeInsets(top: 3, left: 0, bottom: 30, right: 0)
       // layout.itemSize = CGSize(width: screenWidth / 2, height: screenWidth / 3)
       // layout.minimumInteritemSpacing = 0
       /// layout.minimumLineSpacing = 0
     collectionView!.dataSource = self
     collectionView!.delegate = self

           // collectionView.frame=self.view.frame
     collectionView.collectionViewLayout=layout
        
     collectionView.backgroundColor = .white
             
            // register cell
     collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
            
     collectionView.contentInsetAdjustmentBehavior = .never
        
        if(cache.GetCacheListItems().count==0){
            presenter.getItems()

        }else{
            self.items = cache.GetCacheListItems()
            
        }
      
        
      
        self.collectionView.es.addPullToRefresh {
            [unowned self] in
            presenter.getItems()
            
        }
 
    
        
    
    }
    
    
    func EmptyMessage(message:String,description:String,image_name:String, viewController:UICollectionView) {
        let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: viewController.bounds.size.width, height: viewController.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Roboto", size: 15)
        messageLabel.sizeToFit()
        let empty :emptyViewEmptyView = emptyViewEmptyView(frame: CGRect(x: 0,y: 0,width: viewController.bounds.size.width, height: viewController.bounds.size.height))
      //   empty.sizeToFit()
        empty.titleLabel.text=message
      //  empty.descriptionLabel.text=description
       empty.emptyIcon.image = UIImage(named:image_name)
        viewController.backgroundView = empty
        empty.center = (viewController.backgroundView?.center)!
    }

}



// MARK: - UICollectionViewDelegate/DataSource

extension HomeViewController {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        self.collectionView.backgroundView = nil
        
        if(self.items.count==0){
            EmptyMessage(message: "Message",description: "without news",image_name: "empty",viewController: self.collectionView)
            return 0
            
        }else{
            return self.items.count
        }
  
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: NSLocalizedString("delete", comment: "delete")) { action, indexPath in
            // handle action by updating model with deletion
            
                self.items.remove(at: indexPath.row)
                collectionView.performBatchUpdates({
                   self.collectionView.deleteItems(at: [indexPath])
               }, completion: {
                   (finished: Bool) in
                   self.cache.setCacheListItems(data: self.items)
               })
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-white")

        return [deleteAction]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.transitionStyle = .drag
        return options
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewItemCell
        let data = self.items[indexPath.row]
        cell.setData(data: data,indexpath: indexPath)
        
        cell.created_at.text=cell.convert_UTC_date_to_timezone(data.created_at)
        cell.author.text=data.author
        cell.story_title.text=data.story_title
        cell.delegateOpen=self
        cell.delegate=self
   
         return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout


extension HomeViewController: UICollectionViewDelegateMagazineLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForHeaderInSectionAtIndex index: Int) -> MagazineLayoutHeaderVisibilityMode {
        return .hidden//  .visible(heightMode: .dynamic, pinToVisibleBounds: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForFooterInSectionAtIndex index: Int) -> MagazineLayoutFooterVisibilityMode {
        return .hidden//.visible(heightMode: .dynamic, pinToVisibleBounds: false)
    }
    

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
    let widthMode = MagazineLayoutItemWidthMode.fullWidth(respectsHorizontalInsets: true)//.halfWidth
    
    let heightMode = MagazineLayoutItemHeightMode.dynamic
    return MagazineLayoutItemSizeMode(widthMode: widthMode, heightMode: heightMode)
  }

 

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForBackgroundInSectionAtIndex index: Int) -> MagazineLayoutBackgroundVisibilityMode {
    return .hidden
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
    return  1
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
    return  1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForSectionAtIndex index: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
}
