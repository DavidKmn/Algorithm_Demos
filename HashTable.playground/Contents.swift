import UIKit

public struct HashTable<Key: Hashable, Value> {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    
    private let resizeUpLoadFactor: Int = 70
    private let resizeDownLoadFactor: Int = 10
    private let highestNumOfCollisions: Int = 7
    
    private(set) public var count: Int = 0
    
    private(set) var initialBaseCapacity: Int = 30
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public init(capacity: Int) {
        assert(capacity > 0)
        self.initialBaseCapacity = capacity > initialBaseCapacity ? capacity : initialBaseCapacity
        buckets = Array<Bucket>(repeating: [], count: initialBaseCapacity)
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return value(for: key)
        }
        set {
            if let value = newValue {
                update(value: value, for: key)
            } else {
                removeValue(for: key)
            }
        }
    }
    
    /// This method will help ensure the key maps to an index within the bounds of the storage array, since this method can never produce a result > 4
    private func index(for key: Key) -> Int {
        return abs(key.hashValue) % buckets.count
    }
    
    public func value(for key: Key) -> Value? {
        let index = self.index(for: key)
        return buckets[index].first { $0.key == key }?.value
    }
    
    @discardableResult
    public mutating func update(value: Value, for key: Key) -> Value? {
        
        if !isEmpty {
            let currentLoad = self.count / self.buckets.count * 100
            if currentLoad >= resizeUpLoadFactor {
                self.resizeUp(from: self.buckets.count)
            }
        }
        
        let index = self.index(for: key)
        
        if let (i, element) = buckets[index].enumerated().first(where: { $0.1.key == key }) {
            let oldValue = element.value
            buckets[index][i].value = value
            return oldValue
        }
        
        buckets[index].append((key: key, value: value))
        count += 1
        return nil
    }
    
    @discardableResult mutating func removeValue(for key: Key) -> Value? {
        
        if !isEmpty {
            let currentLoad = self.count * 100 / self.buckets.count
            if currentLoad <= resizeDownLoadFactor {
                self.resizeDown(from: self.buckets.count)
            }
        }
        
        let index = self.index(for: key)
        
        if let (i, element) = buckets[index].enumerated().first(where: { $0.1.key == key }) {
            buckets[index].remove(at: i)
            count -= 1
            return element.value
        }
        
        return nil
    }
    
    private mutating func resizeUp(from capacity: Int) {
        resize(givenCapacity: capacity * 2)
    }
    
    private mutating func resizeDown(from capacity: Int) {
        resize(givenCapacity: capacity / 2)
    }
    
    mutating private func resize(givenCapacity capacity: Int) {
        let newBaseCapacity = nextPrime(after: capacity)
        
        if (newBaseCapacity <= self.initialBaseCapacity) || self.isEmpty { return }
        
        var newHashTable = HashTable(capacity: newBaseCapacity)
        
        self.buckets.forEach { (bucket) in
            if !(bucket.isEmpty) {
                bucket.forEach { element in
                    newHashTable[element.key] = element.value
                }
            }
        }
    
        self = newHashTable
    }
    
    private func isPrime(number: Int) -> Bool {
        if (number < 2) { return false }
        if (number < 4) { return false }
        if (number % 2) == 0 { return false }
        for i in stride(from: 3, through: Int(floor(sqrt(Double(number)))), by: 2) {
            if number % i == 0 {
                return false
            }
        }
        return true
    }
    
    ///  Return the next prime number after the number given
    private func nextPrime(after number: Int) -> Int {
        var mutableNumber: Int = number
        while !(isPrime(number: mutableNumber)) {
            mutableNumber += 1
        }
        return mutableNumber
    }
}

/// MARK: Test

var hashTable = HashTable<String, String>(capacity: 10)

hashTable["firstName"] = "Steve"

if let firstName = hashTable["firstName"] {
    print(firstName)
}

if let lastName = hashTable["lastName"] {
    print(lastName)
} else {
    print("lastName key not in hash table")
}

hashTable["firstName"] = nil

if let firstName = hashTable["firstName"] {
    print(firstName)
} else {
    print("firstName key is not in the hash table")
}

print(hashTable.count)
print(hashTable.initialBaseCapacity)
