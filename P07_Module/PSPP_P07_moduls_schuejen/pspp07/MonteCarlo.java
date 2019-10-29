package pspp07;

import ch.zhaw.random.HighQualityRandom;

public class MonteCarlo {
    private double approximatePi(int iterations) {
        HighQualityRandom random = new HighQualityRandom();
        int redPoints = 0;
        double x, y;

        for (int i = 0; i < iterations; i++) {
            x = random.nextDouble();
            y = random.nextDouble();

            if ((x*x + y*y) < 1) {
                redPoints++;
            }
        }

        return ((double) redPoints)/iterations * 4;
    }

    public static void main(String[] args) {
        int iterations = 1000000;
        System.out.println("Pi: " + (new MonteCarlo()).approximatePi(iterations));
    }
}
