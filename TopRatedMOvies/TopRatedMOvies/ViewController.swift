//
//  ViewController.swift
//  TopRatedMOvies
//
//  Created by nika razmadze on 01.08.25.
//

import UIKit

final class TopRatedViewController: UITableViewController {
    
    private var shows: [TVSeries] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top-Rated TV"
        tableView.register(TVSeriesCell.self, forCellReuseIdentifier: TVSeriesCell.reuseID)
        fetch()
    }
    
    private func fetch() {
        Task {
            do {
                shows = try await TMDBClient.shared.fetchTopRated()
                tableView.reloadData()
            } catch {
                presentAlert(error)
            }
        }
    }
    
    private func presentAlert(_ error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int { shows.count }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVSeriesCell.reuseID,
                                                 for: indexPath) as! TVSeriesCell
        cell.configure(with: shows[indexPath.row])
        return cell
    }
}


extension UIImageView {
    func setTMDBImage(path: String?) {
        guard let path = path,
              let url  = URL(string: TMDB.imageBase + path) else {
            self.image = UIImage(systemName: "photo.fill")
            return
        }
        
        if let cached = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            self.image = cached
            return
        }
        
        Task.detached { @MainActor in
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let img = UIImage(data: data) {
                    ImageCache.shared.setObject(img, forKey: url.absoluteString as NSString)
                    self.image = img
                } else {
                    self.image = UIImage(systemName: "exclamationmark.triangle")
                }
            } catch {
                self.image = UIImage(systemName: "exclamationmark.triangle")
            }
        }
    }
}

final class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

