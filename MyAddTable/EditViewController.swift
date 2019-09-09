//
//  EditViewController.swift
//  MyAddTable
//
//  Created by VorkYu on 2019/9/5.
//  Copyright © 2019 VorkYu. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    var meme: Meme?
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var captionsLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var process: UIActivityIndicatorView!
    @IBOutlet weak var memeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        process.stopAnimating()
        // Do any additional setup after loading the view.
        if let meme = meme {
            process.startAnimating()
            memeButton.setTitle("替換", for: .normal)
            getImage(url: meme.image, completionHandler: { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        self.memeImageView.image = image
                        self.process.stopAnimating()
                    }
                }
            })
            captionsLabel.text = meme.caption
            categoryLabel.text = meme.category
        }
    }
    
    @IBAction func showMemeImg(_ sender: Any) {
        process.startAnimating()
        getMemeData(url: "https://some-random-api.ml/meme")
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if memeImageView.image != nil {
            return true
        } else {
            return false
        }
    }
    // MARK: - Navigation
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     
     }
     */
}
extension EditViewController {
    func getMemeData(url urlStr: String) {
        if let url = URL(string: urlStr) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let memeData = try JSONDecoder().decode(Meme.self, from: data)
                        self.setData(from: memeData)
                        self.meme = memeData
                    } catch {
                        DispatchQueue.main.async {
                            let controller = UIAlertController(title: "錯誤", message: "查無資料", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "確定", style: .default) { (action) in
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                            controller.addAction(alertAction)
                            self.present(controller, animated: true, completion: nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func setData(from data: Meme?) {
        if let data = data {
            let caption = data.caption
            let category = data.category
            let task = URLSession.shared.dataTask(with: data.image) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.memeImageView.image = image
                        self.captionsLabel.text = caption
                        self.categoryLabel.text = category
                        self.process.stopAnimating()
                    }
                }
            }
            task.resume()
        }
    }
    
    func getImage(url: URL?, completionHandler: @escaping (UIImage?) -> Void) {
        if let url = url {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    completionHandler(image)
                } else {
                    completionHandler(nil)
                }
            }
            task.resume()
        }
    }
}
