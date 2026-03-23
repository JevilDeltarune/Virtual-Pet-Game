extends Node2D





func _on_shop_button_pressed() -> void:
	hide()
	Globals.showDirt = true


func _on_x_button_pressed() -> void:
	show()
	Globals.showDirt = false
