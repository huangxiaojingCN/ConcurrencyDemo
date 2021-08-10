//
//  Stack.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/8.
//

import Foundation


struct Stack<Element> {
    
    private var elements = [ Element ] ()
    
    mutating func push(e: Element) {
        elements.append(e)
    }
    
    mutating func pop() -> Element {
        elements.removeLast()
    }
}

extension Stack {
    mutating func popFirst() -> Element {
        elements.removeFirst()
    }
}
