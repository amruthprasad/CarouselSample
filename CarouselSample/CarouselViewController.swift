//
//  CarouselViewController.swift
//  CarouselSample
//
//  Created by AMRUTHAPRASAD KK on 05/05/21.
//  Copyright © 2021 MB. All rights reserved.
//
import UIKit

protocol CarouselViewControllerProtocol {
    func updateList(with models: [String])
}
class CarouselViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    var carModels: [String]?
    var filteredData: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CarouselPageViewController") as! CarouselPageViewController
        vc.caroselDelegate = self
        self.embed(vc, inView: vwContainer)
        tableView.register(UINib.init(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
    }
    
}
extension UIViewController {
    func embed(_ viewController:UIViewController, inView view:UIView){
        viewController.willMove(toParent: self)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
    }
}
extension CarouselViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell {
            cell.listLable.text = filteredData?[indexPath.row] ?? "Item"
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension CarouselViewController: UITableViewDelegate {
    
}
extension CarouselViewController: CarouselViewControllerProtocol {
    func updateList(with models: [String]) {
        self.carModels = models
        self.filteredData = self.carModels
        tableView.reloadData()
    }
}
extension CarouselViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? carModels : carModels?.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })

        tableView.reloadData()
    }
}
