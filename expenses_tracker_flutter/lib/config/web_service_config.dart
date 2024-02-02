const baseURL = 'http://localhost:5285';
const expenseController = 'Expense';
const createExpenseUrl = baseURL + '/' + expenseController + '/' + 'createExpense';
const getAllExpensesUrl = baseURL + '/' + expenseController + '/' + 'getAllExpenses';
const getTotalMoneySpentThisMonthUrl = baseURL + '/' + expenseController + '/' + 'getTotalMoneySpentThisMonth';
const getTotalPricePerCategoryUrl = baseURL + '/' + expenseController + '/' + 'getTotalPricePerCategory';
const searchExpensesFilterUrl = baseURL + '/' + expenseController + '/' + 'filterExpenses';