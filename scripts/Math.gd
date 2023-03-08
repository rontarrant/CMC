extends Node

signal home_price_stored
signal down_payment_stored
signal interest_rate_stored
signal principal_stored
signal term_stored
signal amortization_stored
signal display_final

# presets
var annual_compounding_periods: float = 2.0
var exponent: float = 1.0 /12.0

var home_price: float # (from user)
var down_payment: float # (from user)
var interest_rate: float # (from user)
var nominal_rate: float # interest rate translated into a percentage
var effective_rate: float # interest rate (compounding 2 times, not 12, per year)
var monthly_periodic_rate: float # percent interest charged per month
var principal: float # (from user)
var mortgage_term: float # (from user)
var amortization_period: float # in years (from user)
var amortization_months: float # in months
var monthly_payment: float # calculated payment

var high_ratio: bool = false
var mortgage_premium: float


func reset():
	# set all to no value
	home_price = NAN
	down_payment = NAN
	interest_rate = NAN
	principal = NAN
	mortgage_term = NAN
	amortization_period = NAN


func set_high_ratio_flag(_state: bool):
	high_ratio = _state


func calculate_mortgage_premium():
	# CMHC Mortgage Insurance premiums are calculated for all high-ratio mortgages.
	# The interest rate varies based on the size of the down payment.
	# 5% to 9.99% down = 4.0% insurance premium
	# 10% to 14.99% down = 3.1% insurance premium
	# 15% to 19.99% down = 2.8% insurance premium
	# The premium is usually included in the mortgage amount.
	print("Calculating CMHC Mortgage Insurance Premium...")

	# Find out what percent of the home price the down payment is.
	var percent_down = down_payment / home_price
	# Use that percent to decide which premium rate to use.
	if percent_down >= .15 && percent_down < .2:
		mortgage_premium = principal * 0.028
	elif percent_down >= .1 && percent_down < .15:
		mortgage_premium = principal * 0.031
	elif percent_down >= .05 && percent_down < .1:
		mortgage_premium = principal * 0.04
	print("mortgage_premium: " + str(mortgage_premium))


func calculate_cmhc_premium_tax():
	pass
	# This is different depending on which province you're buying in,
	# but in general, the buyer pays provincial tax on the CMHC premium.
	# Information is sparse, but this is what I have as of 2023-02-08:
	# Ontario 8%
	# Quebec 9% (or a sliding scale, not sure which it is yet)
	# Saskcatchewan 6%
	# No other provinces or territories charge tax on the CMHC premium.
	# The result is NOT added into the mortgage; it's one of the closing costs.


func calculate_monthly_payments():
	nominal_rate = interest_rate / 100
	
	print("ENTERING: calculate_monthly_payments()")
	#print("nominal_rate: ", nominal_rate)
	#print("principal: ", principal)
	print("amortization_period: ", amortization_period)
	
	# If it's a high ratio mortgage, add in CMHC mortgage premium.
	if(high_ratio == true):
		if(mortgage_premium > 0): # clean the slate to avoid errors
			mortgage_premium = 0
		calculate_mortgage_premium()
		principal = principal + mortgage_premium
	else:
		mortgage_premium = 0
	
	amortization_months = get_amortization_months() # done
	effective_rate = pow(1.0 + nominal_rate / annual_compounding_periods, 2.0) - 1.0 # done
	
	print("effective rate: ", effective_rate) # not needed
	#print("exponent: ", exponent) # not needed
	
	monthly_periodic_rate = pow(1.0 + effective_rate, exponent) - 1.0 # done
	print("monthly periodic rate:", monthly_periodic_rate) # not needed
	
	monthly_payment = get_monthly_payment() # done
	print("Monthly payment: " + str(monthly_payment))
	
	emit_signal("display_final", home_price, down_payment,
				 interest_rate, principal, mortgage_term,
				 amortization_period, monthly_payment, mortgage_premium)


func get_amortization_months() -> float:
	var months: float = 12.0
	return amortization_period * months
	
	
func get_monthly_payment() -> float:
	print("ENTERING: get_monthly_payment()")
	#print("monthly_periodic_rate: ", monthly_periodic_rate)
	#print("principal: ", principal)
	print("amortization_months: ", amortization_months)
	
	var payment: float = (monthly_periodic_rate * principal) / (1.0 - (1.0 / pow(1.0 + monthly_periodic_rate, amortization_months)))
	
	return payment


func store_value(_label: Object, _number: String):
	print("store_value()")
	
	match _label.text:
		"House Price $":
			home_price = float(_number)
			print("Math.gd - home_price: " + str(home_price))
			emit_signal("home_price_stored") # goes to Main.gd - _on_Math_home_price_stored()
		"Down Payment $":
			down_payment = float(_number)
			print("Math.gd - down_payment: " + str(down_payment))
			emit_signal("down_payment_stored")
		"Interest Rate %":
			interest_rate = float(_number)
			print("Math.gd - interest_rate: " + str(interest_rate))
			emit_signal("interest_rate_stored")
		"Mortgage Term (yrs)":
			mortgage_term = float(_number)
			print("Math.gd - mortgage_term: " + str(mortgage_term))
			emit_signal("term_stored")
		"Amortization Period (yrs)":
			amortization_period = float(_number)
			emit_signal("amortization_stored")
			print("Math.gd - amortization_period: " + str(amortization_period))


# origin: Sanity.gd, signal: price_to_down_okay
func store_principal(_principal: float):
	principal = _principal
	emit_signal("principal_stored", str(down_payment), str(_principal))
