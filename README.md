# What is this?
This is a silly little project where I use AudioGen (from https://github.com/facebookresearch/audiocraft) to generate SFX in real time in a simple demo scene in Goddot. I didn't have any expectations when first starting except getting some funny, crazy and weird stuff. The setup is quite simple; I created a simple dummy-API using Flask which took a already created audio file, renamed it to whatever request was being made, then returned the "generated" audio file on a GET request. This was only done because I didn't have access to a powerful enough GPU at the time, so I had to emulate the desired functionality.

In Godot, I wanted to follow the native (ECS-like) pattern and have a separate component to put on thing you want to make noise; the AudioComponent.
  
![AudioComponent](img/audio_component.png)&nbsp;![AudioComponent Inspector](img/audio_component_data.png)
