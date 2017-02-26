//
//  NewsViewController.swift
//  ManuNews
//
//  Created by Thành Lã on 2/21/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import SnapKit
import PHExtensions
import PagingMenuController

class NewsViewController: GeneralViewController {
    fileprivate enum Size: CGFloat {
        case padding15 = 15, padding5 = 5, padding10 = 10, button = 44
    }
    var didSetupContraints = false
    
    var segmentedHeaderView: SegmentedHeaderView!
    var selectedSegmentIndex: Int!
    
    fileprivate let segmentArray: [Segmented] = [
        Segmented(index: 0, title: "Tuần này", value: .fixedValue(7 * 24.hour)),
        Segmented(index: 1, title: "Tháng này", value: .fixedValue(30 * 24.hour)),
        Segmented(index: 2, title: "Khác", value: .rangeValue(0, 0))]
    
    
    /// PRIVATE
    fileprivate var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd/MM/yyyy"
        return formatter
    }()
    
    /// VIEW
    var table: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var articleList: [Article] = {
//        (1...10).forEach { value in
//            let article = Article(ID: UUID().uuidString,
//                                  image: "",
//                                  time: 1487922497 - TimeInterval(value * 57),
//                                  title: "Pogba sẽ trở lại và lợi hại gấp :3",
//                                  contentShort: "Chàng tiền vệ đang thiếu một chút may mắn",
//                                  isRead: value % 3 == 0,
//                                  commentCount: value % 3 == 0 ? value : 0,
//                                  articleImg: "",
//                                  order: value,
//                                  queryType: 0,
//                                  version: 0)
//            
//            DatabaseSupport.shared.insert(article: [article])
//        }
        
        (1...5).forEach { value in
            let article = Article(
                ID: UUID().uuidString,
                title: "Pogba sẽ trở lại và lợi hại gấp :3",
                articleLink: "",
                description: "Chàng tiền vệ đang thiếu một chút may mắn",
                publishDate: "",
                imageLink: "")
            
            DatabaseSupport.shared.insert(article: [article])
        }
        
        return DatabaseSupport.shared.getAllArticle().sorted { $0.time > $1.time}
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
        if !didSetupContraints {
            setupAllConstraints()
            didSetupContraints = true
        }
        
        super.updateViewConstraints()
    }
    
}

//------------------------------
//MARK: SELECTOR
//------------------------------
extension NewsViewController {
    func menu(_ sender: UIBarButtonItem) {
//        if let drawerController = navigationController?.parent as? KYDrawerController {
//            drawerController.setDrawerState(.opened, animated: true)
//        }
        
    }
    
    func segmentSelection(_ sender: FUISegmentedControl) {
        
        guard ReachabilitySupport.instance.networkReachable else {
            HUD.showMessage(
                "Không có kết nối mạng. Vui lòng kiểm tra lại kết nối và thử lại.",
                onView: self.view
            )
            
            return
        }
        if sender.selectedSegmentIndex != segmentArray.count - 1 {
            selectedSegmentIndex = sender.selectedSegmentIndex
        }
        
        let segment = segmentArray[sender.selectedSegmentIndex]
        print("---- \(segment.value)")
        
        switch segment.value {
        case .fixedValue(_):
            HUD.showMessage(segmentArray[sender.selectedSegmentIndex].title)
            
        case .rangeValue(_, _):
            let selectionTimeVC = SelectionTimeViewController()
            
            let currentTime = Date().timeIntervalSince1970
            
            selectionTimeVC.fromTimeInput = currentTime - ( currentTime.truncatingRemainder(dividingBy: 1.day) ) - 7.hours
            selectionTimeVC.toTimeInput = selectionTimeVC.fromTimeInput + 1.day - 1.minute
            
            selectionTimeVC.delegate = self
            
            let naviVC = UINavigationController(rootViewController: selectionTimeVC)
            
            Utility.shared.configureAppearance(navigation: naviVC)
            present(naviVC, animated: true, completion: nil)
        }
    }

}

//------------------------------
//MARK: DELEGATE
//------------------------------
extension NewsViewController: SelectionTimeControllerDelegate {
    func dismissTimeSelection() {
        dismiss(animated: true, completion: nil)
        segmentedHeaderView.segment.selectedSegmentIndex = selectedSegmentIndex ?? UISegmentedControlNoSegment
    }
    
    func didSelectedTime(_ fromTime: TimeInterval, toTime: TimeInterval) {        
        dismiss(animated: true, completion: nil)
        
        
        
    }
}

//--------------------------------------
// - MARK: - TABLE DATASOURCE
//--------------------------------------
extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.articleIdentifier, for: indexPath) as! ArticleTableViewCell
        
        configCell(for: cell, atIndexPath: indexPath)
        return cell
    }
    
    
    
    func configCell(for cell: ArticleTableViewCell, atIndexPath indexPath: IndexPath) {
        
        let article = articleList[indexPath.row]
        
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.description
//        cell.labelTime.text = dateFormatter.string(from: Date(timeIntervalSince1970: article.time))
        cell.labelTime.text = Utility.shared.stringFromPastTimeToText(article.time)
        cell.imageView?.image = Icon.Article.news
        cell.countView.countLabel.text = "5"
//        if article.commentCount == 0 {
//            cell.countView.removeFromSuperview()
//        }
//        
        if indexPath.row % 3 == 0 {
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

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = ArticleDetailViewController()
        detailVC.title = "Chi tiết"
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//------------------------------
//MARK: SETUP VIEW
//------------------------------
extension NewsViewController {
    func setupAllSubviews() {
        view.backgroundColor = .white
        title = "Tin tức"
//        setupPagingMenuViewController()
        
        segmentedHeaderView = setupHeaderView()
        view.addSubview(segmentedHeaderView)
        
        table = setupTableView()
        view.addSubview(table)
        
    }
    
    func setupAllConstraints() {
        segmentedHeaderView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(Size.button..)
        }
        
        table.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view)
            make.top.equalTo(segmentedHeaderView.snp.bottom)
        }
    }
    
    func setupHeaderView() -> SegmentedHeaderView {
        let view = SegmentedHeaderView()
        
        for (index, segment) in segmentArray.enumerated() {
            view.segment.insertSegment(withTitle: segment.title, at: index, animated: false)
        }
        view.segment.addTarget(self, action: #selector(self.segmentSelection(_:)), for: .valueChanged)
        return view
    }
    
    func setupTableView() -> UITableView {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.articleIdentifier)
        return table
    }

    
    ///
    fileprivate func setupLeftBarButton() {
        let left = setupBarButton(image: Icon.Navi.menu, selector: #selector(self.menu(_:)), target: self)
        navigationItem.leftBarButtonItem = left
    }
    
    ///
    func setupPagingMenuViewController() {
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
//        pagingMenuController.view.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 20)
        pagingMenuController.didMove(toParentViewController: self)
    }
    
}

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    private let news = ArticleViewController()
    private let videos = VideosViewController()
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return [news, videos]
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        
        let bgColor: UIColor = .white
        
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        
        var focusMode: MenuFocusMode {
            return .underline(height: 3 * onePixel(), color: UIColor.red, horizontalPadding: 0, verticalPadding: 0)
        }
        
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem(title: "Bài viết"), MenuItem(title: "Videos")]
        }
        
        var backgroundColor: UIColor {
            return bgColor
        }
        
        var selectedBackgroundColor: UIColor {
            return bgColor
        }
        
        var height: CGFloat {
            return 40
        }
    }
    
    fileprivate struct MenuItem: MenuItemViewCustomizable {
        
        let title: String
        
        var displayMode: MenuItemDisplayMode {
            return MenuItemDisplayMode.text(
                title: MenuItemText(
                    text: title,
                    color: UIColor.main,
                    selectedColor: UIColor.main,
                    font: UIFont(name: FontType.latoLight.., size: FontSize.normal++)!,
                    selectedFont: UIFont(name: FontType.latoSemibold.., size: FontSize.normal++)!
                )
            )
        }
    }
    
}


