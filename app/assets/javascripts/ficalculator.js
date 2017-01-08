function getUserInput(input) {
  return parseFloat(document.forms["timetofi_form"].elements[input].value);
};

//Calculation Functions
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
    monthCount += 1;
    if (monthCount > 10000) { break; }
    netWorth = (netWorth * (Math.pow(averageReturn,(1/12))))
                                              + monthlyIncome - monthlyExpenses;
    percentFI = (netWorth / ((12.0 / safeWithdrawlRate) * monthlyExpenses));
  };
  return monthCount;
};

function calculateTimeToDepletion(monthlyExpenses, netWorth, averageReturn, inflation) {
  var monthCount = 0;

  averageReturn = averageReturn/100 + 1;
  inflation = inflation/100 + 1;

  while (netWorth > 0) {
    monthlyExpenses = monthlyExpenses * (Math.pow(inflation,(1/12)));
    netWorth = (netWorth * (Math.pow(averageReturn,(1/12)))) - monthlyExpenses;
    monthCount += 1;
    if (monthCount > 100000) {
      monthCount = NaN;
      break;
    }
  };
  return monthCount;
}
//Display Functions to update html page.
function updateDisplay() {
  displayTimeToFI();
  displayTimeToDepletion();
  displayChangeInFI();
}
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
  divobj.style.display='inline';
  divobj.innerHTML = "Your Time to FI is: " + monthsToYears(timeToFI);
}

function displayTimeToDepletion() {
  var monthlyExpenses = getUserInput("month-expenses");
  var netWorth = getUserInput("net-worth");

  var averageReturn = getUserInput("average-return");
  var inflation = getUserInput("inflation");

  var timeToDepletion = calculateTimeToDepletion(monthlyExpenses, netWorth, averageReturn, inflation);

  var divobj = document.getElementById('time-to-depletion-output');
  divobj.style.display='inline';
  divobj.innerHTML = "Your Time to Depletion is: " + monthsToYears(timeToDepletion);
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
  divobj.style.display='inline';
  divobj.innerHTML = "Time Added to FI: " + monthsToYears(changeInTimeToFI);
}

function monthsToYears(inputMonths) {
  var years = parseInt(inputMonths / 12);
  var months = inputMonths % 12;

  if type()

  if(years == 0){
    if (months == 0) {
      return "You've reached FI!"
    } else if (months == 1) {
      return "1 month"
    } else {
      return months + " months"
    }
  } else if (years == 1) {
    if (months == 0) {
      return "1 year"
    } else if (months == 1){
      return "1 year - 1 month"
    } else {
      return "1 year - " + months + " months"
    }
  } else {
    if (months == 0) {
      return years + " years"
    } else if (months == 1){
      return years + " years - 1 month"
    } else {
      return years + " years - " + months + " months"
    }
  };
}


function test()
{
  var result = monthsToYears(0);
  //display the result
  var divobj = document.getElementById('demo');
  divobj.style.display='block';
  divobj.innerHTML = "Time to FI = "+result;
}
