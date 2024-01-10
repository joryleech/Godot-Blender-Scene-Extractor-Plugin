
  
# **[Godot-Blender-Scene-Extractor-Plugin](https://github.com/joryleech/Godot-Blender-Scene-Extractor-Plugin)**
This plugin allows .blend files to be broken up into individual resource files within a single .blend file, allowing collections of models to maintain their connection to the file while being easy to drag into a scene.

## Installation
* Copy the contents of the ``/addons`` folder to your projects ``res://addons`` folder.
* Enable ``Blender Scene Extractor`` in ``Project > Project Settings > Plugins``
* (Note: If Blender imports are not configured, please follow [Godot's Documentation here](https://docs.godotengine.org/en/4.1/tutorials/assets_pipeline/importing_scenes.html#importing-blend-files-directly-within-godot).)

## Usage
* Instanciate your blend files node into a scene, by dragging the file from the res folder into the scene.
* Click on the newly instantiated node.
* In the inspector, two new buttons are available
	* Generate Individual Scenes
		* This will generate each model in the .blend file into a new scene with only the mesh renderer
	* Generate Individual Scenes (Static Body)
		* This will generate each scene with an additional static body and collision mesh
* All new scenes will be saved in a folder next to the models original folder.
	* EX: res://models/sample.blend will turn into res://models/sample/model1.tscn, etc.
  


## TODO List
None at this time

## License

The plugin is available as open source under the terms of the  [MIT License](https://opensource.org/licenses/MIT).
