//
//  HTTP.swift
//  TableTest2
//
//  Created by Gazolla on 25/06/16.
//  Copyright © 2016 Gazolla. All rights reserved.
//

import Foundation

public class HTTP{
    
    static func GET(urlString:String, completion:(error:NSError?, data:NSData?)->Void){
        if let request = NSMutableURLRequest(urlString: urlString, method: .GET){
            connectToServer(request, completion: completion)
        } else {
            let er = NSError(domain: "com.gazapps", code: 400, userInfo: [NSLocalizedDescriptionKey: NSHTTPURLResponse.localizedStringForStatusCode(400)])
            completion(error: er, data: nil)
        }
    }
    
    static func connectToServer(request:NSMutableURLRequest, completion:(error:NSError?, data:NSData?)->Void){
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                completion(error: error, data: nil)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if 200...299 ~= httpResponse.statusCode {
                    completion(error: nil, data: data)
                } else {
                    let er = NSError(domain: "com.gazapps", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)])
                    completion(error: er, data: nil)
                }
            }
        }.resume()
    }
}

extension NSMutableURLRequest {
    public convenience init?(urlString:String, method:HTTPVerb, body:NSData?=nil){
        if let url = NSURL(string: urlString){
            self.init(URL:url)
            self.addValue("aplpication/json", forHTTPHeaderField: "Content-type")
            self.addValue("application/json", forHTTPHeaderField: "Accept")
            self.HTTPBody = body
            self.HTTPMethod = method.rawValue
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
