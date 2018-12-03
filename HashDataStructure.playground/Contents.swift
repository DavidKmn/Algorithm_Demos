//: Playground - noun: a place where people can play

import Foundation

class HashElement<T: Hashable, U> {
    var key: T
    var value: U?
    
    init(key: T, value: U?) {
        self.key = key
        self.value = value
    }
}


struct HashTable<Key: Hashable, Value> {
    
    typealias Bucket = [HashElement<Key, Value>]
    
    var buckets: [Bucket]
    
    init(capacity: Int) {
        assert(capacity > 0)
        buckets = Array<Bucket>(repeating: [], count: capacity)
    }
    
    func index(for key: Key) -> Int {
        var divisor: Int = 0
        for key in String(describing: key).unicodeScalars {
            divisor += abs(key.value.hashValue)
        }
        return abs(divisor) % buckets.count
    }
    
    func value(for key: Key) -> Value? {
        let index = self.index(for: key)
        
        for element in buckets[index] {
            if element.key == key {
                return element.value
            }
        }
        return nil
    }
    
    func model(with element: Key) -> String? {
        switch element {
        case is String:
            return String(describing: element)
        case is Int:
            let stringElement = String(describing: element)
            return stringElement
        default: return nil
        }
    }
    
    subscript(key: Key) -> Value? {
        get {
            return value(for: key)
        }
        set {
            if let value = newValue {
                updateValue(value, forKey: key)
            } else {
                removeValue(for: key)
            }
        }
    }
    
    @discardableResult
    mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        var itemIndex: Int
        itemIndex = self.index(for: key)
        for (i, element) in buckets[itemIndex].enumerated() {
            if element.key == key {
                let oldValue = element.value
                buckets[itemIndex][i].value = value
                return oldValue
            }
        }
        buckets[itemIndex].append(HashElement(key: key, value: value))
        return nil
    }
    
    
    @discardableResult
    mutating func removeValue(for key: Key) -> Value? {
        let index = self.index(for: key)
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                buckets[index].remove(at: i)
                return element.value
            }
        }
        return nil
    }
}














