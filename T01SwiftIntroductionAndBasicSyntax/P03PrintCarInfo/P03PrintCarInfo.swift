struct Car {
    let make: String
    let model: String
    let horsePower: Double
    let torque: Float
    let dateOfManufacturing: String
}

func printCarAsCsv(car: Car) {
    
    print(car.make, car.model, car.horsePower.description,
          car.torque.description, car.dateOfManufacturing, separator: "," )
}

func printCarPowerInWatts( car: Car ) {
    let hpToWattsConstant = 745.699872
    let powerInWatts: Double = car.horsePower * hpToWattsConstant
    print( "Power of the car is: \(powerInWatts) W" )
}

let car: Car = Car(make: "Hyundai",
                   model: "Kona",
                   horsePower: 204.0,
                   torque: 123.456,
                   dateOfManufacturing: "01.12.2022")
                    
printCarAsCsv(car: car)
printCarPowerInWatts(car: car)


