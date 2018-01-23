//
//  ViewController.swift
//  RealmTableView
//
//  Created by Tran Anh on 1/23/18.
//  Copyright © 2018 anh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewModel
import RxDataSources

protocol ViewModelType {
    var gits: Driver<[ViewSectionModel]> { get }
    var hasData: Variable<Bool> { get }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate let disposeBag = DisposeBag()
    let dataSource = configureDataSource()
    var viewModel: ViewModelType! = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tableview with cache"
        configureView()
        configure(viewModel: viewModel)
    }

}

extension ViewController {
    func configureView() {
        tableView.registerNib(forCellType: GitCell.self)
        tableView.rowHeight = 50
//        tableView.estimatedRowHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    static func configureDataSource() -> RxTableViewSectionedAnimatedDataSource<ViewSectionModel> {
        
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .left),
        
            configureCell: {(dataSource, tableView, indexPath, item) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "GitCell", for: indexPath) as! GitCell
                cell.nameLabel.text = item.name
            return cell
        })
        
        
    }
    func configure(viewModel: ViewModelType) {
        bindTo(viewModel: viewModel)
    }
    
    
    func bindTo(viewModel: ViewModelType) {
        viewModel.gits
            .drive ((tableView.rx.items(dataSource: dataSource)))
            .disposed(by: disposeBag)
        
        viewModel.hasData
            .asObservable()
            .subscribe(onNext: { isData in
                if isData { print("has data ")
                } else { print("data is empty") }
            }).disposed(by: disposeBag)

    }
}

extension UITableView {
    
    func registerNib<T: UITableViewCell>(forCellType type: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerNib<T: UITableViewCell>(forCellTypes types: [T.Type]) where T: ReusableView, T: NibLoadableView {
        for type in types {
            registerNib(forCellType: type)
        }
    }
    
}
