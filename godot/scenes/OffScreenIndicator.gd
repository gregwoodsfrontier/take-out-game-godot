extends Node2D
class_name OffScreenIndicator

signal indicator_inbound
signal indicator_outbound

@onready var indicator_holder = $IndicatorHolder
@onready var icon = $IndicatorHolder/IconHolder
@onready var target_node = get_tree().get_first_node_in_group("player")

var target_position = null

func _process(_delta):
	target_position = target_node.global_position
	initIndicators()

func set_marker_position(bounds: Rect2) -> void:
	if target_position == null:
		indicator_holder.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
		indicator_holder.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	else:
		var displacement = global_position - target_position
		var length = 0
		
		var tl_angle = (bounds.position - target_position).angle()
		var tr_angle = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
		var bl_angle = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
		var br_angle = (bounds.end - target_position).angle()
		
		if is_point_on_y_side(displacement, tl_angle, tr_angle, bl_angle, br_angle):
			var y_length = clamp(displacement.y, \
			bounds.position.y - target_position.y, \
			bounds.end.y -  target_position.y )
			
			var angle = displacement.angle() - PI / 2.0
			length = y_length / cos(angle) if cos(angle) != 0 else y_length
		else:
			var x_length = clamp(displacement.x, \
			bounds.position.x - target_position.x, \
			bounds.end.x -  target_position.x )
			
			var angle = displacement.angle()
			length = x_length / cos(angle) if cos(angle) != 0 else x_length
		
		indicator_holder.global_position = length * Vector2.from_angle(displacement.angle()) + target_position
	
	if bounds.has_point(global_position):
		#hide()
		indicator_inbound.emit()
	else:
		#show()
		indicator_outbound.emit()

func is_point_on_y_side(_displacement, _tl, _tr, _bl, _br):
	return (_displacement.angle() > _tl && _displacement.angle() < _tr) || (_displacement.angle() < _bl && _displacement.angle() > _br)

func set_marker_rotation() -> void:
	var angle = (global_position - indicator_holder.global_position).angle()
	indicator_holder.global_rotation = angle
	
	# fix the icon holder rotation
	icon.global_rotation = 0

func initIndicators() -> void:
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	set_marker_position(Rect2(top_left, size))
	set_marker_rotation()
