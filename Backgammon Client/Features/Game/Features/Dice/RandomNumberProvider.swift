// RandomNumberProviding.swift
protocol RandomNumberProviding {
    func rollDie() -> Int
}

struct SystemRandomNumberProvider: RandomNumberProviding {
    func rollDie() -> Int { Int.random(in: 1...6) }
}
