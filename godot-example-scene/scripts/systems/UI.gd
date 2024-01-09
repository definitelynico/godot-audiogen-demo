extends CanvasLayer

@onready var label: Label = get_node("Label")

var time: float

func _process(delta):
	time += delta
	label.text = format_time(time)

func format_time(_time: float) -> String:
	var minutes: int = int(time / 60)
	var seconds: int = int(time) % 60
	return "%02d:%02d" % [minutes, seconds]
