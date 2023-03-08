extends Control

signal get_help
signal goto_start
signal goto_about


# origin: welcomeHelp.pressed
func goto_help_screen():
	print("Welcome - Help")
	emit_signal("get_help")


# origin: welcomeAbout.pressed
func goto_about_screen():
	print("Welcome - About")
	emit_signal("goto_about")


# origin: welcomeStart.pressed
func goto_cost_screen():
	print("Welcome - Start")
	emit_signal("goto_start")

