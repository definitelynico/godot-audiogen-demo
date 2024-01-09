from flask import Flask, request, jsonify, send_from_directory
import torchaudio
from audiocraft.models import AudioGen
from audiocraft.data.audio import audio_write
import os
import shutil

# The model used for this experiment can be found at:
# https://github.com/facebookresearch/audiocraft
# https://huggingface.co/facebook/audiogen-medium

# Follow the instructions and create a venv for the model
# then you could hopefully just run this file and fire up Godot

app = Flask(__name__)

# Load the AudioGen model
model = AudioGen.get_pretrained('facebook/audiogen-medium')
model.set_generation_params(duration=5)  # Set the duration for generation

@app.route('/generate_audio', methods=['POST'])
def generate_audio():
    print('Request started...')

    # Remove the existing 'generated' directory and recreate it
    if os.path.exists('generated'):
        shutil.rmtree('generated')
    os.mkdir('generated')

    prompts = request.json.get('prompts', [])
    if not prompts:
        return jsonify({'error': 'Invalid JSON. Missing "prompts" field.'}), 400

    responses = []

    # Generate audio for each prompt
    wav = model.generate(prompts)

    for idx, one_wav in enumerate(wav):
        filename = str(idx)  # Just use the index as the filename
        filepath = os.path.join('generated', filename)  # This becomes 'generated/0', 'generated/1', etc.

        # Save audio file with loudness normalization
        audio_write(filepath, one_wav.cpu(), model.sample_rate, strategy="loudness", loudness_compressor=True)

        responses.append({
            'prompt': prompts[idx],
            'filename': filename + '.wav'  # Append '.wav' here for the response
        })

        print(f"Processed prompt {idx + 1} of {len(prompts)} - {prompts[idx]}")

    return jsonify(responses), 200

@app.route('/get_audio/<filename>', methods=['GET'])
def get_audio(filename):
    # Add basic validation for filename
    if '..' in filename or '/' in filename:
        return "Invalid file name", 400
    print(filename)
    return send_from_directory('generated', filename)

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)

