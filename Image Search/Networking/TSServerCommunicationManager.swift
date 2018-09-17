//
//  TSServerCommunicationManager.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org>



import UIKit

/// <#Description#>
///
/// - Success: <#Success description#>
/// - Failure: <#Failure description#>
/// - Error: <#Error description#>
enum Result <T>{
    case Success(T)
    case Failure(String)
    case Error(String)
}

/// <#Description#>
///
/// - get: <#get description#>
/// - post: <#post description#>
/// - put: <#put description#>
enum RequestMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
}

/// <#Description#>
class TSServerCommunicationManager: NSObject {
    static let shared = TSServerCommunicationManager()
    private override init() {
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - urlString: <#urlString description#>
    ///   - completion: <#completion description#>
    func downloadImage(urlString: String,completion: @escaping (Result<UIImage>) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        guard let url =  URL.init(string: urlString) else {
            return completion(.Failure(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
        }
        
        guard (Reachability()?.currentReachabilityStatus != .notReachable) else {
            return completion(.Failure(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.noInternetConnection))
        }
        
        session.downloadTask(with: url) { (url, reponse, error) in
            do {
                guard let url = url else {
                    return completion(.Failure(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
                }
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    return completion(.Success(image))
                } else {
                    return completion(.Failure(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
                }
            } catch {
                return completion(.Error(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
            }
        }.resume()
        
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - request: <#request description#>
    ///   - completion: <#completion description#>
    func executeRequest(request: Request,completion: @escaping (Result<[String: Any]>) -> Void) {
        
        guard (Reachability()?.currentReachabilityStatus != .notReachable) else {
            return completion(.Failure(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.noInternetConnection))
        }
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else{
                return completion(.Error(error!.localizedDescription))
            }
            guard let data = data else {
                return completion(.Error(error?.localizedDescription ?? TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
            }
            do {
                guard let stringResponse = String(data: data, encoding: String.Encoding.utf8) else {
                    return completion(.Error(error?.localizedDescription ?? TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
                }
                var dataReponnse = stringResponse.replacingOccurrences(of: "jsonFlickrApi(", with: "")
                dataReponnse = String(dataReponnse.dropLast())
                if let jsonDict = try JSONSerialization.jsonObject(with: dataReponnse.data(using: String.Encoding.utf8)!) as? [String: Any] {
                    if let stat = jsonDict["stat"] as? String{
                        if stat.uppercased().contains("OK") {
                            return completion(.Success(jsonDict))
                        }
                        else{
                            return completion(.Failure(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
                        }
                    } else{
                        return completion(.Failure(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
                    }
                }
                else{
                    return  completion(.Error(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
                }
            } catch {
                return completion(.Error(TSAppConstants.Networking.TSServerCommunicationManager.ErrorMessages.somethingWentWrong))
            }
        }.resume()
    }
}


/// <#Description#>
class Request : NSMutableURLRequest {
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - requestMethod: <#requestMethod description#>
    ///   - urlString: <#urlString description#>
    ///   - bodyParams: <#bodyParams description#>
    convenience init?(requestMethod:RequestMethod,urlString: String,
                      bodyParams: [String: Any]? = nil) {
        guard let url =  URL.init(string: urlString) else {
            return nil
        }
        self.init(url: url)
        do{
            if let bodyParams = bodyParams{
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                self.httpBody = data
            }
        }catch{}
        self.httpMethod = requestMethod.rawValue
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
}

