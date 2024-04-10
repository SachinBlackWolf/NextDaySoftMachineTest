//  ProductViewController.swift
//  NextDaySoftMachinTest
//  Created by Sachin on 09/04/24.

import UIKit
import SDWebImage

class ProductViewController: UIViewController {
    
    var array = [ProductElement]()
    
    @IBOutlet weak var productTableView: UITableView! {
        didSet {
            self.productTableView.delegate = self
            self.productTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCall()
    }
    
    func apiCall() {
        let url = URL(string: "https://fakestoreapi.com/products")!
        
        var request = URLRequest(url: url)
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let books = try? JSONDecoder().decode([ProductElement].self, from: data) {
                    self.array = books
                    DispatchQueue.main.async {
                        self.productTableView.reloadData()
                    }
                    print(books)
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        
        task.resume()
    }
    
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell
        cell?.setData(model: self.array[indexPath.row])
        return cell ?? ProductCell()
    }
    
    
}

//MARK: - Table cell

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func setData(model: ProductElement) {
        self.categoryLabel.text = model.category.rawValue
        if let url = URL(string: model.image) {
            self.productImage.sd_setImage(with: url)
        }
        self.titleLabel.text = model.title
        self.discLabel.text = model.description
        self.priceLabel.text = "\(model.price)"
        self.ratingLabel.text = "\(model.rating)"
        self.countLabel.text = "\(model.rating.count)"
    }
}


// MARK: - ProductElement
struct ProductElement: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: Category
    let image: String
    let rating: Rating
}

enum Category: String, Codable {
    case electronics = "electronics"
    case jewelery = "jewelery"
    case menSClothing = "men's clothing"
    case womenSClothing = "women's clothing"
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}
