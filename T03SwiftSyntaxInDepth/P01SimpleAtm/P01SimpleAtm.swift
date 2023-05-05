import Foundation
import Glibc

enum Currency: String {
    case bgn = "BGN"
    case eur = "EUR"
    case usd = "USD"
    
    func exchangeFromBgn(currency: Double) -> Double {
        switch self {
            case .bgn:
                return currency
            case .eur:
                return currency / 1.956
            case .usd:
                return currency / 1.858
        }
    }
}

struct Atm {
    let id: String
    var balance: [Currency: Double]
    let exchangeTaxPercent: Double = 2.0

    func isBalanceAvailable(requiredAmount: Double) -> Bool {
        if requiredAmount <= balance[Currency.bgn] ?? 0 {
            return true
        }
        return false
    }

}

struct Card {
    let id: String
    let owner: String
    var balance: [Currency: Double]

    func isBalanceAvailable(requiredAmount: Double, requiredAmountWhenExchanged: Double) -> Bool {
        if requiredAmount <= balance[Currency.bgn] ?? 0 {
            return true
        }
        
        if Currency.eur.exchangeFromBgn(currency: requiredAmountWhenExchanged) <= balance[Currency.eur] ?? 0 {
            return true
        }
        
        if Currency.usd.exchangeFromBgn(currency: requiredAmountWhenExchanged) <= balance[Currency.usd] ?? 0 {
            return true
        }
        
        return false
    }
    
}

func withdrawMoney(atm: inout Atm, card: inout Card, requiredAmount: Double) -> String {

    if !atm.isBalanceAvailable(requiredAmount: requiredAmount) {
        return "Недостатъчна наличност в банкомата"
    }
    
    let requiredAmountWhenExchanged = requiredAmount * (1 + atm.exchangeTaxPercent / 100)
    if !card.isBalanceAvailable(requiredAmount: requiredAmount, requiredAmountWhenExchanged: requiredAmountWhenExchanged) {
        return "Недостатъчна наличност по вашата сметка"
    }

    if atm.balance[Currency.bgn] == nil {
        atm.balance[Currency.bgn] = 0.0
    }

    let tempAtmBalance = (atm.balance[Currency.bgn] ?? 0 ) - requiredAmount
    
    if( tempAtmBalance < 0.0) {
        return "Недостатъчна наличност в банкомата"
    }
    
    atm.balance[Currency.bgn] = tempAtmBalance
    
    let requiredAmountEur = Currency.eur.exchangeFromBgn(currency: requiredAmountWhenExchanged)
    let requiredAmountUsd = Currency.usd.exchangeFromBgn(currency: requiredAmountWhenExchanged)
    
    if requiredAmount <= card.balance[Currency.bgn] ?? 0 {
        card.balance[Currency.bgn] = (card.balance[Currency.bgn] ?? 0) - requiredAmount
    } else if requiredAmountEur <= card.balance[Currency.eur] ?? 0 {
        card.balance[Currency.eur] = (card.balance[Currency.eur] ?? 0) - requiredAmountEur
    } else if requiredAmountUsd <= card.balance[Currency.usd] ?? 0 {
        card.balance[Currency.usd] = (card.balance[Currency.usd] ?? 0) - requiredAmountUsd
    } else {
        return "Недостатъчна наличност по вашата сметка"
    }

    return "Изтеглени са: \(requiredAmount) \(Currency.bgn.rawValue)"
}

print("Test 1")

var atm1: Atm = Atm(id: "123456", balance: [Currency.bgn: 20])

var user1Card: Card = Card(id: "987654321", owner: "Pesho", balance: [Currency.bgn: 80.0])

print("State before transaction:")
print(user1Card)
print(atm1)
print("Result: \(withdrawMoney(atm: &atm1, card: &user1Card, requiredAmount: 20.0))")
print("State after transaction:")
print(user1Card)
print(atm1)


print("\nTest 2")

var atm2: Atm = Atm(id: "65634", balance: [Currency.bgn: 100])

var user2Card: Card = Card(id: "34232432", owner: "Gosho", balance: [Currency.bgn: 80.0])

print("State before transaction:")
print(user2Card)
print(atm2)
print("Result: \(withdrawMoney(atm: &atm2, card: &user2Card, requiredAmount: 80.0))")
print("State after transaction:")
print(user2Card)
print(atm2)


print("\nTest 3")

var atm3: Atm = Atm(id: "12357", balance: [Currency.bgn: 100])

var user3Card: Card = Card(id: "63453", owner: "Tosho", balance: [Currency.bgn: 80.0])

print("State before transaction:")
print(user3Card)
print(atm3)
print("Result: \(withdrawMoney(atm: &atm3, card: &user3Card, requiredAmount: 90.0))")
print("State after transaction:")
print(user3Card)
print(atm3)

print("\nTest 4")

var atm4: Atm = Atm(id: "76456", balance: [Currency.bgn: 60])

var user4Card: Card = Card(id: "3523725397", owner: "Ivan", balance: [Currency.bgn: 80.0])

print("State before transaction:")
print(user4Card)
print(atm4)
print("Result: \(withdrawMoney(atm: &atm4, card: &user4Card, requiredAmount: 80.0))")
print("State after transaction:")
print(user4Card)
print(atm4)

print("\nTest 5")

var atm5: Atm = Atm(id: "436563", balance: [Currency.bgn: 100])

var user5Card: Card = Card(id: "2358456", owner: "Petko", balance: [Currency.bgn: 80.0, Currency.eur: 60.0])

print("State before transaction:")
print(user5Card)
print(atm5)
print("Result: \(withdrawMoney(atm: &atm5, card: &user5Card, requiredAmount: 100.0))")
print("State after transaction:")
print(user5Card)
print(atm5)

print("\nTest 6")

var atm6: Atm = Atm(id: "90463", balance: [Currency.bgn: 400])

var user6Card: Card = Card(id: "56565656565", owner: "Ani", balance: [Currency.bgn: 80.0, Currency.eur: 60.0])

print("State before transaction:")
print(user6Card)
print(atm6)
print("Result: \(withdrawMoney(atm: &atm6, card: &user6Card, requiredAmount: 150.0))")
print("State after transaction:")
print(user6Card)
print(atm6)



