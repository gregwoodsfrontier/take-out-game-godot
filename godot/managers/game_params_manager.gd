extends Node

# temporary variable that checks if player has the package or not.
# subject to future changes.
var is_player_have_package = false: set = _set_player_package, get = _get_player_package

func _set_player_package(_new_state: bool) -> void:
	is_player_have_package = _new_state

func _get_player_package():
	return is_player_have_package
