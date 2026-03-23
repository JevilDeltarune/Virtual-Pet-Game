extends Area2D

var dragging := false
var offsetOfObject := Vector2.ZERO

func _ready():
	area_entered.connect(_on_area_entered)

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position() - offsetOfObject

func _on_button_button_down():
	dragging = true
	offsetOfObject = get_global_mouse_position() - global_position

func _on_button_button_up():
	dragging = false
func _on_area_entered(area):
	if dragging and area.is_in_group("dirt"):
		area.queue_free()
		Globals.money += 5
		Globals.dirtOnPet -= 1
		$"../../MoneyCounter".text = str(Globals.money) + " dollars"
