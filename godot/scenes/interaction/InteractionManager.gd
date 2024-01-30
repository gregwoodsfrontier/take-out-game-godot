extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label

const base_text = "[E] to"

var active_areas = []
var isInteractable = true

func register_area(_area: InteractionArea):
	active_areas.push_back(_area)

func unregister_area(_area: InteractionArea):
	var idx = active_areas.find(_area)
	if idx != -1:
		active_areas.remove_at(idx)

func sort_by_distance_to_player(area1: InteractionArea, area2: InteractionArea):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	
	return area1_to_player < area2_to_player

func showLabel():
	var first_area: InteractionArea = active_areas[0]
	label.text = base_text + first_area.action_name
	label.global_position = first_area.global_position
	label.global_position.y -= 36
	label.global_position.x -= label.size.x / 2
	label.z_index = 90
	label.show()

func hideLabel():
	#label.global_position.y += 36
	#label.global_position.x += label.size.x / 2
	label.hide()

func _process(delta):
	if active_areas.size() > 0 && isInteractable:
		active_areas.sort_custom(sort_by_distance_to_player)
		showLabel()
	else:
		hideLabel()

func _input(event):
	if event.is_action_pressed("interact") && isInteractable:
		if active_areas.size() > 0:
			isInteractable = false
			hideLabel()
			
			# wait for the first interact to be finished
			await active_areas[0].interact.call()
			isInteractable = true
			
