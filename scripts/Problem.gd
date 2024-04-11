extends ColorRect

var field : Array
var offset : int = 15

var abstracted_path : Array
var dragged_stone : Stone

var thread = Thread.new()

func _ready() -> void:
	randomize()
	init_field()
	
	


func init_field() -> void:
	var dummy : Stone = load("res://scenes/Stone.tscn").instance()
	field.append([dummy, dummy, dummy])
	field.append([dummy, dummy, dummy])
	field.append([dummy, dummy, dummy])
	
	
	for i in range(3):
		for j in range(3):
			var number : int  = i * 3 + j + 1
			var stone : Stone = load("res://scenes/Stone.tscn").instance() as Stone
			stone.number = number
			stone.fieldX = j
			stone.fieldY = i
			field[j][i] = stone
			stone.set_target_position(Vector2(j*stone.rect_size.x+offset*(j+1), i*stone.rect_size.y+offset*(i+1)))
			self.add_child(stone)



func is_swap_allowed(var stone1 : Stone, var stone2 : Stone) -> bool:
	if stone1.number != 9 and stone2.number != 9: return false
	var pos1 = Vector2(stone1.fieldX, stone1.fieldY)
	var pos2 = Vector2(stone2.fieldX, stone2.fieldY)
	if (pos1-pos2).length() > 1 : return false
	else: return true
	




func swap_stones(var stone1 : Stone, var stone2 : Stone) ->void:
	var x1 = stone1.fieldX
	var y1 = stone1.fieldY
	stone1.fieldX = stone2.fieldX
	stone1.fieldY = stone2.fieldY
	stone2.fieldX = x1
	stone2.fieldY = y1
	stone1.set_target_position(Vector2(stone1.fieldX*stone1.rect_size.x+offset*(stone1.fieldX+1), stone1.fieldY*stone1.rect_size.y+offset*(stone1.fieldY+1)))
	stone2.set_target_position(Vector2(stone2.fieldX*stone2.rect_size.x+offset*(stone2.fieldX+1), stone2.fieldY*stone2.rect_size.y+offset*(stone2.fieldY+1)))
	field[stone1.fieldX][stone1.fieldY] = stone1
	field[stone2.fieldX][stone2.fieldY] = stone2
	



func get_stone_under_position(var pos : Vector2) -> Stone:
	for i in range(3):
		for j in range(3):
			var stone : Stone = field[j][i]
			if stone.get_global_rect().has_point(pos): return stone
	return null


func randomize_stones() -> void:
	for i in range(30):
		for j in range(3):
			for k in range(3):
				if field[k][j].number == 9:
					var r = randi() % 4
					if r == 0:
						if k+1 <= 2:
							swap_stones(field[k][j], field[k+1][j])
					if r == 1:
						if k-1 >= 0:
							swap_stones(field[k][j], field[k-1][j])
					if r == 2:
						if j+1 <= 2:
							swap_stones(field[k][j], field[k][j+1])
					if r == 3:
						if j-1 >= 0:
							swap_stones(field[k][j], field[k][j-1])






func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var result = get_stone_under_position(event.position)
		if result != null:
			dragged_stone = result
			dragged_stone.set_dragged()
		
	elif event.is_action_released("click") and dragged_stone != null:
		dragged_stone.set_undragged()
		var pos = get_viewport().get_mouse_position()
		pos = Vector2(floor(pos.x/get_viewport_rect().size.x*3), floor(pos.y/get_viewport_rect().size.y*3))
		if is_swap_allowed(dragged_stone, field[pos.x][pos.y]) : 
			print("swapping" , dragged_stone.number, "with", field[pos.x][pos.y].number)
			swap_stones(dragged_stone, field[pos.x][pos.y])
			
		

func get_abstracted_state() -> Array:
	var result : Array = []
	result.append([0,0,0])
	result.append([0,0,0])
	result.append([0,0,0])
	for i in range(3):
		for j in range(3):
			result[j][i] = field[j][i].number
	return result





func set_field_from_abstracted_state(var state : Array) -> void:
	var stone1 = get_stone_by_number(1)
	var stone2 = get_stone_by_number(2)
	var stone3 = get_stone_by_number(3)
	var stone4 = get_stone_by_number(4)
	var stone5 = get_stone_by_number(5)
	var stone6 = get_stone_by_number(6)
	var stone7 = get_stone_by_number(7)
	var stone8 = get_stone_by_number(8)
	var stone9 = get_stone_by_number(9)
	var dic : Dictionary = {1:stone1, 2:stone2, 3:stone3, 4:stone4, 5:stone5, 6:stone6, 7:stone7, 8:stone8, 9:stone9}
	for i in range(3):
		for j in range(3):
			swap_stones(field[j][i], dic[state[j][i]])
			

func get_stone_by_number(var number : int) -> Stone:
	for i in range(3):
		for j in range(3):
			if field[j][i].number == number:
				return field[j][i]
	return null



func _on_Button_pressed() -> void:
	thread = Thread.new()
	$AI.set_start_state(get_abstracted_state())
	thread.start(self, "_thread")


func _on_Button2_pressed() -> void:
	randomize_stones()
	
	
	
func _thread():
	abstracted_path = $AI.run()
	for state in abstracted_path:
		print(state)
		set_field_from_abstracted_state(state)
		yield(get_tree().create_timer(0.5), "timeout")
	$Button.text = "AI"
