extends TileMap

@onready var pick_up_box_area = $PickUpBoxArea

func _ready():
	pick_up_box_area.interact = Callable(self, "go_pick_up_box")

func go_pick_up_box():
	print("A box is picked up")
