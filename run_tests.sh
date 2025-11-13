#!/bin/bash

# Automated test runner for RealFutharkLanguage
# Usage: ./run_tests.sh

PASSED=0
FAILED=0
TOTAL=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "==================================="
echo "RealFutharkLanguage Test Suite"
echo "==================================="
echo ""

# Function to run a test
run_test() {
    local test_name="$1"
    local test_file="$2"
    local expected_output="$3"
    local should_fail="$4"  # "fail" if we expect non-zero exit code

    TOTAL=$((TOTAL + 1))

    echo -n "Testing $test_name... "

    # Run the test and capture output and exit code
    actual_output=$(./futhark "$test_file" 2>&1)
    exit_code=$?

    # Check exit code expectation
    if [ "$should_fail" = "fail" ]; then
        if [ $exit_code -ne 0 ]; then
            echo -e "${GREEN}PASS${NC} (failed as expected)"
            PASSED=$((PASSED + 1))
            return 0
        else
            echo -e "${RED}FAIL${NC} (should have failed but didn't)"
            FAILED=$((FAILED + 1))
            return 1
        fi
    fi

    # Check output matches expected
    if echo "$actual_output" | grep -q "$expected_output"; then
        echo -e "${GREEN}PASS${NC}"
        PASSED=$((PASSED + 1))
    else
        echo -e "${RED}FAIL${NC}"
        echo "  Expected: $expected_output"
        echo "  Got: $actual_output"
        FAILED=$((FAILED + 1))
    fi
}

# Success Tests
echo "--- Arithmetic Tests ---"
run_test "arithmetic operations" "simple.ᚠᚢᚦᛆᚱᚴ" "Result: 15"
run_test "variable multiplication" "test.ᚠᚢᚦᛆᚱᚴ" "Result: 48"

echo ""
echo "--- Comparison Operator Tests ---"
run_test "not equal (!=)" "test_not_equal.ᚠᚢᚦᛆᚱᚴ" "Result: 1"
run_test "less than (<)" "test_less_than.ᚠᚢᚦᛆᚱᚴ" "Result: 1"

echo ""
echo "--- Control Flow Tests ---"
run_test "if true branch" "if_simple.ᚠᚢᚦᛆᚱᚴ" "Result: 16"
run_test "if false branch (skip)" "test_if_false.ᚠᚢᚦᛆᚱᚴ" "Result: 5"
run_test "if-else branch" "if_else_test.ᚠᚢᚦᛆᚱᚴ" "Result: 17"
run_test "while loop executes" "while_test.ᚠᚢᚦᛆᚱᚴ" "Result: 20"
run_test "while loop never executes" "test_while_false.ᚠᚢᚦᛆᚱᚴ" "Result: 16"
run_test "nested if inside while" "nested_test.ᚠᚢᚦᛆᚱᚴ" "Result: 9"
run_test "factorial calculation" "factorial.ᚠᚢᚦᛆᚱᚴ" "Result: 120"

echo ""
echo "--- Integration Tests ---"
run_test "comprehensive features" "comprehensive_test.ᚠᚢᚦᛆᚱᚴ" "Result: 18"
run_test "empty input file" "test_empty.ᚠᚢᚦᛆᚱᚴ" "^$"

echo ""
echo "--- Error Tests ---"
run_test "undefined variable" "error_test1.ᚠᚢᚦᛆᚱᚴ" "Undefined variable"
run_test "syntax error" "error_test2.ᚠᚢᚦᛆᚱᚴ" "syntax error" "fail"
run_test "division by zero" "error_test3.ᚠᚢᚦᛆᚱᚴ" "Division by zero"

echo ""
echo "==================================="
echo "Test Results:"
echo "  Passed: $PASSED"
echo "  Failed: $FAILED"
echo "  Total:  $TOTAL"
echo "==================================="

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
