//
//  ProductViewModel.swift
//  SideDishProject
//
//  Created by 김동준 on 2022/04/21.
//

import Foundation

class ProductModel{

    private let repository: ProductRepository
    weak var delegate: ProductModelDelegate?
    
    init(repository: ProductRepository){
        self.repository = repository
    }
    
    func getAll(){
        repository.fetchAll { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let products):
                self.makeAllDishes(products: products)
            case .failure(let error):
                self.delegate?.updateFail(error: error)
            }
        }
    }
    
    private func makeAllDishes(products: [Product]){
        var dishes: [DishCategory : [Product]] = [:]
        dishes[.mainDish] = products.filter{$0.category == .mainDish}
        dishes[.soupDish] = products.filter{$0.category == .soupDish}
        dishes[.sideDish] = products.filter{$0.category == .sideDish}
        delegate?.updateAllDishes(dishes: dishes)
    }
    
}

protocol ProductModelDelegate: AnyObject{
    func updateAllDishes(dishes: [DishCategory : [Product]])
    func updateFail(error: Error)
}
