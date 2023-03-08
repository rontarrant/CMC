extends Control

var error_message: String

signal error_text_ready
signal error_ok_pressed

# error codes and their meanings
var Errors = [
	"Home Price cannot be zero.",
	"Home Price cannot be blank.",
	"Home Price must be at least $3000.00",
	"Down Payment cannot be zero.",
	"Down Payment cannot be blank.",
	"Down Payment cannot be higher than Home Price.",
	"Down Payment must be at least 5% of Home Price.",
	"Interest Rate cannot be zero.",
	"Interest Rate cannot be blank.",
	"Interest Rate too high.",
	"The down payment is greater than the home price.",
	"The down payment must be at least 5% of the home price.",
	"Home Price, Down Payment, and Interest Rate must all be filled in.",
	"Mortgage Term cannot be zero.",
	"Mortgage Term cannot be blank.",
	"Mortgage Term must be at least six months (enter as 0.5 years).",
	"Mortgage Term cannot be longer than 10 years.",
	"Amortization Period cannot be zero.",
	"Amortization Period cannot be blank.",
	"Amortization Period is lower than five years.",
	"Amortization Period is longer than 35 years.",
	"With a Down Payment of less than 20% (a High Ratio mortgage), Amortization Period must be 25 years or less.",
	"Both Mortgage Term and Amortization Period fields must be filled in."
]


func _on_errorOK_pressed():
	print("Error OK pressed")
	emit_signal("error_ok_pressed")


# origin: Sanity.gd, signal: error_condition
func set_error_text(error_code):
	$"%ErrorLabel".text = "Error:\n" + Errors[error_code]
	print("ErrorLabel: " + $"%ErrorLabel".text)
	emit_signal("error_text_ready")
