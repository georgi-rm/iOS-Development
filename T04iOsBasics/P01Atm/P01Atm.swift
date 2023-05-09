import Foundation
import Glibc

// Flag that enable exchange when try to withdraw foreign currency (example USD to EUR)
let enableCrossCurrencyExchange = false
 
enum Currency: String {
    case bgn = "BGN"
    case eur = "EUR"
    case usd = "USD"
    
    var rateToBgn: Double {
        switch self {
        case .bgn:
            return 1
        case .eur:
            return 1.956
        case .usd:
            return 1.858
        }
    }
    
    func convertToBgn(amount: Double, convertTaxInPercent: Double) -> Double {
        switch self {
        case .bgn:
            return amount
        case .eur, .usd:
            return amount * self.rateToBgn * (1 + convertTaxInPercent / 100)
        }
    }
    
    func convertToEur(amount: Double, convertTaxInPercent: Double) -> Double {
        switch self {
        case .eur:
            return amount
        case .bgn:
            return amount / Currency.eur.rateToBgn * (1 + convertTaxInPercent / 100)
        case .usd:
            return amount * Currency.usd.rateToBgn / Currency.eur.rateToBgn * (1 + convertTaxInPercent / 100)
        }
    }
    
    func convertToUsd(amount: Double, convertTaxInPercent: Double) -> Double {
        switch self {
        case .usd:
            return amount
        case .bgn:
            return amount / Currency.usd.rateToBgn * (1 + convertTaxInPercent / 100)
        case .eur:
            return amount * Currency.eur.rateToBgn / Currency.usd.rateToBgn * (1 + convertTaxInPercent / 100)
        }
    }
    
}

class Atm {
    let id: String
    var balance: [Currency: Double]
    let exchangeTaxPercent: Double = 2.0

    init(id: String, balance: [Currency: Double] ) {
        self.id = id
        self.balance = balance
    }

    func withdraw(card: Card, currency: Currency, amount: Double) {
    
        print(self.toString())
        print(card.toString())
    
        guard let aBankAccount = bankAccounts[card.iban] else {
            print("Карта с id: \(card.id) е фалшива! Не съществива сметка с IBAN: \(card.iban)")
            return
        }
        
        print(aBankAccount.toString())

        print(String(format: "Опит за теглене на %0.2f %@", amount, currency.rawValue))
    
        let currentBalance = balance[currency] ?? 0

        guard currentBalance >= amount else {
            print("Недостатъчна наличност в банкомата")
            print(self.toString())
            print(aBankAccount.toString())
            return
        }
        
        guard aBankAccount.withdraw(currency: currency, amount: amount, exchangeTaxPercent: self.exchangeTaxPercent) == true else {
            print("Недостатъчна наличност по вашата сметка")
            print(self.toString())
            print(aBankAccount.toString())
            return
        }
        
        balance[currency] = currentBalance - amount
        
        print(String(format: "Клиент %@, изтегли %0.2f %@", aBankAccount.owner, amount, currency.rawValue))
        
        print(self.toString())
        print(aBankAccount.toString())
    }


    func toString() -> String {
        var result: String = "Atm Id: \(id), Balance: "
        
        var tempArray: [String] = []

        for currency in balance {
            tempArray.append(String(format: "%@ - %0.2f", currency.key.rawValue, currency.value))
        }
        
        result += tempArray.joined(separator: ", ")
        return result
    }

}

class BankAccount {
    let owner: String
    let iban: String
    var balance: [Currency: Double]

    init(owner: String, iban: String, balance: [Currency: Double]) {
        self.owner = owner
        self.iban = iban
        self.balance = balance
    }

    func withdraw(currency: Currency, amount: Double, exchangeTaxPercent: Double) -> Bool {

        let currentBalance = balance[currency] ?? 0

        if amount <= currentBalance {
            balance[currency] = currentBalance - amount
            return true
        }
        
        if( currency == Currency.bgn || enableCrossCurrencyExchange) {
            let amountInBgnWithTax = currency.convertToBgn(amount: amount, convertTaxInPercent: exchangeTaxPercent)
            
            let balanceInBgn = balance[Currency.bgn] ?? 0
            
            if amountInBgnWithTax <= balanceInBgn {
                balance[Currency.bgn] = balanceInBgn - amountInBgnWithTax
                return true
            }
    
            let amountInEurWithTax = currency.convertToEur(amount: amount, convertTaxInPercent: exchangeTaxPercent)
            
            let balanceInEur = balance[Currency.eur] ?? 0
            
            if amountInEurWithTax <= balanceInEur {
                balance[Currency.eur] = balanceInEur - amountInEurWithTax
                return true
            }
    
            let amountInUsdWithTax = currency.convertToUsd(amount: amount, convertTaxInPercent: exchangeTaxPercent)
            
            let balanceInUsd = balance[Currency.usd] ?? 0
            
            if amountInUsdWithTax <= balanceInUsd {
                balance[Currency.usd] = balanceInUsd - amountInUsdWithTax
                return true
            }
        }

        return false
    }
    
    func toString() -> String {
        var result: String = "Bank Account IBAN: \(iban), Owner: \(owner), Balance: "
        
        var tempArray: [String] = []

        for currency in balance {
            tempArray.append(String(format: "%@ - %0.2f", currency.key.rawValue, currency.value))
        }
        
        result += tempArray.joined(separator: ", ")
        return result
    }
}

class Card {
    let id: String
    let owner: String
    let iban: String

    init(id: String, owner: String, iban: String) {
        self.id = id
        self.owner = owner
        self.iban = iban
    }

    func toString() -> String {
        return "Card Id: \(id), Owner: \(owner), IBAN: \(iban)"
    }
}

func generateBankAccounts() -> [String : BankAccount] {
    var generatedBankAccounts: [String : BankAccount] = [:]

    generatedBankAccounts["BG987654321"] = BankAccount(owner: "User 1", iban: "BG987654321", balance:  [Currency.bgn: 80.0])
    generatedBankAccounts["BG264692106"] = BankAccount(owner: "User 2", iban: "BG264692106", balance:  [Currency.bgn: 80.0])
    generatedBankAccounts["BG119906228"] = BankAccount(owner: "User 3", iban: "BG119906228", balance:  [Currency.bgn: 80.0])
    generatedBankAccounts["BG148690489"] = BankAccount(owner: "User 4", iban: "BG148690489", balance:  [Currency.bgn: 80.0])
    generatedBankAccounts["BG106109428"] = BankAccount(owner: "User 5", iban: "BG106109428", balance:  [Currency.bgn: 80.0, Currency.eur: 60.0])
    generatedBankAccounts["BG436872863"] = BankAccount(owner: "User 6", iban: "BG436872863", balance:  [Currency.bgn: 80.0, Currency.eur: 60.0])
    generatedBankAccounts["BG135057482"] = BankAccount(owner: "User 7", iban: "BG135057482", balance:  [Currency.bgn: 80.0, Currency.eur: 60.0, Currency.usd: 50.0])
    generatedBankAccounts["BG970254388"] = BankAccount(owner: "User 8", iban: "BG970254388", balance:  [Currency.bgn: 120.0, Currency.eur: 20.0, Currency.usd: 0.0])
    generatedBankAccounts["BG768497779"] = BankAccount(owner: "User 9", iban: "BG768497779", balance:  [Currency.bgn: 120.0, Currency.eur: 60.0, Currency.usd: 0.0])
    generatedBankAccounts["BG647326065"] = BankAccount(owner: "User 10", iban: "BG647326065", balance:  [Currency.bgn: 120.0, Currency.eur: 0.0, Currency.usd: 20.0])
    generatedBankAccounts["BG532910833"] = BankAccount(owner: "User 11", iban: "BG532910833", balance:  [Currency.bgn: 120.0, Currency.eur: 0.0, Currency.usd: 60.0])
    generatedBankAccounts["BG658970945"] = BankAccount(owner: "User 12", iban: "BG658970945", balance:  [Currency.bgn: 0.0, Currency.eur: 1.0, Currency.usd: 60.0])
    
    return generatedBankAccounts
}

func generateCards() -> [Card] {
    var generatedCards: [Card] = []

    // User 1
    generatedCards.append(Card(id: "817317078", owner: "User 1", iban: "BG987654321"))
    generatedCards.append(Card(id: "325583628", owner: "User 1", iban: "BG987654321"))
    
    // User 2
    generatedCards.append(Card(id: "2041408571", owner: "User 2", iban: "BG264692106"))
    generatedCards.append(Card(id: "2068084612", owner: "User 2", iban: "BG264692106"))
    
    // User 3
    generatedCards.append(Card(id: "836403601", owner: "User 3", iban: "BG119906228"))
    generatedCards.append(Card(id: "1371216843", owner: "User 3", iban: "BG119906228"))
    
    // User 4
    generatedCards.append(Card(id: "12083891", owner: "User 4", iban: "BG148690489"))
    generatedCards.append(Card(id: "1834249175", owner: "User 4", iban: "BG148690489"))
    
    // User 5
    generatedCards.append(Card(id: "259145404", owner: "User 5", iban: "BG106109428"))
    generatedCards.append(Card(id: "1406969348", owner: "User 5", iban: "BG106109428"))
    
    // User 6
    generatedCards.append(Card(id: "1707372051", owner: "User 6", iban: "BG436872863"))
    generatedCards.append(Card(id: "1958282696", owner: "User 6", iban: "BG436872863"))
    
    // User 7
    generatedCards.append(Card(id: "344871517", owner: "User 7", iban: "BG135057482"))
    generatedCards.append(Card(id: "386685073", owner: "User 7", iban: "BG135057482"))

    // User 8
    generatedCards.append(Card(id: "960555621", owner: "User 8", iban: "BG970254388"))
    generatedCards.append(Card(id: "147436942", owner: "User 8", iban: "BG970254388"))
    
    // User 9
    generatedCards.append(Card(id: "1114700336", owner: "User 9", iban: "BG768497779"))
    generatedCards.append(Card(id: "1065130443", owner: "User 9", iban: "BG768497779"))
    
    // User 10
    generatedCards.append(Card(id: "1000851122", owner: "User 10", iban: "BG647326065"))
    generatedCards.append(Card(id: "1767675194", owner: "User 10", iban: "BG647326065"))
    
    // User 11
    generatedCards.append(Card(id: "1573637528", owner: "User 11", iban: "BG532910833"))
    generatedCards.append(Card(id: "1063604845", owner: "User 11", iban: "BG532910833"))
    
    // User 12
    generatedCards.append(Card(id: "6546588854", owner: "User 12", iban: "BG658970945"))
    generatedCards.append(Card(id: "3245567035", owner: "User 12", iban: "BG658970945"))
    
    // User 13
    generatedCards.append(Card(id: "9554321558", owner: "User 13", iban: "BG465445634"))
    generatedCards.append(Card(id: "7651321561", owner: "User 13", iban: "BG312148465"))

    return generatedCards
}


var bankAccounts: [String : BankAccount] = generateBankAccounts()
var cards: [Card] = generateCards();

func printTestHeading(numberOfTest: Int) {
    if numberOfTest > 1 {
       print() 
    }
    print("=========================================")
    print("Test \(numberOfTest)")
    print("=========================================")
}

printTestHeading(numberOfTest: 1)

var atm1: Atm = Atm(id: "123456", balance: [Currency.bgn: 20])

atm1.withdraw(card: cards[0], currency: Currency.bgn, amount: 20.0)

printTestHeading(numberOfTest: 2)

var atm2: Atm = Atm(id: "65634", balance: [Currency.bgn: 100])

atm2.withdraw( card: cards[2], currency: Currency.bgn, amount: 80.0)

printTestHeading(numberOfTest: 3)

var atm3: Atm = Atm(id: "12357", balance: [Currency.bgn: 100])

atm3.withdraw( card: cards[4], currency: Currency.bgn, amount: 90.0)

printTestHeading(numberOfTest: 4)

var atm4: Atm = Atm(id: "76456", balance: [Currency.bgn: 60])

atm4.withdraw( card: cards[6], currency: Currency.bgn, amount: 80.0)

printTestHeading(numberOfTest: 5)

var atm5: Atm = Atm(id: "436563", balance: [Currency.bgn: 100])

atm5.withdraw( card: cards[8], currency: Currency.bgn, amount: 100.0)

printTestHeading(numberOfTest: 6)

var atm6: Atm = Atm(id: "90463", balance: [Currency.bgn: 400])

atm6.withdraw( card: cards[10], currency: Currency.bgn, amount: 150.0)

printTestHeading(numberOfTest: 7)
var atm7: Atm = Atm(id: "645564", balance: [Currency.bgn: 50, Currency.eur: 50, Currency.usd: 50])

atm7.withdraw( card: cards[12], currency: Currency.usd, amount: 24.0)
print("-------------- Second Card --------------")
atm7.withdraw( card: cards[13], currency: Currency.usd, amount: 25.0)

printTestHeading(numberOfTest: 8)
var atm8: Atm = Atm(id: "34634346", balance: [Currency.bgn: 0, Currency.eur: 70, Currency.usd: 20])

atm8.withdraw( card: cards[14], currency: Currency.eur, amount: 50.0)

printTestHeading(numberOfTest: 9)
var atm9: Atm = Atm(id: "7666", balance: [Currency.bgn: 0, Currency.eur: 70, Currency.usd: 20])

atm9.withdraw( card: cards[16], currency: Currency.eur, amount: 50.0)

printTestHeading(numberOfTest: 10)
var atm10: Atm = Atm(id: "346555", balance: [Currency.bgn: 0, Currency.eur: 20, Currency.usd: 70])

atm10.withdraw( card: cards[18], currency: Currency.usd, amount: 50.0)

printTestHeading(numberOfTest: 11)
var atm11: Atm = Atm(id: "799345", balance: [Currency.bgn: 0, Currency.eur: 20, Currency.usd: 70])

atm11.withdraw( card: cards[20], currency: Currency.usd, amount: 50.0)

printTestHeading(numberOfTest: 12)
var atm12: Atm = Atm(id: "824623", balance: [Currency.bgn: 0, Currency.eur: 20, Currency.usd: 0])

atm12.withdraw( card: cards[22], currency: Currency.eur, amount: 20.0)

printTestHeading(numberOfTest: 13)
var atm13: Atm = Atm(id: "454312", balance: [Currency.bgn: 0, Currency.eur: 20, Currency.usd: 0])

atm13.withdraw( card: cards[24], currency: Currency.eur, amount: 20.0)