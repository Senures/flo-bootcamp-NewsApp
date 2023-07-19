//
//  ApiClient.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 25.06.2023.
//

import Foundation
import Alamofire

class ApiClient{
    
    static let apiClient = ApiClient()
    
    private init() {
        print("apiclient calıstıııı")
    }
    
    
    func fetchTopHeadLines(succesData: @escaping (NewsResponseModel) -> Void){
        let baseUrl = String(format: "%@%@%@",Constants.baseURL,"/top-headlines?sources=techcrunch&apiKey=",Constants.apiKey)
        AF.request(baseUrl, method:.get, encoding:JSONEncoding.default, headers: nil, interceptor: nil).response{
            (responseData) in
            guard let data = responseData.data else { return }
            do{
                let topHeadlinesModel = try? JSONDecoder().decode(NewsResponseModel.self, from: data)
                succesData(topHeadlinesModel!)
                
            } catch {
                print("catch bloğu")
                
            }
            
        }
        
    }
    
    
    //TREND NEWWSS APİİ CEKİLDİGİ YER
    func fetchTrendNews(succesData: @escaping (NewsResponseModel) -> Void){
        
        let baseUrl = String(format: "%@%@%@",Constants.baseURL,"/top-headlines?country=us&category=business&apiKey=",Constants.apiKey)
        AF.request(baseUrl, method:.get, encoding:JSONEncoding.default, headers: nil, interceptor: nil).response{
            (responseData) in
            
            guard let data = responseData.data else { return }
            
            do{
                let topHeadlinesModel = try? JSONDecoder().decode(NewsResponseModel.self, from: data)
                succesData(topHeadlinesModel!)
                print(topHeadlinesModel?.articles)
            } catch {
                
                print("catch bloğu")
                
            }
            
        }
        
    }
    
    //recommendation list
    func fetchRecommendationNews(succesData: @escaping (NewsResponseModel) -> Void){
        
        let baseUrl = String(format: "%@%@%@",Constants.baseURL,"/everything?domains=wsj.com&apiKey=",Constants.apiKey)
        AF.request(baseUrl, method:.get, encoding:JSONEncoding.default, headers: nil, interceptor: nil).response{
            (responseData) in
            
            guard let data = responseData.data else { return }
            
            do{
                let topHeadlinesModel = try? JSONDecoder().decode(NewsResponseModel.self, from: data)
                succesData(topHeadlinesModel!)
                print(topHeadlinesModel?.articles)
            } catch {
                
                print("catch bloğu")
                
            }
            
        }
        
    }
    
    //search yapılınca çalışan fonk
    func search(params:String, succesData: @escaping (NewsResponseModel) -> Void)  {
        
        let baseUrl = String(format: "%@%@%@%@%@",Constants.baseURL,"/everything?q=", String(params),"&apiKey=",Constants.apiKey)
        
        AF.request(baseUrl, method:.get, encoding:JSONEncoding.default, headers: nil, interceptor: nil).response{
            (responseData) in
            guard let data = responseData.data else { return }
            do{
                
                let data = try JSONDecoder().decode(NewsResponseModel.self, from: data)
                succesData(data)
                
            } catch {
                print("catch bloğu")
            }
        }
    }
    
    
}
