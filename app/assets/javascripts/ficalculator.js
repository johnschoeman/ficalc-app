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
  displayTimeToDepletion();
  displayTimeToFI();
  updateCharts();
};

function updateCharts(){
  var timeToFIArray = getTimeToFI().timeToFIArray;
  var timeToFIOptions = {
    title: 'Time To FI',
    curveType: 'function',
    legend: { position: 'bottom' },
    colors: ['#4286f4', 'e02828'],
    vAxis: {format: 'currency'},
  };
  displayChart(timeToFIArray, timeToFIOptions, 'chart-time-to-fi');
  var timeToDepletionArray = getTimeToDepletion().timeToDepletionArray;
  var timeToDepletionOptions = {
    title: 'Time To Depletion',
    curveType: 'function',
    legend: { position: 'bottom' },
    colors: ['#4286f4', '#e02828'],
    vAxis: {format: 'currency'}
  };
  if (getTimeToDepletion().timeToDepletion < 1) {
    $('#chart-time-to-depletion').hide();
  } else {
    $('#chart-time-to-depletion').show();
    displayChart(timeToDepletionArray, timeToDepletionOptions, 'chart-time-to-depletion');
  };
  var changeInFIArray = getTimeToFI().changeInFIArray;
  var changeInFIOptions = {
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
  displayChart(changeInFIArray, changeInFIOptions, 'chart-change-in-fi');
}

function displayChart(dataArray, options, chartId) {
  google.charts.load('current', {'packages':['corechart']});
  google.charts.setOnLoadCallback(drawChart);

  function drawChart() {
    var data = google.visualization.arrayToDataTable(dataArray);

    var chart = new google.visualization.LineChart(document.getElementById(chartId));

    chart.draw(data, options);
  };
};

//Calculation Functions
function calculateFI(monthlyExpenses, monthlyIncome,
                             netWorth, averageReturn,
                             inflation, raises, safeWithdrawlRate,
                             changeInMonthlyExpenses, changeInMonthlyIncome, changeInNetWorth) {

  averageReturn = averageReturn/100 + 1;
  inflation = inflation/100 + 1;
  raises = raises/100 + 1;
  safeWithdrawlRate = safeWithdrawlRate/100;

  var monthlyExpenses2 = monthlyExpenses + changeInMonthlyExpenses;
  var monthlyIncome2 = monthlyIncome + changeInMonthlyIncome;
  var netWorth2 = netWorth + changeInNetWorth;

  var monthCount = 0;
  var timeToFI1 = 0;
  var timeToFI2 = 0;
  var changeInFIArray = [['Month', 'NW1', 'FI Number1', 'NW2', 'FI Number2']];
  var nextDataChangeInFI = [monthCount, netWorth, (12 * monthlyExpenses/safeWithdrawlRate),
                  netWorth2, (12 * monthlyExpenses2/safeWithdrawlRate)];
  changeInFIArray.push(nextDataChangeInFI);
  var timeToFIArray = [['Month', 'NW', 'FI Number']];
  var nextDataTimeToFI = [monthCount, netWorth, (12 * monthlyExpenses/safeWithdrawlRate)];
  timeToFIArray.push(nextDataTimeToFI);


  var percentFI1 = (netWorth / (12 * (1 / safeWithdrawlRate) * monthlyExpenses));
  var percentFI2 = (netWorth2 / (12 * (1 / safeWithdrawlRate) * monthlyExpenses2));

  while ((percentFI1 < 1.5) || (percentFI2 < 1.5)) {
    monthlyExpenses = monthlyExpenses * (Math.pow(inflation,(1/12)));
    monthlyExpenses2 = monthlyExpenses2 * (Math.pow(inflation,(1/12)));
    if (monthCount % 12 == 0) {
      monthlyIncome *= raises;
      monthlyIncome2 *= raises;
    };
    monthCount += 1;
    if (monthCount > 1000) { break; }
    netWorth = (netWorth * (Math.pow(averageReturn,(1/12))))
                                              + monthlyIncome - monthlyExpenses;
    netWorth2 = (netWorth2 * (Math.pow(averageReturn,(1/12))))
                                              + monthlyIncome2 - monthlyExpenses2;
    percentFI1 = (netWorth / ((12 / safeWithdrawlRate) * monthlyExpenses));
    percentFI2 = (netWorth2 / ((12 / safeWithdrawlRate) * monthlyExpenses2));

    nextDataChangeInFI = [monthCount, netWorth, (12 * monthlyExpenses / safeWithdrawlRate),
                            netWorth2, (12 * monthlyExpenses2 / safeWithdrawlRate)];
    changeInFIArray.push(nextDataChangeInFI);
    nextDataTimeToFI = [monthCount, netWorth, (12 * monthlyExpenses/safeWithdrawlRate)];
    timeToFIArray.push(nextDataTimeToFI);
    if (percentFI1 >= 1.0 && timeToFI1 == 0) { timeToFI1 = monthCount };
    if (percentFI2 >= 1.0 && timeToFI2 == 0) { timeToFI2 = monthCount };
  };

  return {
    timeToFIArray: timeToFIArray,
    changeInFIArray: changeInFIArray,
    timeToFI1: timeToFI1,
    timeToFI2: timeToFI2
  };
};

function calculateTimeToDepletion(monthlyExpenses, netWorth, averageReturn, inflation) {
  var monthCount = 0;

  averageReturn = averageReturn/100 + 1;
  inflation = inflation/100 + 1;
  var timeToDepletionArray = [['Month','NW','Expenses']];
  var nextData =[monthCount, netWorth, monthlyExpenses];
  timeToDepletionArray.push(nextData);

  var timeToDepletion = 0;
  var dataStop = netWorth * (-0.1);

  while (netWorth >= dataStop) {
    monthlyExpenses = monthlyExpenses * (Math.pow(inflation,(1/12)));
    netWorth = (netWorth * (Math.pow(averageReturn,(1/12)))) - monthlyExpenses;
    monthCount += 1;
    nextData = [monthCount,netWorth,monthlyExpenses];
    timeToDepletionArray.push(nextData);
    if (netWorth <= 0 && timeToDepletion == 0) { timeToDepletion = monthCount - 1};
    if (monthCount > 100000) { break; }
  };
  return {
    timeToDepletionArray: timeToDepletionArray,
    timeToDepletion: timeToDepletion
  };
};

// Get User Input Type Functions
function getUserInput(input) {
  return parseFloat(document.forms["timetofi_form"].elements[input].value);
};

function getTimeToDepletion() {
  var monthlyExpenses = getUserInput("month-expenses");
  var netWorth = getUserInput("net-worth");
  var averageReturn = getUserInput("growth-rate");
  var inflation = getUserInput("inflation");

  var timeToDepletion = calculateTimeToDepletion(monthlyExpenses, netWorth, averageReturn, inflation);
  return timeToDepletion;
};

function displayTimeToDepletion() {
  var timeToDepletion = getTimeToDepletion().timeToDepletion;
  var divobj = document.getElementById('time-to-depletion-output');
  divobj.style.display='inline';
  if (timeToDepletion < 1) {
    divobj.innerHTML = " "
  } else {
    divobj.innerHTML = "Time to Depletion is: " + monthsToYears(timeToDepletion);
  };
}

function getTimeToFI() {
  var monthlyExpenses = getUserInput("month-expenses");
  var monthlyIncome = getUserInput("month-income");
  var netWorth = getUserInput("net-worth");

  var averageReturn = getUserInput("growth-rate");
  var inflation = getUserInput("inflation");
  var raises = getUserInput("raises");
  var safeWithdrawlRate = getUserInput("withdrawl-rate");

  var changeInMonthlyExpenses = getUserInput("change-in-monthly-expenses");
  var changeInMonthlyIncome = getUserInput("change-in-monthly-income");
  var changeInNetWorth = getUserInput("change-in-net-worth");

  var timeToFI = calculateFI(monthlyExpenses, monthlyIncome, netWorth,
                                              averageReturn, inflation, raises, safeWithdrawlRate,
                                              changeInMonthlyExpenses, changeInMonthlyIncome, changeInNetWorth);
  return timeToFI;
}

function displayTimeToFI() {
  var timeToFIInitial = getTimeToFI().timeToFI1;
  var timeToFIFinal = getTimeToFI().timeToFI2;
  var changeInTimeToFI = timeToFIFinal - timeToFIInitial;

  var divobj = document.getElementById('time-to-fi-output');
  divobj.style.display='inline';
  if (timeToFIInitial == 0) {
    divobj.innerHTML = "You've Reached FI!";
  } else {
    divobj.innerHTML = "Time to FI is: " + monthsToYears(timeToFIInitial);
  };

  var divobj = document.getElementById('change-in-time-to-fi-output');
  divobj.style.display='inline';
  if (timeToFIInitial == 0) {
    divobj.innerHTML = " "
  } else {
    divobj.innerHTML = "Change in Time to FI: " + monthsToYears(changeInTimeToFI);
  };
};

// Formating
function monthsToYears(inputMonths) {
  var years = parseInt(inputMonths / 12);
  var months = inputMonths % 12;

  if(years == 0){
    if (months == 0) {
      return "0"
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

// Misc
function test()
{
  var result = getTimeToDepletion().timeToDepletionArray;
  //display the result
  var divobj = document.getElementById('demo');
  divobj.innerHTML = result;
}
