//
//  FavoriteViewController.swift
//  Factory2.0
//
//  Created by Mateo Došlić on 11/07/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//
import UIKit
import Alamofire
import AlamofireImage
import RxSwift
import RealmSwift
import Realm

class FavoriteNewsViewController: UITableViewController, NewsViewCellDelegate {
    
    let cellIdentifier = "ListNewsViewCell"
    var favoriteListNewsViewModel: FavoritenewsViewModel!
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ListNewsViewCell.self, forCellReuseIdentifier: cellIdentifier)
        favoriteListNewsViewModel.getFavoriteNews().disposed(by: disposebag)
        initializeRealmObservable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        starGettingDataFromRealm()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParentViewController {
            favoriteListNewsViewModel.favoriteistNewsCoordinatorDelegate?.viewControllerHasFinished()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteListNewsViewModel.favoriteNewsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Table view cell are used and should be dequeued using a cell identifier
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ListNewsViewCell else
        {
            errorOccured(value: "The dequeued cell is not an instance of PreviewDataTableViewCell.")
            return UITableViewCell()
            
        }
        let newsViewData = favoriteListNewsViewModel.favoriteNewsData[indexPath.row]
        
        cell.newsTitleLabel.text = newsViewData.title
        Alamofire.request(URL (string: (newsViewData.urlToImage)!)!).responseImage
            {
                response in
                if let image = response.result.value
                {
                    cell.newsImageView .image = image
                }
        }
        
        if newsViewData.isItFavourite {
            cell.favoriteButton.isSelected = true
        }
        cell.cellDelegate = self
        return  cell
    }
    
    func didPressButton(_ sender: ListNewsViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        favoriteListNewsViewModel.removeDataFromFavorite(selectedNews: tappedIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoriteListNewsViewModel.newsSelected(selectedNews: indexPath.row)
    }
    
    func initializeRealmObservable() {
        let observer = favoriteListNewsViewModel.dataIsReady
        observer
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (event) in
                if event {
                    self.tableView.reloadData()
                }
            }).disposed(by: disposebag)
    }
    
    func starGettingDataFromRealm() {
        favoriteListNewsViewModel.realmTrigger.onNext(true)
    }
}
