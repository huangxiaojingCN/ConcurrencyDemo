//
//  TiltShiftOperationDependenciesViewController.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/9.
//

import UIKit

class TiltShiftAsynchronousOperationsViewController: UIViewController {
    
    var urls: [URL] = []
    
    let queue = OperationQueue()
    
    var table: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(TileShiftViewCell.nib(), forCellReuseIdentifier: TileShiftViewCell.identifer)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back)), animated: true)
        
        guard let plist = Bundle.main.url(forResource: "List",
                                          withExtension: "plist"),
              let contents = try? Data(contentsOf: plist),
              let serial = try? PropertyListSerialization.propertyList(from: contents,
                                                                       format: nil),
              let serialUrls = serial as? [String] else {
          print("Something went horribly wrong!")
          return
        }
        
        urls = serialUrls.compactMap({ e in
            return URL(string: e)
        })
        
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
    }
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        table.frame = view.bounds
    }

}

extension TiltShiftAsynchronousOperationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TileShiftViewCell.identifer, for: indexPath) as! TileShiftViewCell
        
        //let name = "\(indexPath.row + 1).png"
        //let inputImage = UIImage(named: name)!
        
        cell.display(image: nil)
        
        let op = NetworkImageOperation(url: urls[indexPath.row])
        let tiltShiftOp = TiltShiftOperation()
        tiltShiftOp.addDependency(op)
        tiltShiftOp.onImageProcessed = { image in
            guard let cell = tableView.cellForRow(at: indexPath) as? TileShiftViewCell else {
                return
            }
            
            cell.isLoading = false
            cell.display(image: image)
        }
//        tiltShiftOp.completionBlock = {
//            DispatchQueue.main.async {
//                guard let cell = tableView.cellForRow(at: indexPath) as? TileShiftViewCell else {
//                    return
//                }
//
//                cell.isLoading = false
//                cell.display(image: op.image)
//            }
//        }
    
        queue.addOperation(op)
        queue.addOperation(tiltShiftOp)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}

extension TiltShiftAsynchronousOperationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
