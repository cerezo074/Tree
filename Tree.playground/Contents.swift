//: Playground - noun: a place where people can play

import UIKit

class Node<T: Equatable> {

    var value: T
    var children: [Node] = []
    var level: Int = 0
    var profundity: Int {
        return maxLevels(deep: 0)
    }
    var isLeaf: Bool {
        return children.count == 0
    }
    weak var parent: Node?
    
    init(_ value: T) {
        self.value = value
    }
    
    func add(_ child: Node) {
        children.append(child)
        child.parent = self
        child.level = level + 1
    }
    
    func add(_ arrayChild: [Node]) {
        for child in arrayChild {
            add(child)
        }
    }
    
    func search(_ value: T) -> Node? {
        
        if value == self.value {
            return self
        }
        
        if !children.isEmpty {
            for child in children {
                if let result = child.search(value) {
                    return result
                }
            }
        }
        
        return nil
    }
    
    func allNodes(includeLeafs: Bool) -> [Node]? {
        let nodesContainer = NSMutableArray()
        walkThroughChildren(includeLeafs, nodesContainer)
        
        if nodesContainer.count > 0 {
            return nodesContainer.map({ $0 as! Node })
        }
        
        return nil
    }
    
    private func walkThroughChildren (_ includeLeafs: Bool, _ container: NSMutableArray) {
        if !children.isEmpty {
            container.add(self)
            children.map({ $0.walkThroughChildren(includeLeafs, container) })
        }
        else {
            if includeLeafs {
                container.add(self)
            }
        }
    }
    
   private func maxLevels(deep: Int) -> Int {
        if !children.isEmpty {
            var maxProfundity = 0
            for child in children {
                let currentProfundity = child.maxLevels(deep: deep + 1)
                if maxProfundity < currentProfundity {
                    maxProfundity = currentProfundity
                }
            }
            return maxProfundity
        }
        else {
            return deep
        }
    }
    
}

extension Node: CustomStringConvertible {

    var description: String {
        var text = "\(value)"
        
        if !children.isEmpty {
            text += " {" + children.map({ $0.description }).joined(separator: ", ") + "} "
        }
        
        return text
    }
    
}

class Expandable<T: Equatable>: Node<T> {
    
    var isOpen: Bool = false
    var canExpand: Bool {
        return !children.isEmpty
    }
    
    func list() -> [Expandable]? {
        let container = NSMutableArray()
        walkThroughExapandable(container)
        if container.count > 0 {
            return container.map({ $0 as! Expandable })
        }
        
        return nil
    }
    
    func nodesToShow() -> Int {
        if let childs = list(), isOpen {
            return childs.count - 1
        }
        
        return 0
    }
    
    private func walkThroughExapandable(_ container: NSMutableArray) {
        if canExpand && isOpen {
            container.add(self)
            for child in children {
                guard let expandableChild = child as? Expandable else {
                    return
                }
                expandableChild.walkThroughExapandable(container)
            }
        }
        else {
            container.add(self)
        }
    }
    
}

let devices = Expandable("Devices")

let smarthphones = Expandable("Smarthphone")
let ios = Expandable("IOS")
let android = Expandable("Android")

let iphone = Expandable("Iphone")
let appleWatch = Expandable("Apple Watch")
let tvOS = Expandable("TVOS")

let iphone4s = Expandable("Iphone 4s")
let iphone5s = Expandable("Iphone 5s")
let iphone7 = Expandable("Iphone 7")

let nexus = Expandable("Nexus")
let samsung = Expandable("Samsung")
let huawei = Expandable("Huawei")

let pc = Expandable("PC")
let wearable = Expandable("Wearable")
let tv = Expandable("TV")

let bravia = Expandable("Bravia")
let trinitron = Expandable("Trinitron")

devices.add([smarthphones, pc, wearable, tv])
smarthphones.add([ios, android])
ios.add([iphone, appleWatch, tvOS])
iphone.add([iphone4s, iphone5s, iphone7])
android.add([nexus, samsung, huawei])
tv.add([bravia, trinitron])

devices.isOpen = true
ios.isOpen = true
iphone.isOpen = true
android.isOpen = true
smarthphones.isOpen = true
tv.isOpen = true

if let devices = devices.list() {
    for device in devices {
        var value = "\(device.level)." + device.value
        for i in 0 ... device.level {
            value.characters.insert("-", at: value.startIndex)
        }
        print(value)
    }
}
