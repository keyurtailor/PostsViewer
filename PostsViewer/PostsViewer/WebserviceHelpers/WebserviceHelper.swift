//
//  WebserviceHelper.swift
//  PostsViewer
//
//  Created by keyur.tailor on 22/02/21.
//  Copyright © 2021 keyur.tailor. All rights reserved.
//

import Foundation
import Alamofire
import NVActivityIndicatorView

class WebserviceHelper {
    static let shared = WebserviceHelper()
    
    typealias successClosure = (Dictionary<String, Any>) -> Void
    typealias failureClosure = (Dictionary<String, Any>) -> Void
    
    func showActivityIndicator() {
        let activityData = ActivityData.init(size: CGSize(width:50, height:50), message: "", messageFont: UIFont.systemFont(ofSize: 15.0), messageSpacing: 0.0, type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.blue, padding: 5.0, displayTimeThreshold: 0, minimumDisplayTime: 0, backgroundColor: UIColor.black.withAlphaComponent(0.2), textColor: UIColor.clear)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        }
    }
    
    func getCall(serviceURL: String, spinnerState: Bool, successCallback: successClosure?, failureCallback: failureClosure?) {
        if !NetworkReachabilityManager()!.isReachable {
            failureCallback!(["error_description":"Internet not available."])
        } else {
            if spinnerState {
                self.showActivityIndicator()
            }
            Alamofire.request(serviceURL, method: .get, parameters: nil, encoding: JSONEncoding(), headers: nil).responseJSON { (response) in
                if response.result.error != nil {
                    if spinnerState {
                        self.hideActivityIndicator()
                    }
                    failureCallback!(["error_description":response.result.error?.localizedDescription ?? "Server is not reachable."])
                } else {
                    let responseDict = response.result.value as! [String:Any]
                    if spinnerState {
                        self.hideActivityIndicator()
                    }
                    successCallback!(responseDict)
                }
            }
        }
    }
    
    func getPostsList(successCallback: successClosure?, failureCallback:failureClosure?) {
        let serviceURL = "https://jsonplaceholder.typicode.com/posts"
        
        self.getCall(serviceURL: serviceURL, spinnerState: false, successCallback: { (successDict) in
            if (successDict["errorCode"] as! String) != "" {
                failureCallback!(successDict)
            } else {
                successCallback!(successDict)
            }
        }) { (failureDict) in
            failureCallback!(failureDict)
        }
    }
}
