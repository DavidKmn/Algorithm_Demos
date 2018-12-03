import Foundation


class Node {
    var value: Int
    var next: Node?
    
    init(value: Int, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

class LinkedList {
    var head: Node?
    
    init(head: Node?) {
        self.head = head
    }
    
    func append(value: Int) {
        print(String(format: "Insert: %i", value))
        guard var current = head else {
            head = Node(value: value, next: nil)
            return
        }
        
        while current.next != nil {
            if let next = current.next {
                current = next
            }
        }
        let newNode = Node(value: value, next: nil)
        current.next = newNode
    }
    
    func delete(value: Int) {
        print(String(format: "Delete: %i", value))

        guard let head = head else {return}
        
        guard head.value != value else {
            self.head = head.next
            return
        }
    
        var current = head
        var previous: Node? = nil
        
        while current.value != value {
            if let next = current.next {
                previous = current
                current = next
            }
        }
        if let next = current.next {
            previous?.next = next
        } else {
            previous?.next = nil
        }
    }
    
    func sortedInsert(value: Int) {
        print(String(format: "Sorted Insert: %i", value))
        
        if head == nil || head?.value ?? Int.min >= value {
            let newNode = Node(value: value, next: head)
            head = newNode
            return
        }
        
        var currentNode: Node? = head
        
        while currentNode?.next != nil && currentNode?.next?.value ?? Int.min < value {
            currentNode = currentNode?.next
        }
        
        currentNode?.next = Node(value: value, next: currentNode?.next)        
    }
    
    func display() {
        if head == nil { return }
        print("---------------------- Displaying Linked List ----------------------")
        var current = head
        while current != nil {
            print(current?.value ?? 0)
            current = current?.next
        }
    }
}

let headNode = Node(value: 1)
let ll = LinkedList(head: nil)
ll.sortedInsert(value: -2)
ll.display()
ll.delete(value: -2)
ll.display()
