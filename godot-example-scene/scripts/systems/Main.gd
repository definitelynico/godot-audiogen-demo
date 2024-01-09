extends Node3D


var cam: Camera3D

func _ready():
	cam = get_viewport().get_camera_3d()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		var mouse_pos = get_viewport().get_mouse_position()
		var from = cam.project_ray_origin(mouse_pos)
		var to = from + cam.project_ray_normal(mouse_pos) * 1000
		var space_state = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		ray_query.collision_mask = 2

		var result = space_state.intersect_ray(ray_query)
		if result and result.collider:
			var audio_player = result.collider.get_node("AudioStreamPlayer3D") as AudioStreamPlayer3D
			if audio_player and audio_player.stream != null:
				audio_player.play()
				print("Playing audio from: ", result.collider.name)
			else:
				print("No audio file present on %s" % result.collider.name)
