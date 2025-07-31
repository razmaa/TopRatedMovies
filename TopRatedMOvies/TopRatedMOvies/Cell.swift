

import UIKit

final class TVSeriesCell: UITableViewCell {
    
    static let reuseID = "TVSeriesCell"
    
    private let poster = UIImageView()
    private let title  = UILabel()
    private let blurb  = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(with show: TVSeries) {
        title.text = show.name
        blurb.text = show.overview
        poster.setTMDBImage(path: show.posterPath)
    }
    
    private func configureUI() {
        poster.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        blurb.translatesAutoresizingMaskIntoConstraints = false
        
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        poster.layer.cornerRadius = 6
        
        title.font  = .boldSystemFont(ofSize: 17)
        blurb.font  = .systemFont(ofSize: 13)
        blurb.textColor = .secondaryLabel
        blurb.numberOfLines = 3
        
        contentView.addSubview(poster)
        contentView.addSubview(title)
        contentView.addSubview(blurb)
        
        NSLayoutConstraint.activate([
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            poster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            poster.widthAnchor.constraint(equalToConstant: 80),
            
            title.leadingAnchor.constraint(equalTo: poster.trailingAnchor, constant: 12),
            title.topAnchor.constraint(equalTo: poster.topAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            blurb.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            blurb.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            blurb.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            blurb.bottomAnchor.constraint(lessThanOrEqualTo: poster.bottomAnchor)
        ])
    }
}

