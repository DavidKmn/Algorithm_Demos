import UIKit

class Node<T> {
    var next: Node<T>?
    var value: T
    
    init(value: T, next: Node<T>?) {
        self.value = value
        self.next = next
    }
}

func printList<T>(head: Node<T>?) {
    
    var current = head
   
    while current != nil {
        print(current!.value)
        current = current?.next
    }
}

let thirdNode = Node(value: 3, next: nil)
let secondNode = Node(value: 2, next: thirdNode)
let firstNode = Node(value: 1, next: secondNode)

printList(head: firstNode)

func reverseList<T>(head: Node<T>?) -> Node<T>? {
    
    var currentNode = head
    var prev: Node<T>?
    var next: Node<T>?
    
    
    while currentNode != nil {
        next = currentNode?.next
        currentNode?.next = prev
        prev = currentNode
        currentNode = next
    }
    
    return prev
}

let reversedList = reverseList(head: firstNode)
print("Reversed: ")
printList(head: reversedList)

