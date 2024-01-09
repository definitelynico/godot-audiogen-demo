from flask import Flask, request, jsonify, send_from_directory
import os
import shutil
import time

app = Flask(__name__)

@app.route('/generate_audio', methods=['POST'])
def generate_audio():
    print('Request started...')
    # Remove existing files in the generated folder
    shutil.rmtree('generated')
    os.mkdir('generated')

    prompts = request.json.get('prompts', [])
    responses = []

    for idx, prompt in enumerate(prompts):
        # Simulate processing delay
        time.sleep(2)

        filename = f'{idx}.wav'

        original_file_path = os.path.join('audio', 'demo_audio.wav')
        temp_file_path = os.path.join('generated', f'temp_{filename}')
        final_file_path = os.path.join('generated', filename)

        # Copy the demo audio to a temporary file, temp solution, fix later
        shutil.copy2(original_file_path, temp_file_path)

        os.rename(temp_file_path, final_file_path)

        responses.append({
            'prompt': prompt,
            'filename': filename
        })

        print(f"Processed prompt {idx + 1} of {len(prompts)} - {prompt}")

    if not prompts:
        return jsonify({'error': 'Invalid JSON. Missing "prompts" field.'}), 400

    return jsonify(responses), 200

@app.route('/get_audio/<filename>', methods=['GET'])
def get_audio(filename):
    return send_from_directory('generated', filename)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)
