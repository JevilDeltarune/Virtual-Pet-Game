extends Node2D



func _on_shop_button_pressed() -> void:
	show()
	Globals.showDirt = false
	for dirt in get_tree().get_nodes_in_group("dirt"):
		dirt.hide()


func _on_main_ready() -> void:
	hide()
	add_to_group("Shop_Scene")


func _on_x_button_pressed() -> void:
	hide()
	Globals.showDirt = true
	for dirt in get_tree().get_nodes_in_group("dirt"):
		dirt.show()


func _on_casino_button_pressed() -> void:
	hide()
	for shop_scene in get_tree().get_nodes_in_group("Shop_Scene"):
		shop_scene.hide()
	
