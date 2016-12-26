function getMonthSpending()
{
    var monthSpending=0;
    //Get a reference to the form id="timetofiform"
    var theForm = document.forms["timetofiform"];
    //Get a reference to the select id="MonthSpending"
    var monthSpendingInput = theForm.elements["monthspending"];
    monthSpending = monthSpendingInput.value;
    return parseInt(monthSpending);
}

function getMonthIncome()
{
    var monthIncome=0;
    var theForm = document.forms["timetofiform"];
    var monthIncomeInput = theForm.elements["monthincome"];
    monthIncome = monthIncomeInput.value;
    return parseInt(monthIncome);
}

function getNetWorth()
{
    var netWorth=0;
    var theForm = document.forms["timetofiform"];
    var netWorthInput = theForm.elements["networth"];
    netWorth = netWorthInput.value;
    return parseInt(netWorth);
}

function getAverageReturn()
{
    var averageReturn=0;
    var theForm = document.forms["timetofiform"];
     var averageReturnInput = theForm.elements["averagereturn"];
    averageReturn = averageReturnInput.value;
    return parseInt(averageReturn);
}

function getInflation()
{
    var inflation=0;
    var theForm = document.forms["timetofiform"];
    var inflationInput = theForm.elements["inflation"];
    inflation = inflationInput.value;
    return parseInt(inflation);
}

function getRaises()
{
    var raises=0;
    var theForm = document.forms["timetofiform"];
    var raisesInput = theForm.elements["raises"];
    raises = raisesInput.value;
    return parseInt(raises);
}


function calculateFI()
{
    var monthCount = 0;
    var netWorth = getNetWorth();
    var monthlySpending = getMonthSpending();
    var monthlyIncome = getMonthIncome();
    var averageReturn = getAverageReturn()/100 + 1;
    var inflation = getInflation()/100 + 1;
    var raises = getRaises()/100 + 1;

    var percentFI = (netWorth / (300 * monthlySpending));

    /*while (percentFI < 1.0 ) {
      monthlySpending *= (inflation**(1/12));
      if (monthCount % 12 == 0) {
        monthlyIncome *= raises;
      }
      monthCount += 1
      if (monthCount > 10000) { break; }
      netWorth = (netWorth * (averageReturn ** (1/12)) ) + monthlyIncome - monthlySpending;
      percentFI = (netWorth / (300 * monthlySpending));
    };*/
    //display the result
    var divobj = document.getElementById('timetofioutput');
    divobj.style.display='block';
    divobj.innerHTML = "Time to FI = "+ monthCount +" months!";

}

function test()
{
  var result = getInflation();

  var divobj = document.getElementById('demo');
  divobj.style.display='block';
  divobj.innerHTML = "Time to FI = "+result;
}
