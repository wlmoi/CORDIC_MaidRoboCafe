class Cordic {
    constructor() {
        this.CORDIC_ANGLES = [
            45.0, 26.5651, 14.0362, 7.1250, 3.5763,
            1.7899, 0.8952, 0.4476, 0.2238, 0.1119,
            0.0560, 0.0280, 0.0140, 0.0070, 0.0035,
            0.0017, 0.0009, 0.0004, 0.0002, 0.0001,
            0.00005, 0.00002, 0.00001, 0.000005,
            0.000002, 0.000001, 0.0000005, 0.0000002,
            0.0000001, 0.00000005, 0.00000002
        ];
        this.SCALING_FACTOR = 0.607252935;
    }

    cordic(x, y, iterations = 31) {
        let z = 0;
        for (let i = 0; i < iterations; i++) {
            let x_shift = this.rightShift(x, i);
            let y_shift = this.rightShift(y, i);

            if (y >= 0) {
                [x, y, z] = [x + y_shift, y - x_shift, z + this.CORDIC_ANGLES[i]];
            } else {
                [x, y, z] = [x - y_shift, y + x_shift, z - this.CORDIC_ANGLES[i]];
            }
        }
        const r = x * this.SCALING_FACTOR;
        return { r, phi: z, x, y };
    }

    rightShift(value, shift) {
        return value / (1 << shift); // Equivalent to bitsra in MATLAB
    }
}

module.exports = Cordic;
