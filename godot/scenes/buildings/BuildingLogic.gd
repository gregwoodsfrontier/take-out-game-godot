extends Node2D

@onready var interaction_area = get_parent().get_node("InteractionArea")
@onready var off_screen_indicator = get_parent().get_node("OffScreenIndicator")

enum BuildingType {
	DELIVER,
	RECEIVE
}

@export var building_type: int = BuildingType.DELIVER

func _ready():
	if building_type == BuildingType.DELIVER:
		interaction_area.interact = Callable(self, "_hand_over_package")
	else:
		interaction_area.interact = Callable(self, "_receive_package")
	
	printt(BuildingType.DELIVER, " is the type of building.")
	printt(" is the type of building.")
	
		
	off_screen_indicator.connect("indicator_inbound", _on_indicator_inbound)
	#off_screen_indicator.connect("indicator_outbound", _on_indicator_outbound)

func _process(_delta):
	# the indicator display logic also depends the type of building the node is on
	# 
	# if the player has the package, hide the off screen indicator
	_determine_indicator_display(building_type)

func _determine_indicator_display(_building_type: int) -> void:
	if building_type == BuildingType.DELIVER:
		if GameParamsManager._get_player_package():
			off_screen_indicator.hide()
		else:
			off_screen_indicator.show()
	# the type is a receiver
	else:
		if GameParamsManager._get_player_package():
			off_screen_indicator.show()
		else:
			off_screen_indicator.hide()

func _hand_over_package() -> void:
	GameParamsManager._set_player_package(true)

func _receive_package() -> void:
	GameParamsManager._set_player_package(false)

# the indicator is hidden regardless of package
func _on_indicator_inbound():
	off_screen_indicator.hide()

# the indicator is shown to player, unless the package has been collected.
func _on_indicator_outbound():
	_determine_indicator_display(building_type)
