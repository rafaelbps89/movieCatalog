//
//  FirstViewController.swift
//  MoviesCatalog
//
//  Created by Rafael Brasileiro on 25/10/18.
//  Copyright © 2018 Rafael Brasileiro. All rights reserved.
//

import UIKit

// Estruturas para organizar informações do objeto JSON disponibilizado pela API
struct MovieDBInfo: Decodable {
    
    let page: Int
    let results: [Result]
    let dates: MyDate
    let totalPages: Int
    let totalResults: Int
}

struct Result: Decodable {
    
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String // 2018-10-03
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let backdropPath: String?
    let popularity: Double
    let voteCount: Int
    let video: Bool
    let voteAverage: Float
}

struct MyDate: Decodable {
    
    let maximum: String
    let minimum: String
}

// TAB 1 - View Controller
// Lista de filmes Em Cartaz
class NowPlayingViewController: UITableViewController {
    
    var movieDBInfo = MovieDBInfo.init(page: 1, results: [Result](), dates: MyDate(maximum: "1", minimum: ""), totalPages: 1, totalResults: 1)
    
    @IBAction func searchMovie() {}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        decodeJSON()
    }
    
    // Número de linhas da lista corresponde ao número de filmes Em Cartaz
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movieDBInfo.results.count
    }
    
    // Para cada linha associada a uma célula
    // Utilizar as informações do JSON já tratado e armazenado nas estruturas
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(for: tableView)
        
        for i in movieDBInfo.results.startIndex..<movieDBInfo.results.endIndex {
            let title = movieDBInfo.results[i].title
            let detail = "RD: \(movieDBInfo.results[i].releaseDate)        VA: \(movieDBInfo.results[i].voteAverage)"
            if indexPath.row == i {
                cell.textLabel!.text = title
                cell.detailTextLabel!.text = detail
                let imageUrlString = "https://image.tmdb.org/t/p/w92" + movieDBInfo.results[i].posterPath!
                let imageUrl = URL(string: imageUrlString)!
                let imageData = NSData(contentsOf: imageUrl)!
                cell.imageView!.image = UIImage(data: imageData as Data)
            }
        }
        return cell
    }
    
    // Ao clicar em uma célula
    // Abrir um View Controller com os Detalhes do filme
    // --- TO DO
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "Movie Details", sender: nil)
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    // Função para fazer requimento a API e decodificar JSON
    func decodeJSON() {
        
        let jsonUrlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=977ffaa7487799f2f94b72fde4fdfd10&language=en-US&page=1"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Tratar error // --- TO DO
            // Tratar response // --- TO DO
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                // Converte snake_case para camelCase // Swift 4.1
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                self.movieDBInfo = try decoder.decode(MovieDBInfo.self, from: data)
                self.tableView.reloadData()
                
            } catch let jsonError {
                print("Failed decoding json:", jsonError)
            }}.resume()
        
    }
}


