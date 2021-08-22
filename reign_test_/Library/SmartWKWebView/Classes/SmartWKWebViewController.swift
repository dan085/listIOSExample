//
//  CollectionViewItemCell.swift
//  reign_test_
//
//  Created by Daniel Verdugo Gonzalez on 16-08-21.
//

import Foundation
import UIKit
import WebKit
import PanModal
import TTGSnackbar

public class SmartWKWebViewController: UIViewController,PanModalPresentable, WKNavigationDelegate, UIScrollViewDelegate {
    
    // MARK: - Public Variables
    
    public var barHeight: CGFloat = 44
    public var topMargin: CGFloat = 0//UIApplication.shared.statusBarFrame.size.height
    public var stringLoading = "Loading"
    public var url: URL!
    public var webView: WKWebView!
    public var delegate: SmartWKWebViewControllerDelegate?
    var toolbar: SmartWKWebViewToolbar!
    
    
    // MARK: - Private Variables
    
    private var backgroundBlackOverlay: UIView = {
        let v = UIView(frame: CGRect.zero);
        v.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return v;
    } ()
    
    private var isDraggingEnabled = true
    
    
    // MARK: - Initialization
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        modalPresentationStyle = .overCurrentContext
    }

    
    // MARK: - View Lifecycle
    
    public override func loadView() {
        self.view = UIView(frame: CGRect.zero)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .clearse borra porque la libreria pandal se encarga de todo
       // view.addSubview(self.backgroundBlackOverlay)
        initToolbar()
        initWebView()
        view.addObserver(self, forKeyPath: #keyPath(UIView.frame), options: .new, context: nil)
    }
    
    func initToolbar() {
        toolbar = SmartWKWebViewToolbar.init(frame: CGRect(x: 0, y: topMargin, width: UIScreen.main.bounds.width, height: barHeight))
        view.addSubview(toolbar)
        toolbar.closeButton.addTarget(self, action: #selector(closeTapped), for: UIControl.Event.touchUpInside)
        
    
    }
    
    func initWebView() {
        webView = WKWebView(frame: CGRect.zero)
        webView.backgroundColor = .white
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.allowsBackForwardNavigationGestures = true
      //  webView.scrollView.panGestureRecognizer.addTarget(self, action: #selector(panGestureActionWebView(_:)))
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        view.addSubview(webView)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toolbar.addressLabel.text = url?.absoluteString ?? ""
        toolbar.titleLabel.text = stringLoading
        
        if let URL = url {
            let urlRequest = URLRequest.init(url: URL)
            webView.load(urlRequest)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = CGRect(x: 0, y: barHeight + topMargin,
                               width: UIScreen.main.bounds.width,
                               height: self.view.frame.height - barHeight - topMargin)
        
        backgroundBlackOverlay.frame = CGRect(x: 0,
                                              y: -UIScreen.main.bounds.height,
                                              width: UIScreen.main.bounds.width,
                                              height: UIScreen.main.bounds.height * 2)
        
        toolbar.frame = CGRect(x: 0, y: topMargin, width: UIScreen.main.bounds.width, height: barHeight)
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        view.removeObserver(self, forKeyPath: #keyPath(UIView.frame))
    }
    
    
    // MARK: - Button events
    
    @objc func closeTapped() {
       // dismiss()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UIWebViewDelegate
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
  
        if navigationAction.navigationType == WKNavigationType.linkActivated {
                      //redirect to safari because the user doesn't have Telegram
                let botURL = navigationAction.request.url!
                if(botURL.absoluteString.contains("https://t.me/")){
                                    if UIApplication.shared.canOpenURL(URL.init(string:"tg://")!) {
                                       let link = botURL.absoluteString.replacingOccurrences(of: "https://t.me/", with: "",options: .regularExpression)
                                        let botURLFinal = URL.init(string: "tg://resolve?domain="+link)
                                        
                                        UIApplication.shared.open(botURLFinal!, options: [:], completionHandler: nil)
                                    
                                    } else {
                                      // Telegram is not installed.
                                        UIApplication.shared.open(botURL, options: [:], completionHandler: nil)
                                    }
                                    decisionHandler(WKNavigationActionPolicy.cancel)
                                return
                                
                                
                            }
                  }
              
        if(navigationAction.request.url!.absoluteString.contains("https://open.spotify.com/")){
                    
            if UIApplication.shared.canOpenURL(URL.init(string:"spotify://")!) {
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                        decisionHandler(WKNavigationActionPolicy.allow)
                        return
            }else{
                decisionHandler(WKNavigationActionPolicy.allow)
                return
            }
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
     
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            toolbar.gradientProgressView.progress = Float(webView.estimatedProgress)
            toolbar.gradientProgressView.isHidden = toolbar.gradientProgressView.progress == 1
        }
        
        if keyPath == "frame" {
            let alpha = 1 - (view.frame.origin.y / UIScreen.main.bounds.height)
            backgroundBlackOverlay.alpha = alpha
        }
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        toolbar.titleLabel.text = webView.title
    }
    
  
    /**
    // MARK: - ScrollView Delegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == 0 && scrollView.panGestureRecognizer.velocity(in: view).y == 0) {
            isDraggingEnabled = true
        }
    }
    
    @objc func panGestureActionWebView(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.translation(in: self.view).y < 0 {
            isDraggingEnabled = false
        }
    
        if isDraggingEnabled {
            panGestureAction(panGesture)
            webView.scrollView.contentOffset.y = 0
        }
    }**/
    
        var isShortFormEnabled = true
    
    // MARK: - Pan Modal Presentable
    public var panScrollable: UIScrollView? {
            return nil
        }

    public var shortFormHeight: PanModalHeight {
            return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
        }

    public var scrollIndicatorInsets: UIEdgeInsets {
            let bottomOffset = presentingViewController?.bottomLayoutGuide.length ?? 0
            return UIEdgeInsets(top: toolbar.frame.size.height, left: 0, bottom: bottomOffset, right: 0)
        }

    public var anchorModalToLongForm: Bool {
            return false
        }

    public func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
            let location = panModalGestureRecognizer.location(in: view)
            return toolbar.frame.contains(location)
        }

    public func willTransition(to state: PanModalPresentationController.PresentationState) {
            guard isShortFormEnabled, case .longForm = state
                else { return }

            isShortFormEnabled = false
            panModalSetNeedsLayoutUpdate()
        }
    
  
}

@objc public protocol SmartWKWebViewControllerDelegate {
    @objc optional func didDismiss(viewController: SmartWKWebViewController)
}
