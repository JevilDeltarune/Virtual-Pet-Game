extends Node
var hunger = 100
var happy = 100
@export var dayLength = 60
@export var point1: Vector2 = Vector2(510, 169)
@export var point2: Vector2 = Vector2(638, 300)
@export var food_numnum: Resource = preload("res://food.tscn")

var fancytexture = load("res://Fancy Turtle.png")

var run: bool = true

var thoughts = ["I'm Hungry", "I'm Bored", "I'm Hungry And Bored"]

func get_random_point_inside(p1: Vector2, p2: Vector2) -> Vector2:

	var xvalue: float = randf_range(p1.x, p2.x)
	var yvalue: float = randf_range(p1.y, p2.y)
	
	var randompointinside: Vector2 = Vector2 (xvalue, yvalue)
	
	return randompointinside


func spawn():
	var food_instance: Node = food_numnum.instantiate()
	add_child(food_instance)
	var spawn_location: Vector2 = get_random_point_inside(point1, point2)
	food_instance.set_position(spawn_location)
	Globals.dirtOnPet += 1
	if !Globals.showDirt:
		for dirt in get_tree().get_nodes_in_group("dirt"):
			dirt.hide()
	else:
		for dirt in get_tree().get_nodes_in_group("dirt"):
			dirt.show()
	
	#await get_tree().create_timer(0.2).timeout
	#food_instance.queue_free()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	$DebugScreen.hide()
	print("tutorial")

	$FeedScene/FoodTimer.paused = true
	$FeedScene/HappyTimer.paused = true
	$FeedScene/DirtyTimer.paused = true
	$FeedScene/FoodTimer
	$FeedScene/ReportCard.hide()
	$RedCircle.show()
	$Label.show()
	$"Sneaky blocker block".set_global_position(Vector2(0,0))
	$RedCircle/AnimationPlayer.play("Tutorial")
	await $RedCircle/AnimationPlayer.animation_finished
	$"Sneaky blocker block".mouse_filter = 2
	$"Sneaky blocker block".set_global_position(Vector2(0,0))
	print("start game")
	newDay()
	$FeedScene/FoodTimer.paused = false
	$FeedScene/HappyTimer.paused = false
	$FeedScene/DirtyTimer.paused = false
	


func end_game():
	run = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$DebugScreen/TimerLabel.text = "Time Left: " + (str)(Globals.timeLeft)
	$DebugScreen/DirtCounter.text = (str)(Globals.dirtOnPet)

	if (run == true):
		if (hunger == 0):
			end_game()
	if hunger < 50 && happy < 50:
		$FeedScene/ThoughtBubble/Thought.text = thoughts[2]
		$FeedScene/ThoughtBubble.show()
	elif hunger < 50:
		$FeedScene/ThoughtBubble/Thought.text = thoughts[0]
		$FeedScene/ThoughtBubble.show()
	elif  happy < 50:
		$FeedScene/ThoughtBubble/Thought.text = thoughts[1]
		$FeedScene/ThoughtBubble.show()
	else:
		$FeedScene/ThoughtBubble/Thought.text = ""
		$FeedScene/ThoughtBubble.hide()
	


func _on_timer_timeout() -> void:
	if (run == true):
		hunger = clamp(hunger, 0, 100)
		hunger -= 1
		$FeedScene/HungerBar.value = hunger





func feed():
	if Globals.food > 0:
		hunger = clamp(hunger, 0, 100)
		hunger += 10
		Globals.food -= 1
		$FoodCounter.text = (str(Globals.food)) + " Food"

		$FeedScene/HungerBar .value = hunger
	
func play():
	happy = (int)(clamp(happy, 0, 100))
	happy += 10

	$FeedScene/HappyBar.value = happy
	


func _on_button_pressed() -> void:

	if (run == true):
		feed()
		


func _on_happy_timer_timeout() -> void:
	if (run == true):
		happy = clamp(happy, 0, 100)
		happy -= 1
		$FeedScene/HappyBar.value = happy
		Globals.timeLeft -= 1

func _on_play_button_pressed() -> void:
	if (run == true):
		play()



func _on_buy_food_pressed() -> void:
	if Globals.money >= 10:
		Globals.food = Globals.food + 1
		Globals.money = Globals.money - 10
		$MoneyCounter.text = str(Globals.money) + " dollars"
		$FoodCounter.text = (str(Globals.food)) + " Food"
	


func _on_dirty_timer_timeout() -> void:
	spawn()


func _on_shop_button_pressed() -> void:
	$FeedScene.hide()
	Globals.showDirt = true


func getScore():
	Globals.score = (Globals.score + ((float)(happy + hunger)))/3
	$DebugScreen/ScoreLabel.text = "Base Score: " + (str)(Globals.score)
	Globals.totalScore += Globals.score 
	Globals.timesRan += 1
	
func repeat_for_time(duration: float) -> void:
	var timer := get_tree().create_timer(duration)
	Globals.timeLeft = duration
	$DebugScreen/TimerLabel.text = "Time Left: " + (str)(60 - (-1 * Globals.timeLeft))

	while timer.time_left > 0:
		getScore()
		$DebugScreen/TimerLabel.text = (str)(Globals.timeLeft)
		Globals.finalScore = Globals.totalScore / Globals.timesRan - (Globals.dirtOnPet)
		$DebugScreen/CurrentFinalScore.text = "Current Final Score: " + (str)(Globals.finalScore - Globals.dirtOnPet)
		await get_tree().process_frame
	if Globals.isSick:
		Globals.finalScore = Globals.totalScore / Globals.timesRan - (Globals.dirtOnPet) - 20
	$DebugScreen/FinalScoreLabel.text =(str)(Globals.finalScore)
	if Globals.finalScore < 80:
		Globals.rating = "Horrible"
		Globals.gold += 5
	elif Globals.finalScore < 90:
		Globals.rating = "Mediocre"
		Globals.gold += 35/2
	elif Globals.finalScore > 95:
		Globals.rating = "Great"
		Globals.gold += 25
		print("got 50 gold")
	$DebugScreen/RatingLabel.text = Globals.rating
	dayOver()
	
	

func _input(event):
	if event.is_action_pressed("Open Debug Screen"):
		if $DebugScreen.visible:
			$DebugScreen.hide()
		else:
			$DebugScreen.show()


func dayOver():
	$FeedScene/ReportCard.show()
	$FeedScene/HappyTimer.stop()
	$FeedScene/FoodTimer.stop()
	$FeedScene/DirtyTimer.stop()
	$FeedScene/ReportCard.global_position = Vector2(347, 26)
	$FeedScene/ReportCard/Grade.text = "You did " + (str)(Globals.rating)
	$FeedScene/ReportCard/Score.text = "You got a " + (str)((int)(Globals.finalScore))
	
	$FeedScene/ReportCard/Stats/DirtPenalty.text = "-" + (str)(Globals.dirtOnPet) + " for dirt left on pet"
	if Globals.isSick:
		$FeedScene/ReportCard/Stats/SickPenalty.text = "-20 for your pet being sick"
		$"FeedScene/ReportCard/Stats/Base Score".text = "Base Score: " + (str)((int)(Globals.finalScore + Globals.dirtOnPet + 20))
	else:
		$FeedScene/ReportCard/Stats/SickPenalty.text = "-0 for your pet being healthy"
		$"FeedScene/ReportCard/Stats/Base Score".text = "Base Score: " + (str)((int)(Globals.finalScore + Globals.dirtOnPet))
		
	var random = randi_range(1, 5)
	if (random == 5):
		Globals.isSick = true
	print((str)(random) + " " + (str)(Globals.isSick))
	$"FeedScene/ReportCard/Gold Counter".text = "Gold: " + (str)(Globals.gold)
	

func newDay():
	print("new day")
	$FeedScene/ReportCard/CosmeticShop.hide()
	$FeedScene/ReportCard.global_position = Vector2(9999, 99999)
	$FeedScene/ThoughtBubble.hide()
	repeat_for_time(dayLength)
	$FeedScene/DirtyTimer.start()
	$FeedScene/HappyTimer.start()
	$FeedScene/FoodTimer.start()
	$FeedScene/ReportCard.global_position = Vector2(9999, 99999)
	$FeedScene/ThoughtBubble.hide()
	repeat_for_time(dayLength)
	Globals.food = 0
	Globals.money = 20
	Globals.showDirt = true

	Globals.score = 0

	Globals.totalScore = 0
	Globals.timesRan = 0
	Globals.finalScore = 0
	Globals.timeLeft = 0

	Globals.rating = "Placeholder"

	Globals.dirtOnPet = 0


func _on_debug_pressed() -> void:
	print("tutorial")
	$RedCircle.show()
	$Label.show()
	$RedCircle/AnimationPlayer.play("Tutorial")


func _on_new_day_button_pressed() -> void:
	newDay()


func _on_cosmetic_shop_button_pressed() -> void:
	$FeedScene/ReportCard/CosmeticShop/GoldLabel.text = "You have "+ (str)(Globals.gold) + " Gold."
	$FeedScene/ReportCard/CosmeticShop.show()
	$"FeedScene/ReportCard/Gold Counter".text = "Gold: " + (str)(Globals.gold)


func _on_buy_fancy_turtle_pressed() -> void:
	if Globals.gold >= 50:
		Globals.gold -= 50
		$FeedScene/Pet/Sprite2D.texture = fancytexture
	else:
		print("get mo money bozo")
	$FeedScene/ReportCard/CosmeticShop/GoldLabel.text = "You have "+ (str)(Globals.gold) + " Gold."
	$"FeedScene/ReportCard/Gold Counter".text = "Gold: " + (str)(Globals.gold)


func _on_exit_shop_pressed() -> void:
	$FeedScene/ReportCard/CosmeticShop.hide()
	$"FeedScene/ReportCard/Gold Counter".text = "Gold: " + (str)(Globals.gold)
	
	


func _on_x_button_pressed() -> void:
	$FeedScene.show()
	Globals.showDirt = false
	$"FeedScene/ReportCard/Gold Counter".text = "Gold: " + (str)(Globals.gold)

func gameStart():
	newDay()
	
	



func _on_doctor_button_pressed() -> void:
	if Globals.gold >= 10:
		Globals.gold -= 10
		$FeedScene/ReportCard/VetRect.show()
		if Globals.isSick:
			Globals.isSick = false
			$FeedScene/ReportCard/VetRect/VetBillLabel.text = "Your pet was sick"
		else:
			$FeedScene/ReportCard/VetRect/VetBillLabel.text = "Your pet wasn't sick"
		
	else:
		print("brokie")
	$"FeedScene/ReportCard/Gold Counter".text = "Gold: " + (str)(Globals.gold)


func _on_hide_button_pressed() -> void:
	$FeedScene/ReportCard/VetRect.hide()
	$"FeedScene/ReportCard/Gold Counter".text = "Gold: " + (str)(Globals.gold)
