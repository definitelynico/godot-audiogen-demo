class_name AudioComponent
extends Node


## Prompt for the audio to be generated.
@export var prompt: String

## The audio player 3D to use for playback.
var audio_player: AudioStreamPlayer3D

func _ready():
	audio_player = get_parent().get_node("AudioStreamPlayer3D")

func _query_and_assign_audio(_url: String, index: int) -> void:
	var idx = str(index)
	var http_request: HTTPRequest = HTTPRequest.new()
	var file_path = String("user://" + idx + ".wav")
	add_child(http_request)
	http_request.download_chunk_size = 4096
	http_request.download_file = file_path
	var url = _url + idx + ".wav"
	http_request.request(url)
	print("Starting request for: {name}".format({"name": get_parent().name}))

	var res = await http_request.request_completed
	
	if res[1] != 200:
		print("Error: {e}".format({"e": res[1]}))
		return
	else:
		var file = FileAccess.open(file_path, FileAccess.READ)
		var wav_file = AudioStreamWAV.new()
		wav_file.format = AudioStreamWAV.FORMAT_16_BITS
		wav_file.mix_rate = 16000
		#wav_file.stereo = true # most annoying "bug" ever... this effects playback rate
		wav_file.data = file.get_buffer(file.get_length())
		file.close()
		audio_player.stream = wav_file
		
		print("{audio} assigned to {name}".format({"audio": idx + ".wav", "name": get_parent().name}))
