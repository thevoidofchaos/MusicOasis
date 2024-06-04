//
//  MusicPlayerController.swift
//  MusicApp
//
//  Created by Kushagra Shukla on 02/05/23.
//

import Foundation
import UIKit
import SDWebImage
import LNPopupController
import MusicKit
import MediaPlayer
import AVFoundation

class MusicPlayerController: UIViewController, MusicPlayerQueueDelegate {
   
    /* TRY:
     
     1. let player = MPMusicPlayerController.applicationMusicPlayer
     2. remove Apple Music Key from Info.plist and authorization too.
     3. AVSession code already setup.
     
     
     class MPMusicPlayerController
     An object that plays audio media items from the device’s Music app library.
     (from documentation)
     I guess using the MPMusicPlayerController itself to play audio is hindering the screen recording.
     */
    
    let player = MPMusicPlayerController.applicationQueuePlayer
    
    /*
     IMPORTANT!
     Only use a music player on the app’s main thread.
     */
    
    var currentSong: Song?
    var songItems: MusicItemCollection<Song> = []
    
    let songLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Song name"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.textColor = UIColor.white
      
        
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Artist name"
        label.font = UIFont(name: "HelveticaNeue", size: 18)
       
        
        return label
    }()
    
    let controlView: UIView = {
        let controlView = UIView()
        controlView.translatesAutoresizingMaskIntoConstraints = false
        
        return controlView
    }()
    
    let musicSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = UIColor.celadonGreen
        slider.thumbTintColor = UIColor.white
        
        return slider
    }()
    
    let shuffleButton: UIButton  = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "shuffle"), for: .normal)
        button.tintColor = UIColor.gray
        return button
    }()
    
    let previousButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(systemName: "backward.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        button.tintColor = UIColor.white
        button.addGestureRecognizer(UIGestureRecognizer(target: button, action: #selector(rewindPressed)))
        
        return button
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.greenCyan
        button.setImage(UIImage(systemName: "pause")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)), for: .normal)
        button.tintColor = UIColor.white
        
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(systemName: "forward.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        button.tintColor = UIColor.white
        
        return button
    }()
    
    let repeatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "repeat"), for: .normal)
        button.tintColor = UIColor.gray
        
        return button
    }()
    
    
    var recordView = CustomRecordView()
    
    var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .center
        return image
    }()
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.effect = UIBlurEffect(style: .systemMaterial)
        
        return view
    }()
    
    var songTimer: Timer?

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        musicSlider.layer.cornerRadius = musicSlider.frame.height/2
        previousButton.layer.cornerRadius = previousButton.frame.height/2
        playPauseButton.layer.cornerRadius = playPauseButton.frame.height/2
        nextButton.layer.cornerRadius = nextButton.frame.height/2
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
            //MARK: - Player and UI
        if currentSong?.id != nil {
            
            if let safeSong = currentSong {
                
                    musicSlider.maximumValue = Float((safeSong.duration)!)
                    artistLabel.text = safeSong.artistName
                    songLabel.text = safeSong.title
                    
                    songTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                }
            }
            
            else {
                recordView.image = UIImage(named: "weeknd")
            }
            
            //END
            
         
        
    }
    
    func getSong(with request: MusicCatalogResourceRequest<Song>) async {
        
        let status = await MusicAuthorization.request()

        switch status {
        case .authorized:
            
            do {
                let result = try await request.response()
                currentSong = result.items.first
                
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.updateUI(with: strongSelf.currentSong)
                }
            } catch {
                print(String(describing: error))
            }
            
        case .denied:
            print("Permission denied.")

        default:
            return
        }
    }
    
    private func updateUI(with song: Song?) {
        guard let song = song else { return }
        
        artistLabel.text = song.artistName
        songLabel.text = song.title
        musicSlider.value = 0
        
        guard let artwork = song.artwork else {return}
        
        let artworkUrl = artwork.url(width: artwork.maximumWidth, height: artwork.maximumHeight)
        recordView.sd_setImage(with: artworkUrl) { [weak self] image, _, _, _ in
            self?.backgroundImage.image = image
        }
        
        popupItem.title = song.title
        popupItem.subtitle = song.artistName
        let view = UIImageView()
        let _ = view.sd_setImage(with: song.artwork?.url(width: 200, height: 200)) { [weak self] image, _, _, _ in
            self?.popupItem.image = image
        }
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        
        SearchViewController.queueDelegate = self
        
        //MARK: - LNPopupController popupItem
        
        
        let previous = UIBarButtonItem(image: UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small)), style: .plain, target: #selector(previousPressed), action: nil)
        
        let pause = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: #selector(playPausePressed), action: nil)
        
        let next = UIBarButtonItem(image: UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small)), style: .plain, target: #selector(nextPressed), action: nil)
        
        previous.tintColor = #colorLiteral(red: 0.03529411765, green: 0.5882352941, blue: 0.4235294118, alpha: 1)
        pause.tintColor = #colorLiteral(red: 0.03529411765, green: 0.5882352941, blue: 0.4235294118, alpha: 1)
        next.tintColor = #colorLiteral(red: 0.03529411765, green: 0.5882352941, blue: 0.4235294118, alpha: 1)
        popupItem.leadingBarButtonItems = [ previous, pause]
        popupItem.trailingBarButtonItems = [next]
        
        //END
        
        //MARK: - CONSTRAINTS
        
        view.addSubview(backgroundImage)
        backgroundImage.addSubview(blurView)
        
        NSLayoutConstraint.activate([
        
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blurView.topAnchor.constraint(equalTo: backgroundImage.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: backgroundImage.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundImage.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor),
        
        ])


        
        //VINYL RECORD
        
        view.addSubview(recordView)
        recordView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recordView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            recordView.widthAnchor.constraint(equalToConstant: 310),
            recordView.heightAnchor.constraint(equalToConstant: 310),
            recordView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        
        view.addSubview(controlView)
        view.addSubview(songLabel)
        view.addSubview(artistLabel)
        controlView.addSubview(musicSlider)
        controlView.addSubview(shuffleButton)
        controlView.addSubview(previousButton)
        controlView.addSubview(playPauseButton)
        controlView.addSubview(nextButton)
        controlView.addSubview(repeatButton)
        
        
        NSLayoutConstraint.activate([
            
            songLabel.topAnchor.constraint(equalTo: recordView.bottomAnchor, constant: 50),
            songLabel.heightAnchor.constraint(equalToConstant: 30),
            songLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            songLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            artistLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 10),
            artistLabel.heightAnchor.constraint(equalToConstant: 30),
            artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            artistLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            controlView.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 50),
            controlView.heightAnchor.constraint(equalToConstant: 200),
            controlView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            controlView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            musicSlider.leadingAnchor.constraint(equalTo: controlView.leadingAnchor, constant: 10),
            musicSlider.heightAnchor.constraint(equalToConstant: 5),
            musicSlider.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -10),
            musicSlider.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 20),
            
            shuffleButton.trailingAnchor.constraint(equalTo: previousButton.leadingAnchor, constant: -20),
            shuffleButton.heightAnchor.constraint(equalToConstant: 40),
            shuffleButton.widthAnchor.constraint(equalToConstant: 40),
            shuffleButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor),
            
            previousButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -20),
            previousButton.heightAnchor.constraint(equalToConstant: 50),
            previousButton.widthAnchor.constraint(equalToConstant: 50),
            previousButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor),
            
            playPauseButton.centerXAnchor.constraint(equalTo: controlView.centerXAnchor),
            playPauseButton.heightAnchor.constraint(equalToConstant: 80),
            playPauseButton.widthAnchor.constraint(equalToConstant: 80),
            playPauseButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor),
            
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.widthAnchor.constraint(equalToConstant: 50),
            nextButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor),
            
            repeatButton.leadingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 20),
            repeatButton.heightAnchor.constraint(equalToConstant: 40),
            repeatButton.widthAnchor.constraint(equalToConstant: 40),
            repeatButton.centerYAnchor.constraint(equalTo: controlView.centerYAnchor)
            
            
        ])
        
        rotateView(view: recordView, duration: 4)
        
        //END
        
        
        //MARK: - Add actions
        musicSlider.addTarget(self, action: #selector(sliderDragged), for: .valueChanged)
        shuffleButton.addTarget(self, action: #selector(shufflePressed), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousPressed), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(playPausePressed), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        repeatButton.addTarget(self, action: #selector(repeatPressed), for: .touchUpInside)
        
        //END
        

        // Configure the audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Handle any errors that occur during audio session configuration
        }
        
        
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            songLabel.textColor = UIColor.white
            artistLabel.textColor = UIColor.lightGray
            previousButton.tintColor = UIColor.white
            nextButton.tintColor = UIColor.white
            musicSlider.tintColor = UIColor.celadonGreen
            
        } else {
            songLabel.textColor = UIColor.black
            artistLabel.textColor = UIColor.darkGray
            previousButton.tintColor = UIColor.black
            nextButton.tintColor = UIColor.black
            musicSlider.tintColor = UIColor.celadonGreen
            
        }
    }
    
    
    //MARK: - Actions
    
    @objc private func updateTime() {
        DispatchQueue.main.async { [weak self] in
            
            guard let strongSelf = self else {return}
            strongSelf.musicSlider.value = Float(strongSelf.player.currentPlaybackTime)
        }
    }
    
    
    @objc private func sliderDragged()  {
        print(#function)
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.player.currentPlaybackTime = TimeInterval(strongSelf.musicSlider.value)
        }
    }
    
    
    @objc private func playPausePressed() {
        
        
        if player.playbackState == .playing {
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else {return}
                
                strongSelf.player.pause()
                strongSelf.playPauseButton.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)), for: .normal)
                strongSelf.musicSlider.value = Float((strongSelf.player.currentPlaybackTime))
                
            }
            
        } else {
            
            DispatchQueue.main.async { [weak self] in
                
                guard let strongSelf = self else {return}
                
                strongSelf.player.play()
                strongSelf.playPauseButton.setImage(UIImage(systemName: "pause")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 40, weight: .medium)), for: .normal)
                strongSelf.musicSlider.value = Float((strongSelf.player.currentPlaybackTime))
                
            }
        }
        
    }
    
    @objc private func nextPressed()  {
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else{return}
            
            strongSelf.player.skipToNextItem()
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
            Task.detached {
                if let id = strongSelf.player.nowPlayingItem?.playbackStoreID {
                    let musicItem = MusicItemID(id)
                    let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: musicItem)
                    await strongSelf.getSong(with: request)
                }
            }
        }
    }
    
    
    @objc private func previousPressed(){
        DispatchQueue.main.async {
            self.player.skipToPreviousItem()
        }
    }
    
    
    @objc private func shufflePressed() {
        switch player.shuffleMode {
            
        case .default:
            break
        case .off:
            player.shuffleMode = .songs
        case .songs:
            player.shuffleMode = .off
        case .albums:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func repeatPressed() {
       
        switch player.repeatMode {
            
        case .default:
            break
        case .none:
            player.repeatMode = .one
        case .one:
            player.repeatMode = .none
        case .all:
            break
        @unknown default:
            break
        }
        
    }
    
    @objc private func rewindPressed() {
        
    }
    
    @objc private func fastForwardPressed() {
        
    }
    
    
    func rotateView(view: UIView, duration: Double = 1) {
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            view.transform = view.transform.rotated(by: CGFloat.pi)
        }) { (finished) in
            self.rotateView(view: view, duration: duration)
        }
    }
    
    
}

extension MusicPlayerController {
    
    func addToQueue(id: String, song: Song) {
        player.append(MPMusicPlayerStoreQueueDescriptor(storeIDs: [id]))
        
    }
}
