//
//  ViewController.swift
//  EndlessList
//
//  Created by Mark Edmunds on 25/03/2023.
//

import UIKit

class MainViewController: UIViewController {
  private var posts: [Post] = Array(repeating: Post(id: nil, title: nil, body: nil), count: 10)
  private var currentPage = 1
  private var canFetchMore = true
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: view.bounds.width, height: 120)
    layout.minimumLineSpacing = 16
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.reuseIdentifier)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
    
    fetchData(page: currentPage)
  }
  
  func fetchData(page: Int) {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)") else {
      print("Invalid URL")
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      if let error = error {
        print("Error fetching data: \(error)")
        return
      }
      
      if let data = data {
        do {
          let newPosts = try JSONDecoder().decode([Post].self, from: data)
          
          // Add a 2-second delay
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let startIndex = (page - 1) * 10
            for (index, post) in newPosts.enumerated() {
              self?.posts[startIndex + index] = post
            }
            
            if newPosts.isEmpty {
              // Remove extra skeleton view cells
              let initialCount = self?.posts.count
              let rangeToRemove = startIndex..<initialCount!
              self?.posts.removeSubrange(rangeToRemove)
            } else {
              self?.canFetchMore = true
            }
            
            self?.collectionView.reloadData()
          }
        } catch {
          print("Error decoding data: \(error)")
        }
      }
    }
    task.resume()
  }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.reuseIdentifier, for: indexPath) as! PostCell
    let post = posts[indexPath.row]
    if let title = post.title, let body = post.body {
      cell.configure(with: Post(id: post.id, title: title, body: body))
      cell.hideSkeleton()
    } else {
      cell.showSkeleton()
    }
    return cell
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    let height = scrollView.frame.height
    
    if offsetY > contentHeight - height * 1.5, canFetchMore {
      canFetchMore = false
      currentPage += 1
      
      let startIndex = posts.count
      let endIndex = startIndex + 10
      for _ in startIndex..<endIndex {
        posts.append(Post(id: nil, title: nil, body: nil))
      }
      
      collectionView.reloadData()
      fetchData(page: currentPage)
    }
  }
}
