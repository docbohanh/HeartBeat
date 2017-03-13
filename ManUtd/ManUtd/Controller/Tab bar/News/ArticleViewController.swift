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
import DZNEmptyDataSet
import RxSwift

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
    var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var articleList: [Article] = []
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        DataManager.shared.delegate = self
        
        setupAllSubviews()
        view.setNeedsUpdateConstraints()
        
        HUD.showHUD() {
            DataManager.shared.getNewArticle(page: self.page)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        DataManager.shared.getNewArticle(page: page)
        
    }
    
    func liked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            sender.isSelected = !sender.isSelected
        }
        
    }
}

//------------------------------
//MARK: GET ARTICLE DELEGATE
//------------------------------
extension ArticleViewController: DataManagerDelegate {
    
    func downloadedArticle(status: Bool, articles: [Article]) {
        page += 1
        
        guard status else {
            refreshControl.endRefreshing()
            return
        }
        
        HUD.dismissHUD()
        refreshControl.endRefreshing()
        
        articles.forEach { articleList.insert($0, at: 0) }
        
        tableView.reloadData()
        
    }
    
}

//------------------------------
//MARK: PRIVATE METHOD
//------------------------------
extension ArticleViewController {
    
    
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
        
        configCell(for: cell, with: articleList[indexPath.row])
        return cell
    }
    
    func configCell(for cell: ArticleTableViewCell, with article: Article) {
        
        cell.selectionStyle = .none
        
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.sapo
//        cell.labelTime.text = dateFormatter.string(from: Date(timeIntervalSince1970: article.datePublished - 7.hours))
        cell.labelTime.text = Utility.shared.stringFromPastTimeToText(article.datePublished - 7.hours)
        cell.imageView?.image = Icon.Article.newsEmpty
        
        cell.countView.countLabel.text = "5"
        
        if arc4random_uniform(3) % 3 == 0 {
            cell.countView.removeFromSuperview()
        }
        
        cell.liked.addTarget(self, action: #selector(self.liked(_:)), for: .touchUpInside)
        
        guard let url = URL(string: article.avatar) else { return }
        
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
        detailVC.article = articleList[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cell..
    }
    
}

//-------------------------------------------
// - MARK: - TABLE DELEGATE
//-------------------------------------------
extension ArticleViewController: DZNEmptyDataSetSource {
        
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Đang cập nhật"
        let attribute = [
            NSFontAttributeName: UIFont(name: FontType.latoLight.., size: FontSize.normal--)!,
            NSForegroundColorAttributeName: UIColor.gray
        ]
        return NSAttributedString(string: text, attributes: attribute)
    }
}

//-------------------------------------------
// - MARK: - TABLE DELEGATE
//-------------------------------------------
extension ArticleViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        HUD.showHUD("Đang xử lý...") {
            DataManager.shared.getNewArticle(page: self.page)
        }
    }
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension ArticleViewController {
    func setupAllSubviews() {
        view.backgroundColor = UIColor.Table.tablePlain
        title = "Tin tức"
        
        tableView = setupTableView()
        
        refreshControl = setupRefreshView()
        refreshControl.addTarget(self, action: #selector(self.refresh(refreshControl:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        view.addSubview(tableView)
    }
    
    func setupAllConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(view.snp.top).inset(5)
        }
        
    }
    
    func setupTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.emptyDataSetSource = self
        table.emptyDataSetDelegate = self
        table.separatorStyle = .none
        table.backgroundColor = UIColor.Table.tablePlain
        
        table.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.articleIdentifier)
        return table
    }
    
    
    func setupRefreshView() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        
        refreshControl.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        
        return refreshControl
    }
    
}

