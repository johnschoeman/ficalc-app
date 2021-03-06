document.addEventListener('DOMContentLoaded', function() {
  populateForm();
  updateDisplay();

  const timeToFIInputs = document.querySelectorAll('.time-to-fi-input');
  Array.from(timeToFIInputs).forEach(el => {
    el.addEventListener('change', updateDisplay);
  });
});

//Display Functions to update html page.
function updateDisplay() {
  displayTimeToDepletion();
  displaySavingsRate();
  displayMonthlyPortfolioIncome();
  displayTimeToFI();
  updateCharts();
}

function populateForm() {
  var monthlyIncome = Math.ceil((Math.random() * 7500) / 100) * 100 + 500;
  var monthlyExpenses = Math.ceil((Math.random() * 5800) / 50) * 50 + 200;
  var netWorth = Math.ceil((Math.random() * 250000) / 1000) * 1000;

  var changeInExpenses = Math.ceil((Math.random() * 1000) / 50) * 50 - 500;
  var changeInIncome = Math.ceil((Math.random() * 2000) / 50) * 50 - 1000;
  var changeInNetWorth =
    Math.ceil((Math.random() * 200000) / 1000) * 1000 - 100000;

  document.getElementById('month-expenses').value = monthlyExpenses;
  document.getElementById('month-income').value = monthlyIncome;
  document.getElementById('net-worth').value = netWorth;

  if (flipCoin()) {
    document.getElementById(
      'change-in-monthly-expenses',
    ).value = changeInExpenses;
  }
  if (flipCoin()) {
    document.getElementById('change-in-monthly-income').value = changeInIncome;
  }
  if (flipCoin()) {
    document.getElementById('change-in-net-worth').value = changeInNetWorth;
  }
}

function flipCoin() {
  var coin = Math.random();
  if (coin < 0.5) {
    return true;
  } else {
    return false;
  }
}

function updateCharts() {
  // var timeToFIArray = getTimeToFI().timeToFIArray;
  // var timeToFIOptions = {
  //   title: 'Time To FI',
  //   curveType: 'function',
  //   legend: { position: 'bottom' },
  //   colors: ['#4286f4', 'e02828'],
  //   vAxis: {format: 'currency'},
  //   hAxis: {
  //           format: 'MMM yyyy',
  //           gridlines: {count: 8}
  //         },
  // };
  // displayChart(timeToFIArray, timeToFIOptions, 'chart-time-to-fi');
  // var timeToDepletionArray = getTimeToDepletion().timeToDepletionArray;
  // var timeToDepletionOptions = {
  //   title: 'Time To Depletion',
  //   curveType: 'function',
  //   legend: { position: 'bottom' },
  //   colors: ['#4286f4', '#e02828'],
  //   vAxis: {format: 'currency'}
  // };
  // if (getTimeToDepletion().timeToDepletion < 1) {
  //   $('#chart-time-to-depletion').hide();
  // } else {
  //   $('#chart-time-to-depletion').show();
  //   displayChart(timeToDepletionArray, timeToDepletionOptions, 'chart-time-to-depletion');
  // };
  var changeInFIArray = getTimeToFI().changeInFIArray;
  var changeInFIOptions = {
    title: 'Time To FI',
    curveType: 'function',
    legend: {position: 'bottom'},
    colors: ['#4286f4', '#e02828', '#99bffc', '#ef8383'],
    series: {
      2: {lineDashStyle: [12, 3]},
      3: {lineDashStyle: [12, 3]},
    },
    vAxis: {format: 'currency'},
    titleTextStyle: {
      color: '#496117', // any HTML string color ('red', '#cc00cc')
      fontName: 'Verdana', // i.e. 'Times New Roman'
      fontSize: 18, // 12, 18 whatever you want (don't specify px)
      bold: false, // true or false
      italic: false, // true of false
    },
  };
  displayChart(changeInFIArray, changeInFIOptions, 'chart-change-in-fi');
}

function displayChart(dataArray, options, chartId) {
  google.charts.load('current', {packages: ['corechart']});
  google.charts.setOnLoadCallback(drawChart);

  function drawChart() {
    var data = google.visualization.arrayToDataTable(dataArray);

    var chart = new google.visualization.LineChart(
      document.getElementById(chartId),
    );

    chart.draw(data, options);
  }
}

//Calculation Functions
function calculateFI(
  monthlyExpenses,
  monthlyIncome,
  netWorth,
  averageReturn,
  inflation,
  raises,
  safeWithdrawlRate,
  changeInMonthlyExpenses,
  changeInMonthlyIncome,
  changeInNetWorth,
) {
  averageReturn = Math.pow(averageReturn / 100 + 1, 1 / 12);
  inflation = inflation / 100 + 1;
  raises = raises / 100 + 1;
  safeWithdrawlRate = safeWithdrawlRate / 100;

  var monthlyExpenses2 = monthlyExpenses + changeInMonthlyExpenses;
  var monthlyIncome2 = monthlyIncome + changeInMonthlyIncome;
  var netWorth2 = netWorth + changeInNetWorth;

  var monthCount = 0;
  var timeToFI1 = 0;
  var timeToFI2 = 0;
  var changeInFIArray = [
    [
      'Month',
      'Net Worth - Current ($)',
      'FI Number - Current ($)',
      'Net Worth - Changed ($)',
      'FI Number - Changed ($)',
    ],
  ];
  var nextDataChangeInFI = [
    new Date(
      moment()
        .add(monthCount, 'month')
        .utc(),
    ),
    netWorth,
    (12 * monthlyExpenses) / safeWithdrawlRate,
    netWorth2,
    (12 * monthlyExpenses2) / safeWithdrawlRate,
  ];
  changeInFIArray.push(nextDataChangeInFI);
  // var timeToFIArray = [['Month', 'Net Worth ($)', 'FI Number ($)']];
  // var nextDataTimeToFI = [new Date(moment().add(monthCount, 'month').utc()),
  //                         netWorth, (12 * monthlyExpenses/safeWithdrawlRate)];
  // timeToFIArray.push(nextDataTimeToFI);

  var percentFI1 = netWorth / (12 * (1 / safeWithdrawlRate) * monthlyExpenses);
  var percentFI2 =
    netWorth2 / (12 * (1 / safeWithdrawlRate) * monthlyExpenses2);

  while (percentFI1 < 1.5 || percentFI2 < 1.5) {
    monthlyExpenses = monthlyExpenses * Math.pow(inflation, 1 / 12);
    monthlyExpenses2 = monthlyExpenses2 * Math.pow(inflation, 1 / 12);
    if (monthCount % 12 == 0) {
      monthlyIncome *= raises;
      monthlyIncome2 *= raises;
    }
    monthCount += 1;
    if (monthCount > 1000) {
      timeToFI1 = -1;
      timeToFI2 = -1;
      break;
    }
    netWorth = netWorth * averageReturn + monthlyIncome - monthlyExpenses;
    netWorth2 = netWorth2 * averageReturn + monthlyIncome2 - monthlyExpenses2;
    percentFI1 = netWorth / ((12 / safeWithdrawlRate) * monthlyExpenses);
    percentFI2 = netWorth2 / ((12 / safeWithdrawlRate) * monthlyExpenses2);

    nextDataChangeInFI = [
      new Date(
        moment()
          .add(monthCount, 'month')
          .utc(),
      ),
      netWorth,
      (12 * monthlyExpenses) / safeWithdrawlRate,
      netWorth2,
      (12 * monthlyExpenses2) / safeWithdrawlRate,
    ];

    changeInFIArray.push(nextDataChangeInFI);
    //
    // nextDataTimeToFI = [new Date(moment().add(monthCount, 'month').utc()), netWorth, (12 * monthlyExpenses/safeWithdrawlRate)];
    //
    // timeToFIArray.push(nextDataTimeToFI);

    if (percentFI1 >= 1.0 && timeToFI1 == 0) {
      timeToFI1 = monthCount;
    }
    if (percentFI2 >= 1.0 && timeToFI2 == 0) {
      timeToFI2 = monthCount;
    }
  }

  return {
    // timeToFIArray: timeToFIArray,
    changeInFIArray: changeInFIArray,
    timeToFI1: timeToFI1,
    timeToFI2: timeToFI2,
  };
}

function calculateTimeToDepletion(
  monthlyExpenses,
  netWorth,
  averageReturn,
  inflation,
) {
  var monthCount = 0;

  averageReturn = averageReturn / 100 + 1;
  inflation = inflation / 100 + 1;

  var timeToDepletionArray = [['Month', 'Net Worth ($)', 'Expenses ($)']];
  var nextData = [
    new Date(
      moment()
        .add(monthCount, 'month')
        .utc(),
    ),
    netWorth,
    monthlyExpenses,
  ];
  timeToDepletionArray.push(nextData);

  var timeToDepletion = 0;
  var dataStop = netWorth * -0.1;

  while (netWorth >= dataStop) {
    monthlyExpenses = monthlyExpenses * Math.pow(inflation, 1 / 12);
    netWorth = netWorth * Math.pow(averageReturn, 1 / 12) - monthlyExpenses;
    monthCount += 1;
    nextData = [
      new Date(
        moment()
          .add(monthCount, 'month')
          .utc(),
      ),
      netWorth,
      monthlyExpenses,
    ];
    timeToDepletionArray.push(nextData);
    if (netWorth <= 0 && timeToDepletion == 0) {
      timeToDepletion = monthCount - 1;
    }
    if (monthCount > 100000) {
      break;
    }
  }
  return {
    timeToDepletionArray: timeToDepletionArray,
    timeToDepletion: timeToDepletion,
  };
}

// Get User Input Functions
function getUserInput(input) {
  return parseFloat(document.forms['timetofi_form'].elements[input].value);
}

function getTimeToDepletion() {
  var monthlyExpenses = getUserInput('month-expenses');
  var netWorth = getUserInput('net-worth');
  var averageReturn = getUserInput('growth-rate');
  var inflation = getUserInput('inflation');

  var timeToDepletion = calculateTimeToDepletion(
    monthlyExpenses,
    netWorth,
    averageReturn,
    inflation,
  );
  return timeToDepletion;
}

function displayTimeToDepletion() {
  var timeToDepletion = getTimeToDepletion().timeToDepletion;
  var divobj = document.getElementById('time-to-depletion-output');
  divobj.style.display = 'inline';
  if (timeToDepletion < 1) {
    divobj.innerHTML = ' ';
  } else {
    divobj.innerHTML = 'Time to Depletion: ' + monthsToYears(timeToDepletion);
  }
}

function displaySavingsRate() {
  var monthlyIncome = getUserInput('month-income');
  var monthlyExpenses = getUserInput('month-expenses');
  var savingsRate = Math.round(
    (1.0 - parseFloat(monthlyExpenses) / monthlyIncome) * 100,
  );

  var divobj = document.getElementById('savings-rate-output');
  divobj.innerHTML = 'Savings Rate: ' + savingsRate + '%';
}

function displayMonthlyPortfolioIncome() {
  var netWorth = getUserInput('net-worth');
  var withdrawlRate = getUserInput('withdrawl-rate');
  var monthlyPortfolioIncome = parseFloat(
    Math.round((netWorth * withdrawlRate * 100) / (12 * 100.0)) / 100,
  ).toFixed(2);

  var divobj = document.getElementById('monthly-portfolio-income-output');
  if (monthlyPortfolioIncome < 1) {
    divobj.innerHTML = ' ';
  } else {
    divobj.innerHTML = 'Monthly Portfolio Income: $' + monthlyPortfolioIncome;
  }
}

function getTimeToFI() {
  var monthlyExpenses = getUserInput('month-expenses');
  var monthlyIncome = getUserInput('month-income');
  var netWorth = getUserInput('net-worth');

  var averageReturn = getUserInput('growth-rate');
  var inflation = getUserInput('inflation');
  var raises = getUserInput('raises');
  var safeWithdrawlRate = getUserInput('withdrawl-rate');

  var changeInMonthlyExpenses = getUserInput('change-in-monthly-expenses');
  var changeInMonthlyIncome = getUserInput('change-in-monthly-income');
  var changeInNetWorth = getUserInput('change-in-net-worth');

  var timeToFI = calculateFI(
    monthlyExpenses,
    monthlyIncome,
    netWorth,
    averageReturn,
    inflation,
    raises,
    safeWithdrawlRate,
    changeInMonthlyExpenses,
    changeInMonthlyIncome,
    changeInNetWorth,
  );
  return timeToFI;
}

function displayTimeToFI() {
  var timeToFIInitial = getTimeToFI().timeToFI1;
  var timeToFIFinal = getTimeToFI().timeToFI2;
  var changeInTimeToFI = timeToFIFinal - timeToFIInitial;

  var divobj = document.getElementById('time-to-fi-output');
  divobj.style.display = 'inline';
  if (timeToFIInitial == 0) {
    divobj.innerHTML = "You've Reached FI!";
  } else if (timeToFIInitial == -1) {
    divobj.innerHTML = 'FI Cannot Be Reached.';
  } else {
    divobj.innerHTML = monthsToYears(timeToFIInitial);
  }

  var divobj = document.getElementById('change-in-time-to-fi-output');
  divobj.style.display = 'inline';
  if (timeToFIInitial == 0) {
    divobj.innerHTML = ' ';
  } else {
    divobj.innerHTML = monthsToYears(changeInTimeToFI);
  }
}

// Formating
function monthsToYears(inputMonths) {
  var years = parseInt(inputMonths / 12);
  var months = inputMonths % 12;

  if (years == 0) {
    if (months == 0) {
      return '0 months';
    } else if (months == 1) {
      return '1 month';
    } else {
      return months + ' months';
    }
  } else if (years == 1) {
    if (months == 0) {
      return '1 year';
    } else if (months == 1) {
      return '1 year and 1 month';
    } else {
      return '1 year and ' + months + ' months';
    }
  } else {
    if (months == 0) {
      return years + ' years';
    } else if (months == 1) {
      return years + ' years and 1 month';
    } else {
      return years + ' years and ' + months + ' months';
    }
  }
}

// Misc
function test() {
  var day1 = new Date(
    moment()
      .add(1, 'month')
      .utc(),
  );
  var result = getTimeToDepletion().timeToDepletionArray;
  //display the result
  var divobj = document.getElementById('demo');
  divobj.innerHTML = day1;
}
