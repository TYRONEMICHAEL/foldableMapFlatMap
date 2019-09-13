func dropFirst<A>(_ arr: [A]) -> [A] {
    return Array(arr.dropFirst(1))
}

func foldRight<A, B>(_ fn: (A, B) -> B, _ initial: B, _ list: [A]) -> B {
    guard let value = list.first else {
        return initial
    }

    return fn(value, foldRight(fn, initial, dropFirst(list)))
}

func foldLeft<A, B>(_ fn: (A, B) -> B, _ initial: B, _ list: [A]) -> B {
    func iter(_ fn: (A, B) -> B, result: B, _ list: [A]) -> B {
        guard let value = list.first else {
            return result
        }

        return iter(fn, result: fn(value, result), dropFirst(list))
    }

    return iter(fn, result: initial, list)
}

func map<A, B>(_ fn: (A) -> B, _ list: [A]) -> [B] {
    guard let value = list.first else {
        return []
    }

    return [fn(value)] + map(fn, dropFirst(list))
}

func flatMap<A, B>(_ fn: (A) -> [B], _ list: [A]) -> [B] {
    return foldRight(+, [], map(fn, list))
}

let square: (Int) -> [Int] = { x in [x * x] }
let sum: (Int, Int) -> Int = { a, b in a + b }

foldLeft(sum, 0, [1, 2, 3])
foldRight(sum, 0, [1, 2, 3])
flatMap(square, [1, 2, 3])

// Permutations

func remove<A: Equatable>(_ a: A, _ arr: [A]) -> [A] {
    return arr.filter { x in a != x }
}

func permutations(_ list: [Int]) -> [[Int]] {
    if list.isEmpty {
        return [[]]
    }

    return flatMap({ x in
        return map({ y in
            [x] + y
        }, permutations(remove(x, list)))
    }, list)
}

permutations([1, 2, 3])
