//
//  MemeTableViewCell.swift
//  MyAddTable
//
//  Created by VorkYu on 2019/9/5.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    @IBOutlet weak var memeProcess: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateUI(with memeData: Meme) {
        memeImageView.image = nil
        memeLabel.text = nil
        memeProcess.startAnimating()
        let task = URLSession.shared.dataTask(with: memeData.image) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.memeProcess.stopAnimating()
                    self.memeImageView.image = image
                    self.memeLabel.text = memeData.caption
                }
            }
        }
        
        task.resume()
    }
}
