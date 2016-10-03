//
//  HTTP.swift
//  TableTest2
//
//  Created by Gazolla on 25/06/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import Foundation

open class HTTP{
    
    static func GET(_ urlString:String, completion:@escaping (_ error:Error?, _ data:Data?)->Void){
        if let request = URLRequest(urlString: urlString, method: .GET){
            connectToServer(request, completion: completion)
        } else {
            let er = NSError(domain: "com.gazapps", code: 400, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: 400)])
            completion(er, nil)
        }
    }
    
    static func connectToServer(_ request:URLRequest, completion:@escaping (_ error:Error?, _ data:Data?)->Void){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                completion( error,  nil)
            } else if let httpResponse = response as? HTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    completion( nil, data)
                } else {
                    let er = NSError(domain: "com.gazapps", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)])
                    completion( er, nil)
                }
            }
        }) .resume()
    }
}

extension URLRequest {
    public  init?(urlString:String, method:HTTPVerb, body:Data?=nil){
        if let url = URL(string: urlString){
            self.init(url:url)
            self.addValue("aplpication/json", forHTTPHeaderField: "Content-type")
            self.addValue("application/json", forHTTPHeaderField: "Accept")
            self.httpBody = body
            self.httpMethod = method.rawValue
        } else {
            return nil
        }
    }
}


public enum HTTPVerb:String{
    case GET
    case POST
    case DELETE
    case PUT
}
