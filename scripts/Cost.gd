extends Control

# signals used when program flow leaves this scene
signal edit_field
signal cost_sanity_check
signal get_help
signal reset_all


func set_home_price(_price: String):
	$"%costHomePrice".set_text(_price)


func set_down_payment(_price: String):
	$"%costDownPayment".set_text(_price)


func set_interest_rate(_price: String):
	$"%costInterestRate".set_text(_price)


# In the next three methods, when a signal is emitted, they pass
# both Label and LineEdit pointers through Main.edit_field() to Numpad.gd
# so the field being edited can be identified.
func edit_home_price():
	print("Home Price field")
	emit_signal("edit_field", $"%costHousePriceLabel", $"%costHomePrice")


func edit_down_payment():
	print("down payment field")
	emit_signal("edit_field", $"%costDownPaymentLabel", $"%costDownPayment")


func edit_interest_rate():
	print("costRate focused")
	emit_signal("edit_field", $"%costInterestRateLabel", $"%costInterestRate")


# origin: costNext.pressed
func next_screen():
	print("Moving on from Cost screen")
	emit_signal("cost_sanity_check", $"%costHomePrice", $"%costDownPayment")


# origin: costReset.pressed
func reset():
	print("cost_reset pressed")
	$"%costHomePrice".set_text("")
	$"%costDownPayment".set_text("")
	$"%costInterestRate".set_text("")


func reset_all():
	emit_signal("reset_all", "cost")


# origin: costHelp.pressed
func get_help():
	print("Cost Help pressed")
	emit_signal("get_help")


