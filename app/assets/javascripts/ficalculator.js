$(document).ready(function() {
  updateDisplay();
  $(document).keydown(function(key) {
      switch(parseInt(key.which,10)) {
    // Left arrow key pressed
    case 37:
      $('#mario').animate({left: "-=10px"}, 'fast');
      break;
    // Up Arrow Pressed
    case 38:
      // Put our code here
      $('#mario').animate({top: "-=10px"}, 'fast');
      break;
    // Right Arrow Pressed
    case 39:
      // Put our code here
      $('#mario').animate({left: "+=10px"}, 'fast');
      break;
    // Down Arrow Pressed
    case 40:
      // Put our code here
      $('#mario').animate({top: "+=10px"}, 'fast');
      break;
    };
  });
});

//Display Functions to update html page.
function updateDisplay() {
  displayTimeToFI();
  displayTimeToDepletion();
  displayChangeInFI();
  var timeToFIArray = getTimeToFI();
  displayTimeToFIChart(timeToFIArray);
  var timeToDepletionArray = getTimeToDepletion();
  displayTimeToDepletionChart(timeToDepletionArray);
  var changeInFIArray = getChangeInFI();
  displayChangeInFIChart(changeInFIArray);
};

function getUserInput(input) {
  return parseFloat(document.forms["timetofi_form"].elements[input].value);
};

//Calculation Functions
function calculateFI(monthlyExpenses, monthlyIncome, netWorth, averageReturn,
                                                            inflation, raises, safeWithdrawlRate) {
  averageReturn = averageReturn/100 + 1;
  inflation = inflation/100 + 1;
  raises = raises/100 + 1;
  safeWithdrawlRate = safeWithdrawlRate/100;

  var monthCount = 0;
  var timeToFIArray = [['Month', 'NW', 'FI Number']];
  var nextData = [monthCount, netWorth, (12 * monthlyExpenses/safeWithdrawlRate)];
  timeToFIArray.push(nextData);

  var percentFI = (netWorth / (12 * ( 1 / safeWithdrawlRate) * monthlyExpenses));

  while (percentFI < 1.0 ) {
    monthlyExpenses = monthlyExpenses * (Math.pow(inflation,(1/12)));
    if (monthCount % 12 == 0) { monthlyIncome *= raises; }
    monthCount += 1;
    if (monthCount > 10000) { break; }
    netWorth = (netWorth * (Math.pow(averageReturn,(1/12))))
                                              + monthlyIncome - monthlyExpenses;
    percentFI = (netWorth / ((12.0 / safeWithdrawlRate) * monthlyExpenses));
    nextData = [monthCount, netWorth, (12 * monthlyExpenses / safeWithdrawlRate)];
    timeToFIArray.push(nextData);
  };
  return timeToFIArray;
};

function calculateTimeToDepletion(monthlyExpenses, netWorth, averageReturn, inflation) {
  var monthCount = 0;

  averageReturn = averageReturn/100 + 1;
  inflation = inflation/100 + 1;
  var timeToDepletionArray = [['Month','NW','Expenses']];
  var nextData =[monthCount, netWorth, monthlyExpenses];

  while (netWorth > 0) {
    monthlyExpenses = monthlyExpenses * (Math.pow(inflation,(1/12)));
    netWorth = (netWorth * (Math.pow(averageReturn,(1/12)))) - monthlyExpenses;
    monthCount += 1;
    nextData = [monthCount,netWorth,monthlyExpenses];
    timeToDepletionArray.push(nextData);
    if (monthCount > 100000) { break; }
  };
  return timeToDepletionArray;
};

function calculateChangeInFI(monthlyExpenses, monthlyIncome,
                             netWorth, averageReturn,
                             inflation, raises, safeWithdrawlRate,
                             addedMonthlyExpense, addedMonthlyIncome, addedSingleExpense) {

  averageReturn = averageReturn/100 + 1;
  inflation = inflation/100 + 1;
  raises = raises/100 + 1;
  safeWithdrawlRate = safeWithdrawlRate/100;

  var monthlyExpenses2 = monthlyExpenses + addedMonthlyExpense;
  var monthlyIncome2 = monthlyIncome + addedMonthlyIncome;
  var netWorth2 = netWorth - addedSingleExpense;

  var monthCount = 0;
  var changeInFIArray = [['Month', 'NW1', 'FI Number1', 'NW2', 'FI Number2']];
  var nextData = [monthCount, netWorth, (12 * monthlyExpenses/safeWithdrawlRate),
                  netWorth2, (12 * monthlyExpenses2/safeWithdrawlRate)];
  changeInFIArray.push(nextData);

  var percentFI1 = (netWorth / (12 * (1 / safeWithdrawlRate) * monthlyExpenses));
  var percentFI2 = (netWorth2 / (12 * (1 / safeWithdrawlRate) * monthlyExpenses2));

  while ((percentFI1 < 1.0) || (percentFI2 < 1.0)) {
    monthlyExpenses = monthlyExpenses * (Math.pow(inflation,(1/12)));
    monthlyExpenses2 = monthlyExpenses2 * (Math.pow(inflation,(1/12)));
    if (monthCount % 12 == 0) {
      monthlyIncome *= raises;
      monthlyIncome2 *= raises;
    };
    monthCount += 1;
    if (monthCount > 10000) { break; }
    netWorth = (netWorth * (Math.pow(averageReturn,(1/12))))
                                              + monthlyIncome - monthlyExpenses;
    netWorth2 = (netWorth2 * (Math.pow(averageReturn,(1/12))))
                                              + monthlyIncome2 - monthlyExpenses2;
    percentFI1 = (netWorth / ((12 / safeWithdrawlRate) * monthlyExpenses));
    percentFI2 = (netWorth2 / ((12 / safeWithdrawlRate) * monthlyExpenses2));

    nextData = [monthCount, netWorth, (12 * monthlyExpenses / safeWithdrawlRate),
                            netWorth2, (12 * monthlyExpenses2 / safeWithdrawlRate)];
    changeInFIArray.push(nextData);
  };
  return changeInFIArray;
};

function getTimeToFI() {
  var monthlyExpenses = getUserInput("month-expenses");
  var monthlyIncome = getUserInput("month-income");
  var netWorth = getUserInput("net-worth");

  var averageReturn = getUserInput("average-return");
  var inflation = getUserInput("inflation");
  var raises = getUserInput("raises");
  var safeWithdrawlRate = getUserInput("safe-withdrawl-rate");

  var timeToFI = calculateFI(monthlyExpenses, monthlyIncome, netWorth,
                                              averageReturn, inflation, raises, safeWithdrawlRate);
  return timeToFI;
}

function displayTimeToFI() {
  var timeToFI = getTimeToFI();
  var divobj = document.getElementById('time-to-fi-output');
  divobj.style.display='inline';
  divobj.innerHTML = "Your Time to FI is: " + monthsToYears(timeToFI[timeToFI.length-1][0]);
}

function getTimeToDepletion() {
  var monthlyExpenses = getUserInput("month-expenses");
  var netWorth = getUserInput("net-worth");

  var averageReturn = getUserInput("average-return");
  var inflation = getUserInput("inflation");

  var timeToDepletion = calculateTimeToDepletion(monthlyExpenses, netWorth, averageReturn, inflation);
  return timeToDepletion;
};

function displayTimeToDepletion() {
  var timeToDepletion = getTimeToDepletion();
  var divobj = document.getElementById('time-to-depletion-output');
  divobj.style.display='inline';
  divobj.innerHTML = "Your Time to Depletion is: " + monthsToYears(timeToDepletion[timeToDepletion.length-1][0]);
}

function getChangeInFI() {
  var monthlyExpenses = getUserInput("month-expenses");
  var monthlyIncome = getUserInput("month-income");
  var netWorth = getUserInput("net-worth");

  var averageReturn = getUserInput("average-return");
  var inflation = getUserInput("inflation");
  var raises = getUserInput("raises");
  var safeWithdrawlRate = getUserInput("safe-withdrawl-rate");

  var addedMonthlyExpense = getUserInput("added-monthly-expenses");
  var addedMonthyIncome = getUserInput("added-monthly-income");
  var addedSingleExpense = getUserInput("added-single-expense");

  var changeInFI = calculateChangeInFI(monthlyExpenses, monthlyIncome, netWorth,
                                              averageReturn, inflation, raises, safeWithdrawlRate,
                                              addedMonthlyExpense, addedMonthyIncome, addedSingleExpense);
  return changeInFI;
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

  var changeInTimeToFI = timeToFIFinal[timeToFIFinal.length-1][0] - timeToFIInitial[timeToFIInitial .length-1][0];

  var divobj = document.getElementById('change-in-time-to-fi-output');
  divobj.style.display='inline';
  divobj.innerHTML = "Time Added to FI: " + monthsToYears(changeInTimeToFI);
}

function displayTimeToFIChart(dataArray) {
  google.charts.load('current', {'packages':['corechart']});
  google.charts.setOnLoadCallback(drawChart);

  function drawChart() {
    var data = google.visualization.arrayToDataTable(dataArray);

    var options = {
      title: 'Time To FI',
      curveType: 'function',
      legend: { position: 'bottom' },
      colors: ['#4286f4', 'e02828'],
      vAxis: {format: 'currency'},
      lineWidth: 3
    };

    var chart = new google.visualization.LineChart(document.getElementById('chart'));

    chart.draw(data, options);
  }
}

function displayTimeToDepletionChart(dataArray) {
  google.charts.load('current', {'packages':['corechart']});
  google.charts.setOnLoadCallback(drawChart);

  function drawChart() {
    var data = google.visualization.arrayToDataTable(dataArray);

    var options = {
      title: 'Time To Depletion',
      curveType: 'function',
      legend: { position: 'bottom' },
      colors: ['#4286f4', '#e02828'],
      vAxis: {format: 'currency'}
    };

    var chart = new google.visualization.LineChart(document.getElementById('chart-time-to-depletion'));

    chart.draw(data, options);
  }
}

function displayChangeInFIChart(dataArray) {
  google.charts.load('current', {'packages':['corechart']});
  google.charts.setOnLoadCallback(drawChart);

  function drawChart() {
    var data = google.visualization.arrayToDataTable(dataArray);

    var options = {
      title: 'Change in FI',
      curveType: 'function',
      legend: { position: 'bottom' },
      colors: ['#4286f4', '#e02828', '#99bffc', '#ef8383'],
      series: {
        2: {lineDashStyle: [12,3]},
        3: {lineDashStyle: [12,3]},
      },
      vAxis: {format: 'currency'}
    };

    var chart = new google.visualization.LineChart(document.getElementById('chart-change-in-fi'));

    chart.draw(data, options);
  }
}

function monthsToYears(inputMonths) {
  var years = parseInt(inputMonths / 12);
  var months = inputMonths % 12;

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
      return "1 year and 1 month"
    } else {
      return "1 year and " + months + " months"
    }
  } else {
    if (months == 0) {
      return years + " years"
    } else if (months == 1){
      return years + " years and 1 month"
    } else {
      return years + " years and " + months + " months"
    }
  };
}


function test()
{
  var result = new Date()
  //display the result
  var divobj = document.getElementById('demo');
  divobj.innerHTML = result;
}
