//
//  HomeViewModel.swift
//  Flo-News-App
//
//  Created by Semanur Eserler on 21.07.2023.
//

import Foundation
import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func trendNewsFetched(_ articles: [Article])
    func topHeadlinesFetched(_ articles: [Article])
    func recommendationNewsFetched(_ articles: [Article])
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?
    //yukarıdaki protocol func buraya  etmek icin
    func fetchTrendNews() {
        ApiClient.apiClient.fetchTrendNews { response in
            if let articles = response.articles {
                self.delegate?.trendNewsFetched(articles)
            } else {
                self.delegate?.trendNewsFetched([])
            }
        }
    }
    
    func fetchTopHeadlines() {
        ApiClient.apiClient.fetchTopHeadLines { response in
            if let articles = response.articles {
                self.delegate?.topHeadlinesFetched(articles)
            } else {
                self.delegate?.topHeadlinesFetched([])
            }
        }
    }
    
    func fetchRecommendationNews() {
        ApiClient.apiClient.fetchRecommendationNews { response in
            if let articles = response.articles {
                self.delegate?.recommendationNewsFetched(articles)
            } else {
                self.delegate?.recommendationNewsFetched([])
            }
        }
    }
}
