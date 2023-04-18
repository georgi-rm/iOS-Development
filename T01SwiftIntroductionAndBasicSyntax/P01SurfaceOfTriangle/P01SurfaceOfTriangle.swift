func surfaceOfTriangleWith(side: Float, height: Float) -> Float {
    let result: Float = side * height / 2
    return result
}

let surfaceOfTriangle: Float = surfaceOfTriangleWith(side: 4.23, height: 2.54)
print("Surface of triangle is: \(surfaceOfTriangle)\n")
