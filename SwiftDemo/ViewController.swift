//
//  ViewController.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/8.
//

import UIKit

/**
    如果要在范型函数中使用 ==、!= 时需要范型参数需要实现 Equtable 协议
 */
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    
    return nil
}

/**
    关联类型的使用
    给协议定义范型的方式
 */
protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}

class MyArray: Container {
    private var arrays = [ Int ]()
    
    typealias ItemType = Int
    
    func append(_ item: ItemType) {
        arrays.append(item)
    }
    
    var count: Int {
        arrays.count
    }
    
    subscript(i: Int) -> Int {
        return arrays[i]
    }
}

/**
    Where 范型子句约束
 */
func allItemsMatch<C1: Container, C2: Container>(container: C1, antherContainer: C2) -> Bool where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
    if container.count == antherContainer.count {
        for i in 0..<container.count {
            if container[i] != antherContainer[i] {
                return false
            }
        }
        return true
    }
    
    return false
}

/**
    范型下标
 */
extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [ItemType]
    where Indices.Iterator.Element == Int {
        var result = [ItemType]()
        for index in indices {
            result.append(self[index])
        }
        
        return result
    }
}

struct Model {
    let sectionTitle: String
    let title: String
    
    init(sectionTitle: String, title: String) {
        self.sectionTitle = sectionTitle
        self.title = title
    }
}

class ViewController: UIViewController {
    
    var sections: [ [Model] ] = [
        [ Model(sectionTitle: "范型", title: "使用一"),
          Model(sectionTitle: "范型", title: "使用一") ],
        [ Model(sectionTitle: "多线程", title: "BlockOperation 简单用法"),
          Model(sectionTitle: "多线程", title: "继承 Operation"),
          Model(sectionTitle: "多线程", title: "例子一：展示图片数据(DispatchQueue)"),
          Model(sectionTitle: "多线程", title: "例子一：展示图片数据(Operation Dependencies)")
        ],
    ]
    
    var table: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let models = sections[0]
        print("models: \(models.count)")
        
        self.view.backgroundColor = .red
        
        let array = [1, 2, 3, 4, 6, 7]
        
        let index = findIndex(of: 3, in: array)
        print("index: \(String(describing: index))")
        
        let strings = ["zhangsan", "lisi", "wangwu", "zhaoliu"]
        let i = findIndex(of: "zhaoliu", in: strings)
        print("i: \(String(describing: i))")
        
        // 类型关联
        let myarray = MyArray()
        myarray.append(1)
        myarray.append(2)
        myarray.append(3)
        
        print("count: \(myarray.count)")
        
        let myarray1 = MyArray()
        myarray1.append(1)
        myarray1.append(2)
        myarray1.append(4)
        
        let result = allItemsMatch(container: myarray, antherContainer: myarray1)
        print("result: \(result)")
        
        // 获取下标数值
        print(myarray1[[1, 2]])
        
        URLSession.shared.dataTask(with: URL(string: "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466780-jpeg.jpg")!, completionHandler: { data, response, error in
            
            guard error == nil,
                  let data = data else {
                print("error: \(error?.localizedDescription)")
                return
            }
                        
        }).resume()
        
        view.addSubview(table)
        
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.table.frame = view.bounds
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section][0].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = sections[indexPath.section][indexPath.row].title
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1{
            if indexPath.row == 0 {
                let operationVC = OperationViewController()
                
                let vc = UINavigationController(rootViewController: operationVC)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else if indexPath.row == 1 {
                let subclassingOperationVC = SubclassingOperationViewController()
                let vc = UINavigationController(rootViewController: subclassingOperationVC)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else if indexPath .row == 2 {
                let tileShiftVC = TileShiftTableViewController()
                let vc = UINavigationController(rootViewController: tileShiftVC)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else if indexPath.row == 3 {
                let tiltShiftVC = TiltShiftAsynchronousOperationsViewController()
                let vc = UINavigationController(rootViewController: tiltShiftVC)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

