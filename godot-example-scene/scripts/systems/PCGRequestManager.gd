extends Node


const GENERATE_AUDIO_URL: String = "http://127.0.0.1:5000/generate_audio"
const GET_AUDIO_FILES_URL: String = "http://127.0.0.1:5000/get_audio/"

var prompts: Array[String]
var acs: Array[AudioComponent]

func _ready() -> void:
	for ac in get_tree().get_nodes_in_group("audio_components"):
		if ac is AudioComponent:
			if ac.prompt != "":
				prompts.append(ac.prompt)
				acs.append(ac)

	print(acs)
	_queue_generation_request(prompts)

func _queue_generation_request(prompt_data: Array[String]) -> void:
	if prompts.is_empty():
		print("No prompts, returning...")
		return
	else:
		var http_request: HTTPRequest = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_http_request_completed)
		
		var headers = ["Content-Type: application/json"]
		var data = {"prompts": prompt_data}
		var json_string = JSON.stringify(data)

		http_request.request(GENERATE_AUDIO_URL, headers, HTTPClient.METHOD_POST, json_string)
		print("Query HTTP request started...")

func _http_request_completed(result, response_code, _headers, _body) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Failed to start audio generation")
		return
	
	if response_code == 200:
		for i in acs.size():
			acs[i]._query_and_assign_audio(GET_AUDIO_FILES_URL, i)
