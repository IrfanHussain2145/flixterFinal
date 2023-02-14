//
//  PostersViewController.swift
//  flixster
//
//  Created by Irfan Hussain on 2/9/23.
//

import UIKit
import Nuke

class PostersViewController: UIViewController, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a collection view cell (based in the identifier you set in storyboard) and cast it to our custom AlbumCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell

            // Use the indexPath.item to index into the albums array to get the corresponding album
            let poster = movies[indexPath.item]

            // Get the artwork image url
        let imageUrl = URL(string: Movie.posterBaseURLString + poster.poster_path);

            // Set the image on the image view of the cell
        Nuke.loadImage(with: imageUrl!, into: cell.posterImageView)

            return cell
    }
    
    var movies: [Movie] = [];
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        // The minimum spacing between adjacent cells (left / right, in vertical scrolling collection)
        // Set this to taste.
        layout.minimumInteritemSpacing = 4

        // The minimum spacing between adjacent cells (top / bottom, in vertical scrolling collection)
        // Set this to taste.
        layout.minimumLineSpacing = 4

        // Set this to however many columns you want to show in the collection.
        let numberOfColumns: CGFloat = 3

        // Calculate the width each cell need to be to fit the number of columns, taking into account the spacing between cells.
        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfColumns - 1)) / numberOfColumns

        // Set the size that each tem/cell should display at
        layout.itemSize = CGSize(width: width, height: width)

        
        collectionView.dataSource = self;

        // Create a search URL for fetching albums (`entity=album`)
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=293949a22b608d38951d1e2ab86aee5d")!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

            // Handle any errors
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
            }

            // Make sure we have data
            guard let data = data else {
                print("❌ Data is nil")
                return
            }

            // Create a JSON Decoder
            let decoder = JSONDecoder()
            do {
                // Try to parse the response into our custom model
                let response = try decoder.decode(MoviesResponse.self, from: data)
                let movies = response.results
                self?.movies = movies;
                DispatchQueue.main.async {
                    self?.movies = movies
                    self?.collectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }

        // Initiate the network request
        task.resume()

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the cell that triggered the segue
        if let cell = sender as? UICollectionViewCell,
           // Get the index path of the cell from the table view
           let indexPath = collectionView.indexPath(for: cell),
           // Get the detail view controller
           let detailViewController = segue.destination as? DetailViewController {

            // Use the index path to get the associated track
            let movie = movies[indexPath.row]

            // Set the track on the detail view controller
            detailViewController.movie = movie
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
