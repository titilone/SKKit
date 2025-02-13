//
//  SKHttpRequest.swift
//  OleLife
//
//  Created by Admin on 2025/2/12.
//

import Foundation
import Alamofire

//json数据里面的字段和model字段不一致
//1实现 enum CodingKeys: String, CodingKey {}这个映射关系
//下例：如果后台返回的字段名称叫做nick_name，但是你想用自己命名的nick，就可以用到上述枚举中的映射去替换你想要的字段名字
//struct UserModel:Codable {
//    var age:    Int?
//    var nick: String?
//    enum CodingKeys: String, CodingKey {
//        case age
//        case nick = "nick_name"
//    }
//}

//2模型里面带有嵌套关系，比如你的模型里面有个其他模型或者模型数组，那么只要保证嵌套的模型里面依然实现了对应的协议
//struct UserModel:Codable {
//    var nick: String?
//    var books_op:   [BookModel]?
//    enum CodingKeys: String, CodingKey {
//        case nick = "nick_name"
//    }
//}
// BookModel
//struct BookModel:Codable {
//    var name:String ?
//}

class SKHttpRequest {
    
    static let shared = SKHttpRequest()
    
    //域名:对应的证书路径。需要本地证书就先传递此数据自定义AF
    static var serverDomains_cerPaths:[String:String] = [:]
    
    var AF:Session!

    private init() {
        var evaluators: [String: ServerTrustEvaluating] = [:]
        //需要本地证书就自定义AF
        SKHttpRequest.serverDomains_cerPaths.forEach { (serverDomain,cerPath) in
            if let _ = URL(string: serverDomain),
               let certificateData = try? Data(contentsOf: URL(fileURLWithPath: cerPath)),
               let certificate = SecCertificateCreateWithData(nil, certificateData as CFData){
                evaluators[serverDomain] = PinnedCertificatesTrustEvaluator(certificates: [certificate])
            }
            if (!evaluators.isEmpty){
                let serverTrustManager = ServerTrustManager(evaluators: evaluators)
                AF = Session(serverTrustManager: serverTrustManager)
            }
        }
        
        if AF == nil {
            AF = Session.default
        }
        
        AF.sessionConfiguration.timeoutIntervalForRequest = 100
        AF.sessionConfiguration.headers.add(name: "Accept", value: "application/json")
        AF.sessionConfiguration.headers.add(name: "Content-Type", value: "application/json; charset=utf-8")
    }

    //T需要遵守协议Codable，结构体，枚举，类都可以遵守这个协议，一般使用struct
    func request<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .validate()//contentType: ["application/json", "text/plain"]
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func get<T: Decodable>(
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(url, method: .get, parameters: parameters, headers: headers, completion: completion)
    }

    func post<T: Decodable>(
        _ url: String,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(url, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    func upload(
        _ url: String,
        data: Data,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        AF.upload(data, to: url, headers: headers)
            .validate()
            .responseString { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

//网络是否可用
extension SKHttpRequest {
    var isReachable: Bool {
        return SKReachability.shared.isReachable
    }

    func checkNetworkBeforeRequest(completion: @escaping (Bool) -> Void) {
        if isReachable {
            completion(true)
        } else {
            completion(false)
        }
    }
}
