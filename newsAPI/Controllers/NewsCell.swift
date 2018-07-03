//
//  NewsCell.swift
//  newsAPI
//
//  Created by Mac on 26.06.18.
//  Copyright © 2018 VasylFuchenko. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var auther: UILabel!
    @IBOutlet weak var url: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
