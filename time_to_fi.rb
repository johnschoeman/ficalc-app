class FiCalculator
  GROWTH_RATE = 0.07
  INFLATION_RATE = 0.02
  RAISE_RATE = 0.05
  WITHDRAW_RATE = 0.04

  def initialize(net_worth:, expenses:, income:)
    @net_worth = net_worth
    @expenses = expenses
    @income = income
    @calc_percent_fi = 0.0
    @calc_income = income
    @calc_expenses = expenses
    @calc_net_worth = net_worth
  end

  def time_to_fi
    @months_to_fi = 0
    @calc_percent_fi = fi_percent(@calc_net_worth, @calc_expenses, WITHDRAW_RATE)
    while @calc_percent_fi < 1.0
      @months_to_fi += 1

      @calc_expenses = apply_rate(@calc_expenses, (INFLATION_RATE / 12))

      if (@months_to_fi % 12).zero?
        @calc_income = apply_rate(@calc_income, RAISE_RATE)
      end

      new_net_worth = (@calc_net_worth + @calc_income - @calc_expenses)
      @calc_net_worth = apply_rate(new_net_worth, (GROWTH_RATE / 12))

      @calc_percent_fi = fi_percent(@calc_net_worth, @calc_expenses, WITHDRAW_RATE)
      if @months_to_fi >= 1200
        break
      end
    end

    @months_to_fi
  end

  def fi_percent(net_worth, expenses, withdraw_rate)
    net_worth/ ((12 / withdraw_rate) * expenses)
  end

  def apply_rate(value, rate)
    value * (1 + rate)
  end

  def print_data_point
    time_to_fi
    <<~FI_DATA
      ----
      months:         #{@months_to_fi}
      percent_fi:     #{@calc_percent_fi}
      calc_income:    #{@calc_income}
      calc_expenses:  #{@calc_expenses}
      calc_net_worth: #{@calc_net_worth}
    FI_DATA
  end

  def print_result
    time_to_fi
    <<~FI_DATA
      ----
      net_worth:      #{@net_worth}
      expenses:       #{@expenses}
      income:         #{@income}
      percent_fi:     #{fi_percent(@net_worth, @expenses, WITHDRAW_RATE)}

      safe_withdraw:  #{@net_worth / 300.0}

      months_to_fi:   #{@months_to_fi}
      years_to_fi:    #{@months_to_fi / 12.0}
    FI_DATA
  end

end

net_worth, expenses, income = ARGV.map(&:to_f)

calc = FiCalculator.new(net_worth: net_worth, expenses: expenses, income: income)

print calc.print_result
