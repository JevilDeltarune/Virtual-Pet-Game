extends Node2D




func _on_casino_button_pressed() -> void:
	show()
	for dirt in get_tree().get_nodes_in_group("dirt"):
		dirt.hide()


	


func _on_main_ready() -> void:
	hide()


func _on_x_button_2_pressed() -> void:
	hide()
	for dirt in get_tree().get_nodes_in_group("dirt"):
		dirt.show()
