extends Control

signal done_with_help

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func back_to_work():
	print("Help OK button")
	emit_signal("done_with_help")
