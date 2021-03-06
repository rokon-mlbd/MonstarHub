//
//  ContentCellViewModel.swift
//  MonstarHub
//
//  Created by Rokon on 5/26/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

class ContentCellViewModel: DefaultTableViewCellViewModel {

    let content: Content

    init(with content: Content) {
        self.content = content
        super.init()
        title.accept(content.name)
        detail.accept(content.type == .file ? content.size?.sizeFromByte() : nil)
        image.accept(content.type.image()?.template)
    }
}

extension ContentType {
    func image() -> UIImage? {
        switch self {
        case .file: return R.image.icon_cell_file()
        case .dir: return R.image.icon_cell_dir()
        case .submodule: return R.image.icon_cell_submodule()
        case .symlink: return R.image.icon_cell_submodule()
        case .unknown: return nil
        }
    }
}
