extends TextureRect

class_name Stone

var number : int
var fieldX : int
var fieldY : int

var dragged : bool

var target_position : Vector2

func _ready() -> void:
	if number == 1:
		texture = load("res://assets/1.jpg")
	if number == 2:
		texture = load("res://assets/2.jpg")
	if number == 3:
		texture = load("res://assets/3.jpg")
	if number == 4:
		texture = load("res://assets/4.jpg")
	if number == 5:
		texture = load("res://assets/5.jpg")
	if number == 6:
		texture = load("res://assets/6.jpg")
	if number == 7:
		texture = load("res://assets/7.jpg")
	if number == 8:
		texture = load("res://assets/8.jpg")
	pass




func _physics_process(delta: float) -> void:
	if dragged:
		rect_position = get_viewport().get_mouse_position() - (rect_size/2)
	
	rect_position = lerp(rect_position, target_position, 0.1)
	$Label.text = str(number)
	$Label2.text = str(fieldX, " | ", fieldY)
	

func set_target_position(var pos : Vector2) -> void:
	target_position = pos


func set_dragged() -> void:
	dragged = true

func set_undragged() -> void:
	dragged = false
	
