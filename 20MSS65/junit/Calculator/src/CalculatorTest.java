import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorTest {
    private Calculator calculator;

    @BeforeEach
    void setup() {
        calculator = new Calculator();
    }

    @Test
    void testAdd() {
        assertEquals(5, calculator.add(2, 3), "2 + 3 should equal 5");
        assertThrows(IllegalArgumentException.class, () -> calculator.add(-1, 3), "Negative input should throw exception");
    }

    @Test
    void testMultiply() {
        assertEquals(6, calculator.multiply(2, 3), "2 * 3 should equal 6");
        assertThrows(IllegalArgumentException.class, () -> calculator.multiply(2, -3), "Negative input should throw exception");
    }

    @Test
    void testDivide() {
        assertEquals(2.0, calculator.divide(6, 3), 0.0001, "6 / 3 should equal 2.0");
        assertThrows(IllegalArgumentException.class, () -> calculator.divide(5, 0), "Division by zero should throw exception");
        assertThrows(IllegalArgumentException.class, () -> calculator.divide(-5, 2), "Negative input should throw exception");
    }
}

