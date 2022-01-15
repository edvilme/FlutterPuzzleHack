function getCentroid(coords){
    return {
        i: coords.reduce((accum, {i}) => accum+=i, 0)/coords.length,
        j: coords.reduce((accum, {j}) => accum+=j, 0)/coords.length,
    }
}

/**
 * ISOMETRIC PROJECTION
 * https://www.petercollingridge.co.uk/tutorials/svg/isometric-projection/
 * 
 * Rotation in plane of screen (z) 45°
 *           | cos(45°) -sin(45°)   0 |   | sqrt(2)/2   -sqrt(2)/2  0 |
 * Rz(45°) = | sin(45°) cos(45°)    0 | = | sqrt(2)/2   sqrt(2)/2   0 |
 *           | 0        0           1 |   | 0           0           1 |
 * 
 * Rotation through horizontal (x) a = arctam(sqrt(2))
 *         | 1  0       0       |   | 1 0           0          |
 * Rx(a) = | 0  cos(a)  -sin(a) | = | 0 sqrt(3)/3   -sqrt(6)/3 |
 *         | 0  sin(a)  cos(a)  |   | 0 sqrt(6)/3   sqrt(6)/3  |
 * 
 * Both matrices can be combined to a single transformation
 *         | sqrt(2)/2  -sqrt(2)/2  0           |
 * R_iso = | sqrt(6)/6  sqrt(6)/6   -sqrt(6)/3  |
 *         | sqrt(3)/3  sqrt(3)/3   sqrt(3)/3   |
 */

const R_iso = [
    [ Math.sqrt(2)/2,   -Math.sqrt(2)/2,    0 ],
    [ Math.sqrt(6)/6,   Math.sqrt(6)/6,     -Math.sqrt(6)/3 ],
    [ Math.sqrt(3)/3,   Math.sqrt(3)/3,     Math.sqrt(3)/3 ]
];

function getIsometricProjection(x, y, z){
    return [
        R_iso[0][0] * x + R_iso[0][1] * y + R_iso[0][2] * z,
        R_iso[1][0] * x + R_iso[1][1] * y + R_iso[1][2] * z,
        R_iso[2][0] * x + R_iso[2][1] * y + R_iso[2][2] * z
    ]
}