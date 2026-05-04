double add(double a, double b) => a + b;
double subtract(double a, double b) => a - b;
double multiply(double a, double b) => a * b;
double divide(double a, double b) => a / b;

double? calculate(double firstOperand, String operator, double secondOperand) {
  switch (operator) {
    case '+':
      return add(firstOperand, secondOperand);
    case '-':
      return subtract(firstOperand, secondOperand);
    case '*':
      return multiply(firstOperand, secondOperand);
    case '/':
      if (secondOperand == 0) return null;
      return divide(firstOperand, secondOperand);
    default:
      return null;
  }
}
