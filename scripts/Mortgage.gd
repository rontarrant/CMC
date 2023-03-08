extends Control

signal edit_field
signal previous_pressed
signal get_help
signal mortgage_sanity_check
signal reset_all
signal displayed

var home_price: String
var down_payment: String

var down_payment_prefix = "Down Payment $"
var principal_prefix = "Principal $"


func set_term(_term: String):
	$"%mortgageTerm".set_text(_term)


func set_amortization(_amortization: String):
	$"%mortgageAmortization".set_text(_amortization)


# origin: Math.gd, signal: principal_stored
func display_calculated_values(_down_payment: String, _principal: String):
	$"%mortgageDownPayment".set_text(_down_payment)
	$"%mortgagePrincipal".set_text(_principal)
	emit_signal("displayed")


func edit_term():
	print("mortgage Term input focused")
	emit_signal("edit_field", $"%mortgageTermLabel", $"%mortgageTerm")


func edit_amortization():
	print("mortgage Amortization Period focused")
	emit_signal("edit_field", $"%mortgageAmortizationLabel", $"%mortgageAmortization")


func get_help():
	print("mortgage_ Help button")
	emit_signal("get_help")


func goto_previous():
	print("Mortgage - Prev pressed")
	emit_signal("previous_pressed")


func next_screen():
	print("Morgage - Next pressed")
	emit_signal("mortgage_sanity_check", $"%mortgageTerm", $"%mortgageAmortization")


func reset():
	print("resetting everything in mortgage")
	$"%mortgageDownPayment".set_text("")
	$"%mortgagePrincipal".set_text("")
	$"%mortgageTerm".set_text("")
	$"%mortgageAmortization".set_text("")


func reset_all():
	print("Resetting from Mortgage screen.")
	emit_signal("reset_all", "mortgage")
