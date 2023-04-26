import Foundation

struct FuelCharge {
    let odometerReading: Double
    let amountOfFuel: Double
    let dateOfFueling: String
}

var fuelCharges: [FuelCharge] = []

func averageFuelConsumption() -> Double {

    if fuelCharges.count == 0 {
        return 0.0
    }

    var totalDistance: Double = 0.0
    var totalFuel: Double = 0.0

    var previousCharge: FuelCharge = fuelCharges[0]

    for currentCharge in fuelCharges {
        let distance = currentCharge.odometerReading - previousCharge.odometerReading
        
        if distance > 0 {
            totalDistance += distance
            totalFuel += previousCharge.amountOfFuel

            previousCharge = currentCharge
        }
    }

    return calculateFuelConsumption(distance: totalDistance, amountOfFuel: totalFuel)
}

func calculateFuelConsumption(distance: Double, amountOfFuel: Double) -> Double {

    if distance == 0 {
        return 0
    }

    return amountOfFuel / distance * 100
}

func chargeFuel(odometerReading: Double, amountOfFuel: Double, dateOfFueling: String) -> Double {

    let currentFuelCharge: FuelCharge = FuelCharge(odometerReading: odometerReading,
                            amountOfFuel: amountOfFuel, dateOfFueling: dateOfFueling)
                            
                            
    var previousCharge: FuelCharge = FuelCharge(odometerReading: odometerReading,
                            amountOfFuel: 0.0, dateOfFueling: "")
    
    if fuelCharges.count > 0 {
        previousCharge = fuelCharges[fuelCharges.count - 1]
    }
    
    let distance = currentFuelCharge.odometerReading - previousCharge.odometerReading

    if distance < 0 {
        return 0.0
    }
    
    fuelCharges.append(currentFuelCharge)
    
    return calculateFuelConsumption(distance: distance, amountOfFuel: previousCharge.amountOfFuel)
}

func convertLitersPer100KmToMPG(litersPer100Km: Double) -> Double {
    
    let ratioMileToKm: Double = 1.609344
    let ratioGallonToLiters: Double = 3.78541178
    
    let litersPerKm: Double = litersPer100Km / 100
    let kmPerLiter = 1 / litersPerKm
    

    let mpg: Double = kmPerLiter * ratioGallonToLiters / ratioMileToKm
    
    return mpg
}

func averagePricePerKilometer(pricePerLitter: Double) -> Double {

    if fuelCharges.count == 0 {
        return 0.0
    }

    var totalDistance: Double = 0.0
    var totalFuel: Double = 0.0

    var previousCharge: FuelCharge = fuelCharges[0]

    for currentCharge in fuelCharges {
        let distance = currentCharge.odometerReading - previousCharge.odometerReading
        
        if distance > 0 {
            totalDistance += distance
            totalFuel += previousCharge.amountOfFuel
        
            previousCharge = currentCharge
        }
    }

    if totalDistance == 0 {
        return 0
    }

    return totalFuel * pricePerLitter / totalDistance
}

func printStatistics() {

    if fuelCharges.count <= 1 {
        print("Not enough data!")
        return
    }

    var previousCharge: FuelCharge = fuelCharges[0]

    for currentCharge in fuelCharges {
        let distance = currentCharge.odometerReading - previousCharge.odometerReading
        
        if distance > 0 {
            let  fuelConsumption: Double = calculateFuelConsumption(distance: distance,
                                                                amountOfFuel: previousCharge.amountOfFuel)
                                                                
            print(String(format: "Fuel consumption %0.2f l/100km from %@ to %@", fuelConsumption, previousCharge.dateOfFueling, currentCharge.dateOfFueling))

            previousCharge = currentCharge
        }
    }

}

var averageFuelConsumptionPerCharge: Double = chargeFuel(odometerReading: 50, amountOfFuel: 2.35, dateOfFueling: "04.12.2022 10:34")

averageFuelConsumptionPerCharge = chargeFuel(odometerReading: 99, amountOfFuel: 2.35, dateOfFueling: "05.12.2022 12:54")

print(String(format: "Fuel consumption between the current and the last fueling: %0.2f l/100km", averageFuelConsumptionPerCharge))

averageFuelConsumptionPerCharge = chargeFuel(odometerReading: 150, amountOfFuel: 2.1, dateOfFueling: "06.12.2022 13:25")

print(String(format: "Fuel consumption between the current and the last fueling: %0.2f l/100km", averageFuelConsumptionPerCharge))

averageFuelConsumptionPerCharge = chargeFuel(odometerReading: 199, amountOfFuel: 2.8, dateOfFueling: "07.12.2022 09:12")

print(String(format: "Fuel consumption between the current and the last fueling: %0.2f l/100km", averageFuelConsumptionPerCharge))

print(String(format: "Average fuel consumption: %0.2f l/100km", averageFuelConsumption()))

let averageFuelConsumptionMPG: Double = convertLitersPer100KmToMPG( litersPer100Km: averageFuelConsumption() )

print(String(format: "Average fuel consumption: %0.2f mpg", averageFuelConsumptionMPG))

print(String(format: "Average price: %0.2f bgn/km", averagePricePerKilometer(pricePerLitter: 3.15)))

printStatistics()


