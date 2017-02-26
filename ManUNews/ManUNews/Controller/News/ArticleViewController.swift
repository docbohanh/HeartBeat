//
//  ArticleViewController.swift
//  ManuNews
//
//  Created by Thành Lã on 2/21/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions
import CleanroomLogger
import MGSwipeTableCell

class ArticleViewController: GeneralViewController {
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44, cell = 100
    }
    
    /// PRIVATE
    fileprivate var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        return formatter
    }()
    
    /// VIEW
    var table: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var articleList: [RealmArticle] = {
//        (1...5).forEach { value in
//            let article = RealmArticle(
//                ID: UUID().uuidString,
//                title: "Pogba sẽ trở lại và lợi hại gấp :3",
//                articleLink: "",
//                description: "Chàng tiền vệ đang thiếu một chút may mắn",
//                publishDate: "",
//                imageLink: "")
//            
//            DatabaseSupport.shared.insert(article: [article])
//        }
        
        return DatabaseSupport.shared.getAllArticle()//.sorted { $0.time > $1.time}
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAllSubviews()
        view.setNeedsUpdateConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            setupAllConstraints()
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
}

//------------------------------
//MARK: SELECTOR
//------------------------------
extension ArticleViewController {
    func refresh(refreshControl: UIRefreshControl) {
        
        /* Thông báo cho người dùng không có mạng */
        guard ReachabilitySupport.instance.networkReachable else {
            HUD.showMessage("Bạn đang offline, vui lòng kiểm tra lại kết nối")
            return
        }
        
        let request = HTTPGetArticle.RequestType(pageNumber: 1, rowPerPage: 10)
        
        HTTPManager.shared.request(
            type: HTTPGetArticle.self,
            request: request,
            debug: .all) { (result) in
                switch result {
                case .success(let value):
                    Log.message(.debug, message: "Cập nhật thành công: \(value.articles.count) bản tin")
                    
                    let oldNews = DatabaseSupport.shared.getAllArticle().map { $0.ID }
                    let news = value.articles.filter { !oldNews.contains($0.ID) }
                    
                    Log.message(.debug, message: "\(news.count) bản tin mới")
                    
                    DatabaseSupport.shared.insert(article: news.map{ $0.convertToRealmType() })
                    self.reloadTableView()
                    
                    self.refreshControl.attributedTitle = NSAttributedString(string: self.dateFormatter.string(from: Date()))
                    self.refreshControl.endRefreshing()
                    
                case .failure(let erorr):
                    Log.message(.debug, message: "Cập nhật tin tức lỗi: \(erorr)")
                    self.refreshControl.attributedTitle = NSAttributedString(string: "Cập nhật tin tức lỗi")
                    self.refreshControl.endRefreshing()
                }
        }
        
        
    }
}

//------------------------------
//MARK: PRIVATE METHOD
//------------------------------
extension ArticleViewController {
    func reloadTableView() {
        articleList = DatabaseSupport.shared.getAllArticle()
        table.reloadData()
    }
}

//--------------------------------------
// - MARK: - TABLE DATASOURCE
//--------------------------------------
extension ArticleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.articleIdentifier, for: indexPath) as! ArticleTableViewCell
        
        configCell(for: cell, with: articleList[indexPath.row].convertToSyncType())
        return cell
    }
    
    func configCell(for cell: ArticleTableViewCell, with article: Article) {
        
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.description
        //        cell.labelTime.text = dateFormatter.string(from: Date(timeIntervalSince1970: article.time))
        cell.labelTime.text = article.publishDate //Utility.shared.stringFromPastTimeToText(article.time)
        cell.imageView?.image = Icon.Article.news
        cell.countView.countLabel.text = "5"
        //        if article.commentCount == 0 {
        //            cell.countView.removeFromSuperview()
        //        }
        //
        if arc4random_uniform(3) % 3 == 0 {
            cell.markReadIcon.image = Icon.Article.markAsRead.tint(.main)
        }
        
        guard let url = URL(string: article.imageLink) else { return }
        
        
        let cache = URLCache.shared
        if let data = cache.cachedResponse(for: URLRequest(url: url)) {
            if let image = UIImage(data: data.data) {
                cell.imageView?.image = image
                return
            }
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (responseData, responseUrl, error) -> Void in
            
            guard let data = responseData else { return }
            
            DispatchQueue.main.async(execute: {
                if let responseUrl = responseUrl {
                    cache.storeCachedResponse(
                        CachedURLResponse(response: responseUrl, data: data),
                        for: URLRequest(url: url)
                    )
                    
                    if let image = UIImage(data: data) {
                        cell.imageView?.image = image
                    }
                }
            })
            
        }
        task.resume()
        
    }
}

//-------------------------------------------
// - MARK: - TABLE DELEGATE
//-------------------------------------------

extension ArticleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = ArticleDetailViewController()
        detailVC.title = "Chi tiết"
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cell..
    }
}


//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension ArticleViewController {
    func setupAllSubviews() {
        view.backgroundColor = UIColor.General.separator
        title = "Tin tức"
        
        table = setupTableView()
        
        refreshControl = setupRefreshView()
        refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        table.addSubview(refreshControl)
        
        view.addSubview(table)
    }
    
    func setupAllConstraints() {
        table.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setupTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.articleIdentifier)
        return table
    }
    
    
    func setupRefreshView() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        
        refreshControl.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        
        return refreshControl
    }
    
    fileprivate func setupMGSwipeButton(title: String = "", image: UIImage, bgColor: UIColor = UIColor.main) -> MGSwipeButton {
        let button = MGSwipeButton(title: title, icon: image.tint(.white), backgroundColor: bgColor)
        
        let buttonWidth = Utility.shared.widthForView(text: title, font: UIFont(name: FontType.latoRegular.., size: FontSize.small++)!, height: 20)
        button.frame = CGRect(x: 0, y: 0, width: max(buttonWidth + 20, Size.cell..)  , height: Size.cell..)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: FontType.latoRegular.., size: FontSize.small++)
        Utility.shared.centeredTextAndImage(for: button)
        
        return button
    }
}

