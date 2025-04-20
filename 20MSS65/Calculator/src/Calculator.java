public class Calculator {
    public int add(int a, int b) {
        if (a <= 0 || b <= 0) {
            throw new IllegalArgumentException("Both numbers must be positive");
        }
        return a + b;
    }

    public int multiply(int a, int b) {
        if (a <= 0 || b <= 0) {
            throw new IllegalArgumentException("Both numbers must be positive");
        }
        return a * b;
    }

    public double divide(int a, int b) {
        if (a <= 0 || b <= 0) {
            throw new IllegalArgumentException("Both numbers must be positive");
        }
        if (b == 0) {
            throw new IllegalArgumentException("Cannot divide by zero");
        }
        return (double) a / b;
    }
}

