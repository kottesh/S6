import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class StringCompareTest {
    private StringCompare stringCompare;
    
    @BeforeEach
    void setUp() {
        stringCompare = new StringCompare();
    }

    @Test
    @DisplayName("Equal Strings")
    void testEqualStrings() {
        assertTrue(stringCompare.isStringEqual("Hello", "Hello"), "Should return true for equal strings.");
    }

    @Test
    @DisplayName("Unequal Strings")
    void testUnequalStrings() {
        assertFalse(stringCompare.isStringEqual("hi", "hello"), "Should return false for unequal strings.");
    }

    @Test
    @DisplayName("Case-sensitive Strings")
    void testCaseSensitiveStrings() {
        assertFalse(stringCompare.isStringEqual("Criptr", "criptr"), "Should return false for case sensitive strings.");
    }

    @Test
    @DisplayName("Null first argument throws NullPointerException")
    void testNullFirstArgument() {
        assertThrows(NullPointerException.class, () -> {
            stringCompare.isStringEqual(null, "hello");
        }, "Should throw NullPointerException for null first argument");
    }

    @Test
    @DisplayName("Null second argument returns false")
    void testNullSecondArgument() {
        assertFalse(stringCompare.isStringEqual("hello", null), "Should return false for null second argument");
    }

    @Test
    @DisplayName("Empty strings return true")
    void testEmptyStrings() {
        assertTrue(stringCompare.isStringEqual("", ""), "Should return true for empty strings");
    }
}


