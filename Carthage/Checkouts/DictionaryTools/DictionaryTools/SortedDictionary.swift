//
//  SortedDictionary.swift
//  DictionaryTools
//
//  Created by James Bean on 6/26/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import ArrayTools

/**
 Ordered Dictionary that keeps its `keys` sorted.
 
 - warning: The order of the generic types is `<Value, Key>`, due to a bug in Swift.
 */
public struct SortedDictionary<V, K> where K: Hashable, K: Comparable {
    
    // MARK: - Instance Properties
    
    /// Sorted keys.
    public var keyStorage: KeyStorage = []
    
    /// Backing dictionary.
    public var values: [Key: Value] = [:]
    
    // MARK: - Initializers
    
    /**
     Create an empty `SortedOrderedDictionary`.
     */
    public init() { }
    
    // MARK: - Instance Methods
    
    /**
     Insert the given `value` for the given `key`. Order will be maintained.
     */
    public mutating func insert(_ value: Value, key: Key) {
        keyStorage.insert(key)
        values[key] = value
    }
    
    /**
     Insert the contents of another `SortedOrderedDictionary` value.
     */
    public mutating func insertContents(
        of sortedDictionary: SortedDictionary<Value, Key>
    )
    {
        sortedDictionary.forEach { insert($0.1, key: $0.0) }
    }
    
    /**
     - returns: Value at the given `index`, if present. Otherwise, `nil`.
     
     - TODO: Find a way to push this up the `OrderedDictionaryType` protocol hierarchy.
     */
    public func value(at index: Int) -> Value? {
        if index >= keyStorage.count { return nil }
        return values[keyStorage[index]]
    }
    
    // TODO: Remove
}

extension SortedDictionary: DictionaryType {
    
    // MARK: - `DictionaryType`

    // Key type.
    public typealias Key = K
    
    // Value type.
    public typealias Value = V
    
    /**
     - returns: Value for the given `key`, if available. Otherise `nil`.
     */
    public subscript(key: Key) -> Value? {
        
        get { return values[key] }
        
        set(newValue) {
            
            if newValue == nil {
                values.removeValue(forKey: key)
                keyStorage = SortedArray(keyStorage.filter { $0 != key })
                return
            }
            
            let oldValue = values.updateValue(newValue!, forKey: key)
            if oldValue == nil { keyStorage.insert(key) }
        }
    }
}

extension SortedDictionary: OrderedDictionaryType {
 
    // MARK: - `OrderedDictionaryType`
    
    /// `CollectionType` storing keys.
    public typealias KeyStorage = SortedArray<Key>
}

/**
 - returns: `SortedOrderedDictionary` with values of two `SortedOrderedDictionary` values.
 */
public func + <Value, Key> (
    lhs: SortedDictionary<Value, Key>,
    rhs: SortedDictionary<Value, Key>
) -> SortedDictionary<Value, Key> where Key: Hashable, Key: Comparable
{
    var result = lhs
    rhs.forEach { result.insert($0.1, key: $0.0) }
    return result
}

extension SortedDictionary: Collection {
    
    // MARK: - `CollectionType`
    
    public typealias Index = DictionaryIndex<Key, Value>
    public var startIndex: Index { return values.startIndex }
    public var endIndex: Index { return values.endIndex }

    public func index(after i: Index) -> Index {
        guard i != endIndex else { fatalError("Cannot increment endIndex") }
        return values.index(after: i)
    }
    
    /**
     - returns: Value at the given `index`. Will crash if index out-of-range.
     */
    public subscript (index: Index) -> (Key, Value) {
        return values[index]
    }
}
