function getUserInput(input) {
  return parseInt(document.forms["timetofiform"].elements[input].value);
};

function calculateFI(monthlyExpenses, monthlyIncome, netWorth, averageReturn,
                                                            inflation, raises, safeWithdrawlRate) {
  var monthCount = 0;

  averageReturn = averageReturn/100 + 1;
  inflation = inflation/100 + 1;
  raises = raises/100 + 1;
  safeWithdrawlRate = safeWithdrawlRate/100;

  var percentFI = (netWorth / (300 * monthlyExpenses));

  while (percentFI < 1.0 ) {
    monthlyExpenses = monthlyExpenses * (Math.pow(inflation,(1/12)));
    if (monthCount % 12 == 0) { monthlyIncome *= raises; }
    monthCount += 1
    if (monthCount > 10000) { break; }
    netWorth = (netWorth * (Math.pow(averageReturn,(1/12))) )
                                              + monthlyIncome - monthlyExpenses;
    percentFI = (netWorth / ((12.0 / safeWithdrawlRate) * monthlyExpenses));
  };
  return monthCount
};

function displayTimeToFI() {
  var monthlyExpenses = getUserInput("month-expenses");
  var monthlyIncome = getUserInput("month-income");
  var netWorth = getUserInput("net-worth");

  var averageReturn = getUserInput("average-return");
  var inflation = getUserInput("inflation");
  var raises = getUserInput("raises");
  var safeWithdrawlRate = getUserInput("safe-withdrawl-rate");


  var timeToFI = calculateFI(monthlyExpenses, monthlyIncome, netWorth,
                                              averageReturn, inflation, raises, safeWithdrawlRate);

  var divobj = document.getElementById('time-to-fi-output');
  divobj.style.display='block';
  divobj.innerHTML = "Your Time to FI is: "+ timeToFI +" months!";
}

function displayChangeInFI() {
  var monthlyExpenses = getUserInput("month-expenses");
  var monthlyIncome = getUserInput("month-income");
  var netWorth = getUserInput("net-worth");

  var averageReturn = getUserInput("average-return");
  var inflation = getUserInput("inflation");
  var raises = getUserInput("raises");
  var safeWithdrawlRate = getUserInput("safe-withdrawl-rate");

  var addedMonthlyExpense = getUserInput("added-monthly-expense") + monthlyExpenses;
  var addedSingleExpense = getUserInput("added-single-expense")*(-1) + netWorth;
  var addedMonthlyIncome = getUserInput("added-monthly-income") + monthlyIncome;

  var timeToFIInitial = calculateFI(monthlyExpenses, monthlyIncome, netWorth,
                                              averageReturn, inflation, raises, safeWithdrawlRate);

  var timeToFIFinal = calculateFI(addedMonthlyExpense, addedMonthlyIncome, addedSingleExpense,
                                              averageReturn, inflation, raises, safeWithdrawlRate);

  var changeInTimeToFI = timeToFIFinal - timeToFIInitial;

  var divobj = document.getElementById('change-in-time-to-fi-output');
  divobj.style.display='block';
  divobj.innerHTML = "Time Added to FI: " + changeInTimeToFI + " months";
}


function test()
{
  var result = getUserInput("monthspending");
  //display the result
  var divobj = document.getElementById('demo');
  divobj.style.display='block';
  divobj.innerHTML = "Time to FI = "+result;
}
