//
//  ViewController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 01/05/23.
//

import UIKit
import MusicKit
import SDWebImage
import SwiftEntryKit
import SkeletonView
import LNPopupController

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    static var queueDelegate: MusicPlayerQueueDelegate?
    
    let searchController = UISearchController()
    
    var musicSubscription: MusicSubscription?
    
    var songItems: MusicItemCollection<Song> = []
    
    //TODO: -
    
    //Add like button to the cell.
    //Customize the appearance.
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SongsTableViewCell.self, forCellReuseIdentifier: "songCell")
        tableView.rowHeight = 85
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
    }()
    
    
    //TODO: CREATE NETWORK CALL FUNCTION
    
    //TODO: CHECK THE USER'S MUSIC SUBSCRIPTION AFTER MUSIC AUTHORIZATION
    
    //TODO: SOURCE CONTROL AND GIT
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        view.backgroundColor = UIColor.appBackgroundColor
        tableView.backgroundColor = UIColor.white
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        //Customizing Search Bar
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white

        }
        
        //Changes the color of the search bar cancel button
        searchController.searchBar.tintColor = UIColor.white
        
        //End
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        tableView.isSkeletonable = true
        tableView.dataSource = self
        tableView.delegate = self
        
        var request = MusicCatalogSearchRequest(term: "Colors", types: [Song.self])
        request.limit = 25
        request.offset = 25
        if #available(iOS 16.0, *) {
            request.includeTopResults = true
        } else {
            // Fallback on earlier versions
        }
        
        
        DispatchQueue.global().async { [weak self] in
           
            guard let self = self else {return}
            self.searchMusic(request)
        }
        
    }
   
    func updateSearchResults(for searchController: UISearchController) {

        if searchController.searchBar.text != "" {
            songItems = []
            var request = MusicCatalogSearchRequest(term: searchController.searchBar.text!, types: [Song.self])
            
            //Pagination
            request.limit = 25
            if #available(iOS 16.0, *) {
                request.includeTopResults = true
            } else {
                // Fallback on earlier versions
            }
            DispatchQueue.global().async { [weak self] in
                
                guard let strongSelf = self else {return}
                strongSelf.searchMusic(request)
            }
        }
        
    }
    
    
    //clean the music request
    func searchMusic(_ request: MusicCatalogSearchRequest) {
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else {return}
            strongSelf.tableView.showSkeleton(usingColor: .concrete, transition: .crossDissolve(0.5))
        }
        
        Task {
            
            //Request Permission
            let status = await MusicAuthorization.request()
            
            switch status {

            case .authorized:
                print("Permission granted.")
//                Request -> Response
                do {
                    let result = try await request.response()
                    
                    self.songItems = result.songs
                    
                    if result.songs.hasNextBatch == true {
                        print("True")
                    }
                    
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.hideSkeleton()
                        self.tableView.reloadData()
                        
                    }


                } catch {
                    print(String(describing: error))
                }
                break
                
            case .denied:
                print("Permission denied.")
                return

            default:
                return
            }
            
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, SkeletonTableViewDataSource  {
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songItems.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "songCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongsTableViewCell
        
        let songItem = songItems[indexPath.row]
        
        cell.artworkImageView.sd_setImage(with: songItem.artwork?.url(width: 200, height: 200))
        cell.songTitle.text = songItem.title
        cell.songArtist.text = songItem.artistName
        cell.selectionStyle = .none
    
        
        return cell
    }
    
    
    
    @objc private func dismissBar() {
        print(#function)
        tabBarController?.dismissPopupBar(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if musicSubscription?.canPlayCatalogContent == true {
        
        
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        searchController.searchBar.resignFirstResponder()
        
        let song = songItems[indexPath.row]
        
        let musicPlayerController = MusicPlayerController()
        musicPlayerController.currentSong = song
        let cell = tableView.cellForRow(at: indexPath) as! SongsTableViewCell
        musicPlayerController.popupItem.image = cell.artworkImageView.image
        musicPlayerController.popupItem.title = song.title
        musicPlayerController.popupItem.subtitle = song.artistName
        
        
        let songId = song.id.rawValue
        
        DispatchQueue.main.async {
            
                musicPlayerController.player.setQueue(with: [songId])
                musicPlayerController.player.play()
        }
            
            guard let artwork = song.artwork else {return}
            
        
            let artworkUrl = artwork.url(width: artwork.maximumWidth, height: artwork.maximumHeight)
            musicPlayerController.recordView.sd_setImage(with: artworkUrl) { image, _, _, _ in

                musicPlayerController.backgroundImage.image = image
        }
            
        
        tabBarController?.presentPopupBar(withContentViewController: musicPlayerController, animated: true)
        tabBarController?.popupBar.tintColor = UIColor.greenCyan
        tabBarController?.popupBar.progressViewStyle = .top
       

        
//        } else {
//
//            EKCustomPresentation(
//                animationType: EKAttributes.topFloat,
//                titleText: "Apple Music Required", descriptionText: "You need an active Apple Music subscription to use play music in the app.",
//                gradientColor1: UIColor(red: 180 / 255, green: 34 / 255, blue: 64 / 255, alpha: 1),
//                gradientColor2: UIColor(red: 200 / 255, green: 54 / 255, blue: 81 / 255, alpha: 1),
//                startPoint: CGPoint(x: 0, y: 0.5),
//                endPoint: CGPoint(x: 1, y: 0.5),
//                titleFont: UIFont.systemFont(ofSize: 20, weight: .medium),
//                descriptionFont: UIFont.systemFont(ofSize: 16, weight: .medium)
//            )
//
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let contextConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let like = UIAction(
                title: "Add to favorites",
                image: UIImage(systemName: "heart"),
                state: .off
            ) { _ in
                print("Song liked.")
            }
            
            let queue = UIAction(
                title: "Add to queue",
                image: UIImage(systemName: "line.3.horizontal"),
                state: .off
            )
            { [weak self] _ in

                guard let strongSelf = self else {return}

                let song = strongSelf.songItems[indexPath.row]
                SearchViewController.queueDelegate?.addToQueue(id: song.id.rawValue, song: song)

            }
            
            let play = UIAction(
                title: "Play song",
                image: UIImage(systemName: "play"),
                state: .off
            ) { _ in
                print("Play song.")
            }
            
            
            ///typealias UIContextMenuActionProvider = ([UIMenuElement]) -> UIMenu?
            return UIMenu(
                options: .displayInline,
                children: [like, queue, play]
            )
            
        }
        
        return contextConfiguration
    }
    
}



//MARK: - Queue Protocol

protocol MusicPlayerQueueDelegate: AnyObject {
    func addToQueue(id: String, song: Song)
    
}

