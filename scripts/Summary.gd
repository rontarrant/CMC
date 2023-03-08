extends Control

signal previous_pressed
signal reset_all
signal show_final

var summaryID = "summary"


func set_home_price(_price: String):
	var context: String = "Home Price: $"
	$"%summaryHomePrice".set_text(context + _price)


func set_down_payment(_down: String):
	$"%summaryDownPayment".set_text("Down Payment: $" + _down)


func set_interest_rate(_interest: String):
	$"%summaryInterestRate".set_text("Interest Rate: " + _interest.pad_decimals(2) + "%")


func set_mortgage_principal(_principal: String):
	var context: String = "Mortgage principal: $"
	$"%summaryMortgageAmount".set_text(context + _principal)


func set_mortgage_term(_term: String):
	var context: String = "Mortgage Term: "
	$"%summaryMortgageTerm".set_text(context + _term)


func set_amortization_period(_amortization: String):
	var context: String = "Amortization Period: "
	$"%summaryAmortizationPeriod".set_text(context + _amortization)


func set_cmhc_premium(_premium: String):
	var context: String = "CMHC Premium $"
	$"%summaryCMHCPremium".set_text(context + _premium.pad_decimals(2))


func set_monthly_payments(_monthly: String):
	var context: String = "Monthly Payment: $"
	$"%summaryMonthlyPayments".set_text(context + _monthly.pad_decimals(2))


func goto_previous():
	print("Summary - Previous")
	emit_signal("previous_pressed")


func reset():
	print("Summary - Reset")
	$"%summaryHomePrice".set_text("")
	$"%summaryDownPayment".set_text("")
	$"%summaryInterestRate".set_text("")
	$"%summaryMortgageAmount".set_text("")
	$"%summaryMortgageTerm".set_text("")
	$"%summaryAmortizationPeriod".set_text("")
	$"%summaryMonthlyPayments".set_text("")


func reset_all():
	print("Resetting all from Summary.")
	emit_signal("reset_all", "summary")


func display_final_calculations(_price: float, _down: float,
	 _interest: float, _principal: float, _term: float,
	 _amortization: float, _monthly: float, _premium: float):
	set_home_price(str(_price))
	set_down_payment(str(_down))
	set_interest_rate(str(_interest))
	set_mortgage_principal(str(_principal))
	set_mortgage_term(str(_term))
	set_amortization_period(str(_amortization))
	set_monthly_payments(str(_monthly))
	set_cmhc_premium(str(_premium))
	
	if(_premium == 0):
		$"%summaryCMHCPremium".visible = false
	else:
		$"%summaryCMHCPremium".visible = true
		
	print("Summary: all numbers in place.")
	emit_signal("show_final")
