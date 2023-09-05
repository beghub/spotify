//
//  APICaller.swift
//  Spotify
//
//  Created by Begüm Tüzüner on 12.07.2023.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    private init(){
        
    }
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
           createRequest(
               with: URL(string: Constants.baseAPIURL + "/albums/" + album.id),
               type: .GET) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else{
                       completion(.failure(APIError.failedToGetData))
                       return
                   }
                   do{
                       let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                       completion(.success(result))
                   }
                   catch{
                       print("Checking Error at API Caller Level: \(error)")
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse,Error>)-> Void){
            createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/" + playlist.id),
                          type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                    do{
                        let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                        print(result)
                        completion(.success(result))
                    }
                    catch{
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
        }
    
    // MARK: - Profile
    
    public func getCurrentUserProfile(completion:  @escaping (Result<UserProfile, Error>) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/me"), type: .GET){
            baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest){data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do{
                    let result = try
                    JSONDecoder().decode(UserProfile.self, from: data)
                    //print(result)
                    completion(.success(result))
                }
                catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: -Browse
    
    public func getNewReleases(completion: @escaping((Result<NewReleasesResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?llimit=20"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(APIError.failedToGetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                //print(result)
                completion(.success(result))
            }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getFeaturePlaylists(completion: @escaping((Result<FeaturedPlaylistResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=20"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(APIError.failedToGetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(FeaturedPlaylistResponse.self, from: data)
                //print(result)
                completion(.success(result))
            }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping((Result<RecommendedGenresResponse, Error>)) -> Void){
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request){data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(APIError.failedToGetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                //JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print(result)
                completion(.success(result))
            }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String>,completion: @escaping((Result<RecommendationsResponse, Error>)) -> Void){
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?limit=20&seed_genres=\(seeds)"), type: .GET){ request in
            //print(request.url?.absoluteString)
            let task = URLSession.shared.dataTask(with: request){data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(APIError.failedToGetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                //print(result)
                //JSONSerialization.jsonObject(with: data, options: .allowFragments)
                completion(.success(result))
            }
                catch{
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Category
       public func getCategories(completion: @escaping (Result<[Category],Error>) -> Void){
           createRequest(
               with: URL(string: Constants.baseAPIURL + "/browse/categories?limit=50"),
               type: .GET) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else {
                       completion(.failure(APIError.failedToGetData))
                       return
                   }
                   do{
                       let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
                       //JSONSerialization.jsonObject(with: data, options: .allowFragments)
                       completion(.success(result.categories.items))
                       
                   }
                   catch{
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }
       public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void){
           createRequest(
               with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?limit=50"),
               type: .GET) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else {
                       completion(.failure(APIError.failedToGetData))
                       return
                   }
                   do{
                       let result = try JSONDecoder().decode(CategoryPlaylistResponse.self, from: data)
                       let playlists = result.playlists.items
                       completion(.success(playlists))
                   }
                   catch{
                       print(error)
                       completion(.failure(error))
                   }
               }
               task.resume()    
           }
       }
    
    //MARK: - Search
       public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
           createRequest(with: URL(string:
                                       Constants.baseAPIURL + "/search?limit=15&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
                         type: .GET) { request in
               let task = URLSession.shared.dataTask(with: request) { data, _, error in
                   guard let data = data, error == nil else{
                       completion(.failure(APIError.failedToGetData))
                       return
                   }
                   do{
                       let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                       var searchResults: [SearchResult] = []
                       searchResults.append(contentsOf: result.tracks.items.compactMap({ SearchResult.track(model: $0)}))
                       searchResults.append(contentsOf: result.albums.items.compactMap({ SearchResult.album(model: $0)}))
                       searchResults.append(contentsOf: result.artists.items.compactMap({ SearchResult.artist(model: $0)}))
                       searchResults.append(contentsOf: result.playlists.items.compactMap({ SearchResult.playlist(model: $0)}))
                       
                       completion(.success(searchResults))
                   }
                   catch{
                       print(error)
                       completion(.failure(error))
                   }
               }
               task.resume()
           }
       }
    
    // MARK: -Private
    
    enum HTTPMethod: String{
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void){
        AuthManager.shared.wihValidToken{ token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
}
