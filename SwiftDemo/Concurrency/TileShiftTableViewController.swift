//
//  TileShiftTableViewController.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/9.
//

import UIKit

class TileShiftTableViewController: UIViewController {
    
    private let context = CIContext()
    
    var table: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(TileShiftViewCell.nib(), forCellReuseIdentifier: TileShiftViewCell.identifer)
        return table
    }()
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back)), animated: true)

        table.dataSource = self
        table.delegate = self
        view.addSubview(table)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.table.frame = view.bounds
    }
}

extension TileShiftTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TileShiftViewCell.identifer, for: indexPath) as! TileShiftViewCell
        
        let name = "\(indexPath.row + 1).png"
        let inputImage = UIImage(named: name)!
        
        print("Tilt shifting image \(name)")
//        guard let filter = TiltShiftFilter(image: inputImage, radius: 3.0),
//              let output = filter.outputImage else {
//            print("Failed to generate tilt shift image")
//            cell.display(image: nil)
//            return cell
//        }
//
//        let fromRect = CGRect(origin: .zero, size: inputImage.size)
//        guard let cgImage = context.createCGImage(output, from: fromRect) else {
//            print("No image generated")
//            cell.display(image: nil)
//            return cell
//        }
        
        let queue = OperationQueue()
        
        print("Filtering")
        let op = TiltShiftOperation(image: inputImage)
//        op.start()
        
        op.completionBlock = {
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? TileShiftViewCell else {
                    return
                }
                cell.isLoading = false
                cell.display(image: op.outputImage)
                print("Done...")
            }
        }
        queue.addOperation(op)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}

extension TileShiftTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
