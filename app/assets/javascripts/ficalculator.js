function getUserInput(input) {
  return parseInt(document.forms["timetofiform"].elements[input].value);
};

function calculateFI()
{
    var monthCount = 0;
    var netWorth = getUserInput("networth");
    var monthlySpending = getUserInput("monthspending");
    var monthlyIncome = getUserInput("monthincome");
    var averageReturn = getUserInput("averagereturn")/100 + 1;
    var inflation = getUserInput("inflation")/100 + 1;
    var raises = getUserInput("raises")/100 + 1;

    var percentFI = (netWorth / (300 * monthlySpending));

    while (percentFI < 1.0 ) {
      monthlySpending = monthlySpending * (Math.pow(inflation,(1/12)));
      if (monthCount % 12 == 0) {
        monthlyIncome = monthlyIncome * raises;
      }
      monthCount += 1
      if (monthCount > 10000) { break; }
      netWorth = (netWorth * (Math.pow(averageReturn,(1/12))) ) + monthlyIncome - monthlySpending;
      percentFI = (netWorth / (300 * monthlySpending));
    };
    //display the result
    var divobj = document.getElementById('timetofioutput');
    divobj.style.display='block';
    divobj.innerHTML = "Time to FI = "+ monthCount +" months!";

}

function test()
{
  var result = getUserInput("monthspending");

  var divobj = document.getElementById('demo');
  divobj.style.display='block';
  divobj.innerHTML = "Time to FI = "+result;
}
