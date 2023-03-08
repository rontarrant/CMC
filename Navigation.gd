extends Control

var transitionTime := 0.5
var screenOrigin := Vector2.ZERO
var screenSize := Vector2.ZERO

var currentScreen
var screenStack := []

onready var welcome_screen = $Welcome
onready var cost_screen = $Cost
onready var mortgage_screen = $Mortgage
onready var summary_screen = $Summary
onready var keypad_screen = $Keypad
onready var error_screen = $Error
onready var help_screen = $Help
onready var conversion_object = $Conversion
onready var math_object  = $Math
onready var sanity_object = $Sanity

onready var tween = $Tween

func _ready() -> void:
	screenSize = get_viewport_rect().size
	currentScreen = welcome_screen


func move_to_next_screen(nextScreenID: String):
	var nextScreen = get_screen_from_screenID(nextScreenID)
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


func move_to_previous_screen():
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


func get_screen_from_screenID(screenID: String) -> Control:
	var screen
	
	match screenID:
		"welcome_screen":
			screen = welcome_screen
		"cost_screen":
			screen = cost_screen
		"mortgage_screen":
			screen = mortgage_screen
		"summary_screen":
			screen = summary_screen
		"keypad_screen":
			screen = keypad_screen
		"error_screen":
			screen = error_screen
		"help_screen":
			screen = help_screen
		_: # default
			screen = welcome_screen
		
	return screen


func reset():
	$"%Screen02Cost".reset()
	$"%Screen03Term".reset()
	$"%Screen04Summary".reset()


