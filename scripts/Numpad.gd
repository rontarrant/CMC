extends Control

signal cancel_button_signal
signal sane_input_check

"""
This is the slide-on numpad.
It appears any time the user touches one of the number entry boxes on any other 
screen (from here on called the screen of origin). The entry box at the top of 
the numpad is for entering a number for the box that was touched on one of the 
other screens.
Functions:
- The number buttons add the cooresponding digit to the number in the entry box.
- The triple-zero button adds three 0's as a convenience for the user.
- The last number entered can be cleared using the Clear button.
- The Cancel button will return the user to the screen of origin and the entry 
  box on that screen will be left blank.
- The OK button will return the user to the screen of origin and put the entered
  number into the entry box that was touched on the screen of origin.
"""

var current_label: Object
var current_input: Object

func set_current(_active_label, _active_field):
	$"%NumberLabel".set_text(_active_label.text)
	$"%NumberInput".set_text(_active_field.text)
	current_label = $"%NumberLabel"
	current_input = $"%NumberInput"


func _on_Button1_pressed():
	print("NumPad 1 pressed")
	$"%NumberInput".text += "1"

func _on_Button2_pressed():
	print("NumPad 2 pressed")
	$"%NumberInput".text += "2"


func _on_Button3_pressed():
	print("NumPad 3 pressed")
	$"%NumberInput".text += "3"


func _on_Button4_pressed():
	print("NumPad 4 pressed")
	$"%NumberInput".text += "4"


func _on_Button5_pressed():
	print("NumPad 5 pressed")
	$"%NumberInput".text += "5"


func _on_Button6_pressed():
	print("NumPad 6 pressed")
	$"%NumberInput".text += "6"


func _on_Button7_pressed():
	print("NumPad 7 pressed")
	$"%NumberInput".text += "7"


func _on_Button8_pressed():
	print("NumPad 8 pressed")
	$"%NumberInput".text += "8"


func _on_Button9_pressed():
	print("NumPad 9 pressed")
	$"%NumberInput".text += "9"


func _on_Button000_pressed():
	print("NumPad 000 pressed")
	$"%NumberInput".text += "000"


func _on_Button0_pressed():
	print("NumPad 0 pressed")
	$"%NumberInput".text += "0"


func _on_Dot_pressed():
	print("NumPad DOT (.) pressed")
	$"%NumberInput".text += "."


func _on_Clear_pressed():
	print("NumPad CLEAR pressed.")
	$"%NumberInput".text = ""


func _on_Backspace_pressed():
		print("NumPad BCKSP pressed")
		#$"%NumberInput".text.erase($"%KeypadNumberLineEdit".text.length() - 1, 1)
		$"%NumberInput".set_cursor_position($"%NumberInput".text.length())
		$"%NumberInput".delete_char_at_cursor()


func _on_Cancel_pressed():
	print("KeyPad CANCEL pressed.")
	$"%NumberInput".text = ""
	emit_signal("cancel_button_signal")


func _on_OK_pressed():
	print("Numpad OK pressed.")
	emit_signal("sane_input_check", current_label, current_input, $"%NumberInput".text)
