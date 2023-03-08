extends Control

signal done_with_about


func _on_aboutOK_pressed():
	print("About OK pressed")
	emit_signal("done_with_about")



func goto_sponsor():
	OS.shell_open("https://github.com/sponsors/rontarrant?frequency=one-time&sponsor=rontarrant")
