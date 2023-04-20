struct Circle {
    let surface: Double
    let perimeter: Float
}

func surfaceAndPerimeterOfCircleWith(radius: Float) -> Circle {
    let surface = Double.pi * Double(radius) * Double(radius)
    let perimeter = 2 * Float.pi * radius
    
    let result = Circle(surface: surface, perimeter: perimeter)
    return result
}

let circle: Circle = surfaceAndPerimeterOfCircleWith(radius: 5.4)

print("Surface of circle is: \(circle.surface)")
print("Perimeter of circle is: \(circle.perimeter)\n")
