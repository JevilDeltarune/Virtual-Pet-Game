extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_shop_button_pressed() -> void:
	show()


func _on_x_button_pressed() -> void:
	hide()
