extends Node

var start_state : Array

var open_list : Array


func _ready() -> void:
	pass




func set_start_state(state : Array) -> void:
	start_state = state


func run() -> Array:
	var result_path = null
	for i in range(1,32):
		get_node("/root/Puzzle/Button").set_text(str("AI-Depth: ",i, " may take a while"))
		var path : Array
		path.append(start_state)
		var closed_list : Array = []
		result_path = rek_depth(path, i, closed_list)
		if result_path != null : break
	return result_path





func rek_depth(current_path : Array, var counter : int, var closed_list : Array):
	if counter <= 0: return current_path
	if is_target(current_path.back()) : return current_path
	var my_closed_list = closed_list.duplicate()
	my_closed_list.append(current_path.back())
	var result
	for state in expand(current_path.back(), my_closed_list):
		var path_dup = current_path.duplicate()
		path_dup.append(state)
		result = rek_depth(path_dup, counter-1, my_closed_list)
		if result != null and is_target(result.back()): return result
	
	return null



func is_in_closed_list(var state : Array, var closed_list : Array):
	for closed_state in closed_list:
		var is_equal : bool = true
		for i in range(3):
			for j in range(3):
				if closed_state[j][i] != state[j][i] : is_equal = false
		
		if is_equal : return true
		else : is_equal = true
	return false



func expand(var state : Array, var closed_list : Array) -> Array:
	var result : Array
	for i in range(3):
		for j in range(3):
			if state[j][i] == 9:
				if j+1 <= 2:
					var new_state = copy_state(state)
					new_state[j][i] = new_state[j+1][i]
					new_state[j+1][i] = 9
					if !is_in_closed_list(new_state, closed_list):
						result.append(new_state)
						
				if j-1 >= 0:
					var new_state = copy_state(state)
					new_state[j][i] = new_state[j-1][i]
					new_state[j-1][i] = 9
					if !is_in_closed_list(new_state, closed_list):
						result.append(new_state)
						
				if i+1 <= 2:
					var new_state = copy_state(state)
					new_state[j][i] = new_state[j][i+1]
					new_state[j][i+1] = 9
					if !is_in_closed_list(new_state, closed_list):
						result.append(new_state)
						
				if i-1 >= 0:
					var new_state = copy_state(state)
					new_state[j][i] = new_state[j][i-1]
					new_state[j][i-1] = 9
					if !is_in_closed_list(new_state, closed_list):
						result.append(new_state)
	result.shuffle()
	return result
				
	
	
	
	
func copy_state(var state : Array) -> Array:
	var copy : Array = [[0,0,0],[0,0,0],[0,0,0]]
	for i in range(3):
		for j in range(3):
			copy[j][i] = state[j][i]
	return copy


func is_target(var state : Array) -> bool:
	if state == null : return false
	for i in range(3):
		for j in range(3):
			if state[j][i] != i * 3 + j + 1:
				return false
	return true
	
