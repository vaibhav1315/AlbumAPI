//
//  ViewController.swift
//  AssingnmentNO2Api
//
//  Created by Mac on 09/08/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var AlbumTableView: UITableView!
    private let reuseidentifieralbumtableview = "AlbumTableViewCell"
    
    var Albums : [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerwithXibtableviewcell()
        jsonparcing()
    }
    
    func registerwithXibtableviewcell() {
        let uinib = UINib(nibName: reuseidentifieralbumtableview, bundle: nil)
        AlbumTableView.register(uinib, forCellReuseIdentifier: reuseidentifieralbumtableview)
    }
    
    func jsonparcing() {
        let urlstring = "https://jsonplaceholder.typicode.com/users/1/albums"
        let url = URL(string: urlstring)
        
        var urlrequest = URLRequest(url: url!)
        urlrequest.httpMethod = "GET"
        
        let urlsession = URLSession(configuration: URLSessionConfiguration.default)
        var datatask = urlsession.dataTask(with: urlrequest) {
            data , response , error in
            print(data)
            print(response)
            print(error)
            
            let jsonresponse = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            
            for eachjsonObject in jsonresponse {
                let eachAlbum = eachjsonObject
                
                let eachuserid = eachAlbum["userId"] as! Int
                let eachid = eachAlbum["id"] as! Int
                let eachtitle = eachAlbum["title"] as! String
                
                
                let newalbumobjet = Album(userId: eachuserid, id: eachid, title: eachtitle)
                
                self.Albums.append(newalbumobjet)
                
            }
            
            DispatchQueue.main.async {
                self.AlbumTableView.reloadData()
            }
            
        }
        datatask.resume()
    }
    
}
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let AlbumTableViewCell = self.AlbumTableView.dequeueReusableCell(withIdentifier: reuseidentifieralbumtableview, for: indexPath) as! AlbumTableViewCell
        let EachAlbumFetchfromArray = Albums[indexPath.row]
        
        AlbumTableViewCell.AlbumuserIdlabel.text = String(EachAlbumFetchfromArray.userId)
        AlbumTableViewCell.Albumidlabel .text = String(EachAlbumFetchfromArray.id)
        AlbumTableViewCell.Albumtitlelabel.text = EachAlbumFetchfromArray.title
        AlbumTableViewCell.backgroundColor = .lightGray
        return AlbumTableViewCell
    }
}
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160
    }
    
}
