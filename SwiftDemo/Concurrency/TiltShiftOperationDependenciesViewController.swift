//
//  TiltShiftOperationDependenciesViewController.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/9.
//

import UIKit

class TiltShiftAsynchronousOperationsViewController: UIViewController {
    
    var table: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(TileShiftViewCell.nib(), forCellReuseIdentifier: TileShiftViewCell.identifer)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back)), animated: true)

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
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TileShiftViewCell.identifer, for: indexPath) as! TileShiftViewCell
        
        let name = "\(indexPath.row + 1).png"
        let inputImage = UIImage(named: name)!
        let op = TiltShiftOperation(image: inputImage)
        let queue = OperationQueue()
        op.completionBlock = {
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? TileShiftViewCell else {
                    return
                }
                
                cell.isLoading = false
                cell.display(image: op.outputImage)
            }
        }
        
        queue.addOperation(op)
        
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
