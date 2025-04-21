import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class OddEvenTest {
    private OddEven oddeven;
    
    @BeforeEach
    void setUp() {
        oddeven = new OddEven();
    }

    @Test
    @DisplayName("Odd Number")
    void testOddNumber() {
        assertFalse(oddeven.findOddOrEven(3), "Should return false for Odd Number.");
    }

    @Test
    @DisplayName("Even Number")
    void testEvenNumber() {
        assertTrue(oddeven.findOddOrEven(4), "Should return true for Even Number.");
    }
}

