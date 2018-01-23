//
//  GithubCellModel.swift
//  RealmTableView
//
//  Created by Tran Anh on 1/23/18.
//  Copyright © 2018 anh. All rights reserved.
//

import Foundation
import RealmSwift

struct GithubCellModel {
    var id: String
    let name: String
    var nickname: String
    var url: String
    
    init(_ git: Github) {
        id = git.id
        name = git.name
        nickname = git.nickname
        url = git.url
    }
}
