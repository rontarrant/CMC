extends TextureButton

signal mortgage_previous_pressed

func _on_mortgagePrevious_pressed():
	print("mortgage Previous button pressed")
	emit_signal("mortgage_previous_pressed")
