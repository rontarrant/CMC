extends Control

var transitionTime := 0.5
var screenOrigin := Vector2.ZERO
var screenSize := Vector2.ZERO

var currentScreen
var screenStack := []

# track which field is being filled while the KeyPad is open
var active_label
var active_input

onready var welcomeID = $"%Welcome"
onready var aboutID = $"%About"
onready var costID = $"%Cost"
onready var mortgageID = $"%Mortgage"
onready var summaryID = $"%Summary"
onready var numpadID = $"%Numpad"
onready var errorID = $"%Error"
onready var helpID = $"%Help"
onready var mathID  = $"%Math"
onready var sanityID = $"%Sanity"

onready var tween = $"%Tween"

func _ready() -> void:
	screenSize = get_viewport_rect().size
	currentScreen = welcomeID


func next_screen(nextScreen):
	var transitionProperty: String = "rect_global_position"
	var currentFrom = currentScreen.rect_global_position
	var nextFrom = nextScreen.rect_global_position
	var currentTo = Vector2(-screenSize.x, 0)
	print("move to next screen")
	tween.interpolate_property(currentScreen, transitionProperty, currentFrom, currentTo, transitionTime)
	tween.interpolate_property(nextScreen, transitionProperty, nextFrom, screenOrigin, transitionTime)
	tween.start()
	screenStack.append(currentScreen)
	currentScreen = nextScreen


func previous_screen():
	var previousScreen = screenStack.pop_back()
	var transitionProperty: String = "rect_global_position"
	var previousFrom = previousScreen.rect_global_position
	var currentFrom = currentScreen.rect_global_position
	var currentTo = Vector2(screenSize.x, 0)
	
	if previousScreen != null:
		tween.interpolate_property(previousScreen, transitionProperty, previousFrom, screenOrigin, transitionTime)
		tween.interpolate_property(currentScreen, transitionProperty, currentFrom, currentTo, transitionTime)
		tween.start()
		currentScreen = previousScreen


func reset_all(_caller: String):
	$"%Cost".reset()
	$"%Mortgage".reset()
	$"%Summary".reset()
	$"%Math".reset()
	$"%Sanity".reset()
	
	print("Caller: " + _caller)
	
	# How many pages back we go depends on where we are.
	if(_caller == "mortgage"):
		previous_screen()
	elif(_caller == "summary"):
		previous_screen()
		previous_screen()


# origin: Welcome.gd, signal: get_help
func show_help():
	next_screen(helpID)


# origin: Welcome.gd, signal: goto_start
func goto_cost_screen():
	next_screen(costID)


# origin: Welcome.gd, signal: goto_about
func goto_about_screen():
	next_screen(aboutID)


# origins: Cost.gd, Mortgage.gd - signal: edit_field
func edit_field(_price_label: Object, _price_input: Object):
	$"%Numpad".set_current(_price_label, _price_input)
	next_screen(numpadID)


# origin: Mortgage.gd - signal: displayed
func goto_mortgage_screen():
	next_screen(mortgageID)


# origin: Error.gd - signal: error_text_ready
func goto_error_screen():
	print("Main.gd - goto_error_screen()")
	next_screen(errorID)


# origin: Math.gd - signal: home_price_stored
func display_home_price():
	$"%Cost".set_home_price(str($"%Math".home_price))
	previous_screen()


# origin: Math.gd, signal: down_payment_stored
func display_down_payment():
	$"%Cost".set_down_payment(str($"%Math".down_payment))
	previous_screen()


# origin: Math.gd - signal: interest_rate_stored
func display_interest_rate():
	$"%Cost".set_interest_rate(str($"%Math".interest_rate))
	previous_screen()


func display_term():
	$"%Mortgage".set_term(str($"%Math".mortgage_term))
	previous_screen()


func display_amortization():
	$"%Mortgage".set_amortization(str($"%Math".amortization_period))
	previous_screen()


func goto_summary():
	print("Main: going to Summary Screen.")
	next_screen(summaryID)


func toggle_high_ratio_flag():
	pass # Replace with function body.
