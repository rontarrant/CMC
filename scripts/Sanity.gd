extends Node

# Cost scene sanity flags
var home_price_ok: bool = false
var interest_rate_ok: bool = false
var down_payment_ok: bool = false
var price_to_down_ok: bool = false
var high_ratio: bool = false # true if down payment is less than 20%

# Mortgage scene sanity flags
var mortgage_principal_ok: bool = false
var mortgage_term_ok: bool = false
var amortization_period_ok: bool = false


# error handling
signal error_condition
signal set_high_ratio_flag

enum ErrorCodes {
	HOME_PRICE_ZERO,
	HOME_PRICE_BLANK,
	HOME_PRICE_LOW,
	DOWN_PAYMENT_ZERO,
	DOWN_PAYMENT_BLANK,
	DOWN_PAYMENT_TOO_HIGH,
	DOWN_PAYMENT_TOO_LOW,
	INTEREST_RATE_ZERO,
	INTEREST_RATE_BLANK,
	INTEREST_RATE_TOO_HIGH,
	DOWN_PAYMENT_HIGH,
	DOWN_PAYMENT_LOW,
	COST_FIELD_EMPTY,
	TERM_ZERO,
	TERM_BLANK,
	TERM_SHORT,
	TERM_LONG,
	AMORTIZATION_ZERO,
	AMORTIZATION_BLANK,
	AMORTIZATION_LOW,
	AMORTIZATION_HIGH,
	AMORTIZATION_TO_DOWN_LONG,
	MORTGAGE_FIELD_EMPTY
}

var error_code: int

# sanity check signals - fired when things go right
signal home_price_okay
signal down_payment_okay
signal interest_rate_okay
signal price_to_down_okay
signal mortgage_term_okay
signal amortization_period_okay
signal mortgage_fields_okay


func reset():
	home_price_ok = false
	interest_rate_ok = false
	down_payment_ok = false
	mortgage_principal_ok = false
	mortgage_term_ok = false
	amortization_period_ok = false
	high_ratio = false
	

# NOTE: Incoming numbers must be strings.
func check_home_price(_home_price: String) -> bool:
	# not blank
	# non-zero
	# minimum: $3000.00
	var price: float

	# if we're reentering a field where a number has already been checked,
	# flip the flag so we can check the new, edited number.
	if(home_price_ok == true):
		home_price_ok = false

	match _home_price:
		"":
			print("Sanity: No Home Price entered.")
			error_code = ErrorCodes.HOME_PRICE_BLANK
			home_price_ok = false
		_:
			# convert to float before the next test
			price = float(_home_price)
			
			if(price == 0):
				print("Sanity: Zero asking price")
				error_code = ErrorCodes.HOME_PRICE_ZERO
				home_price_ok = false
			elif(price < 3000.00):
				print("Sanity: Home Price too low.")
				error_code = ErrorCodes.HOME_PRICE_LOW
				home_price_ok = false
			else:
				home_price_ok = true
	
	return home_price_ok


func check_down_payment(_down_payment: String) -> bool:
	# not blank
	# non-zero
	var down_payment

	# if we're reentering a field where a number has already been checked,
	# flip the flag so we can check the new, edited number.
	if(down_payment_ok == true):
		down_payment_ok = false

	match _down_payment:
		"":
			print("Sanity: No Down Payment entered.")
			error_code = ErrorCodes.DOWN_PAYMENT_BLANK
			down_payment_ok = false
		_:
			down_payment = float(_down_payment)
			
			if(down_payment == 0):
				print("Sanity: Zero down")
				error_code = ErrorCodes.DOWN_PAYMENT_ZERO
				down_payment_ok = false
			else:
				down_payment_ok = true
			
	return down_payment_ok


# Somewhere in here, we need to determine the percentage of the down payment
# and set a local flag accordingly.
func compare_price_to_down(_home_price, _down_payment):
	var home_price: float
	var down_payment: float
	
	if(price_to_down_ok == true):
		price_to_down_ok = false
	
	if(high_ratio == true):
		high_ratio = false
		print("Turning high_ratio FLAG OFF")
		emit_signal("set_high_ratio_flag", false)

	home_price = float(_home_price.text)
	down_payment = float(_down_payment.text)

	if(home_price < down_payment): # less than home price
		price_to_down_ok = false # defaults to false if test doesn't pass
		error_code = ErrorCodes.DOWN_PAYMENT_HIGH
		emit_signal("error_condition", error_code)
	elif(down_payment < (home_price * .05)): # minimum: 5% of home price
		print("down_payment is less than 5% " + str(home_price * .05) + " of home price: " + str(home_price - down_payment))
		price_to_down_ok = false
		error_code = ErrorCodes.DOWN_PAYMENT_LOW
		emit_signal("error_condition", error_code)
	elif(down_payment < (home_price * .20)):
		print("down_payment is less than 20% " + str(home_price * .2) + " of home_price: " + str(home_price - down_payment))
		price_to_down_ok = true
		high_ratio = true
		print("Turning high_ratio FLAG ON")
		emit_signal("set_high_ratio_flag", true)
		print("\bHigh ratio mortgage. Flag set.")
		emit_signal("price_to_down_okay", home_price - down_payment)
	else:
		print("The down payment is less than the home price.")
		price_to_down_ok = true
		# set price/down ratio variable
		emit_signal("price_to_down_okay", home_price - down_payment)


func check_interest_rate(_interest_rate: String) -> bool:
	var interest_rate

	# if we're reentering a field where a number has already been checked,
	# flip the flag so we can check the new, edited number.
	if(interest_rate_ok == true):
		interest_rate_ok = false

	match _interest_rate:
		"":
			print("Sanity: No Interest Rate entered.")
			error_code = ErrorCodes.INTEREST_RATE_BLANK
			interest_rate_ok = false
		_:
			interest_rate = float(_interest_rate)
			
			if(interest_rate == 0):
				print("Sanity: Zero Interest")
				error_code = ErrorCodes.INTEREST_RATE_ZERO
				interest_rate_ok = false
			elif(interest_rate > 20):
				error_code = ErrorCodes.INTEREST_RATE_TOO_HIGH
				print("Sanity: Interest rate over 20%")
				interest_rate_ok = false
			else:
				interest_rate_ok = true
				
	return interest_rate_ok
	# minimum: 0.01%


func check_mortgage_principal(_principal: float) -> bool:
	# minimum: $2850
	# not blank
	if(mortgage_principal_ok == true):
		mortgage_principal_ok = false
	
	if(_principal > 2400):
		mortgage_principal_ok = true
	else:
		mortgage_principal_ok = false
	
	return mortgage_principal_ok


func check_mortgage_term(_term_in_years: String) -> bool:
	# not empty
	# minimum: 6 months
	# maximum: 10
	var term: float

	# if we're reentering a field where a number has already been checked,
	# flip the flag so we can check the new, edited number.
	if(mortgage_term_ok == true):
		mortgage_term_ok = false

	match _term_in_years:
		"":
			print("Sanity: No Mortgage Term entered.")
			error_code = ErrorCodes.TERM_BLANK
			mortgage_term_ok = false
		_:
			# convert to float before the next test
			term = float(_term_in_years)
			
			if(term == 0):
				print("Sanity: Term is Zero")
				error_code = ErrorCodes.TERM_ZERO
				mortgage_term_ok = false
			elif(term < 0.5):
				print("Sanity: Term too short.")
				error_code = ErrorCodes.TERM_SHORT
				mortgage_term_ok = false
			elif(term > 10):
				print("Sanity: Term is too long.")
				error_code = ErrorCodes.TERM_LONG
			else:
				mortgage_term_ok = true
				
	return mortgage_term_ok


func check_amortization_period(_amortization_period_in_years: String) -> bool:
	# minimum: 6 months
	# if down payment = 20%, maximum: 35 years
	# if down_payment < 20%, maximum: 25 years
	var amortization: float
	print("Checking Amortization Period...")
	
	# if we're reentering a field where a number has already been checked,
	# flip the flag so we can check the new, edited number.
	if(amortization_period_ok == true):
		amortization_period_ok = false
	
	match _amortization_period_in_years:
		"":
			print("Sanity: No Amortization Period entered.")
			error_code = ErrorCodes.AMORTIZATION_BLANK
			amortization_period_ok = false
		_:
			# convert to float before the next test
			amortization = float(_amortization_period_in_years)
			
			if(amortization == 0):
				print("Sanity: Amortization Period is Zero")
				error_code = ErrorCodes.AMORTIZATION_ZERO
				amortization_period_ok = false
			elif(amortization < 0.5):
				print("Sanity: Amortization Period too short.")
				error_code = ErrorCodes.AMORTIZATION_LOW
				amortization_period_ok = false
			elif(amortization > 35):
				amortization_period_ok = false
				error_code = ErrorCodes.AMORTIZATION_HIGH
			elif(amortization > 25):
				if high_ratio == true:
					print("Sanity: Amortization Period too long for high ratio mortgage.")
					error_code = ErrorCodes.AMORTIZATION_TO_DOWN_LONG
					amortization_period_ok = false
				else:
					amortization_period_ok = true
			else:
				amortization_period_ok = true
				
	return amortization_period_ok


# origin: Numpad.gd, signal: sane_input_check
func match_field(_current_label: Object, _current_input: Object, _number: String):
	print("Sanity.gd...")

	match _current_label.text:
		"House Price $":
			if check_home_price(_number) == true:
				print("Sanity: home_price")
				emit_signal("home_price_okay", _current_label, _number) # Math._on_Sanity_home_price_okay()
			else:
				print("Error found in home price. Calling error screen.")
				emit_signal("error_condition", error_code) # go to Error screen
		"Down Payment $":
			if check_down_payment(_number) == true:
				print("Sanity: down_payment check")
				emit_signal("down_payment_okay", _current_label, _number)
			else:
				print("Error found in down payment. Calling error screen.")
				emit_signal("error_condition", error_code)
		"Interest Rate %":
			if check_interest_rate(_number) == true:
				print("Sanity: interest rate check")
				emit_signal("interest_rate_okay", _current_label, _number)
			else:
				print("Error found in down payment. Calling error screen.")
				emit_signal("error_condition", error_code)
		"Mortgage Term (yrs)":
			print("Sanity: mortgage_term")
			if check_mortgage_term(_number) == true:
				print("Sanity: mortgage_term okay")
				emit_signal("mortgage_term_okay", _current_label, _number)
			else:
				print("Error found in mortgage term.")
				emit_signal("error_condition", error_code)
		"Amortization Period (yrs)":
			print("Sanity: amortization_period")
			
			if check_amortization_period(_number) == true:
				print("Sanity: amortization_period okay")
				emit_signal("amortization_period_okay", _current_label, _number)
			else:
				print("Error on amortization period.")
				emit_signal("error_condition", error_code)


# origin: Cost.gd, signal: next_pressed
func check_cost_entries(_price: Object, _down: Object):
	print("Checking all cost fields...")
	
	if(home_price_ok == true && down_payment_ok == true && interest_rate_ok == true):
		print("Sanity: check_cost_entries - comparing home price to down payment...")
		compare_price_to_down(_price, _down)
	else:
		print("Not all fields are filled in.")
		emit_signal("error_condition", ErrorCodes.COST_FIELD_EMPTY)


func mortgage_sanity_check(_term: Object, _amortization: Object):
	print("Sanity: Checking all mortgage fields...")
	
	# It's assumed that all other sanity checks have been passed by now.
	if(mortgage_term_ok == true && amortization_period_ok == true):
		print("Sanity: mortgage entries checked.")
		emit_signal("mortgage_fields_okay")
	else:
		print("Sanity: Not all mortgage fields are filled in.")
		emit_signal("error_condition", ErrorCodes.MORTGAGE_FIELD_EMPTY)
