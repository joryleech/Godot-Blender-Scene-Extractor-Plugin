@tool
extends EditorPlugin

var editor_button_plugin:SceneExtractorButtonsPlugin


func _enter_tree() -> void:
	editor_button_plugin = SceneExtractorButtonsPlugin.new()
	add_inspector_plugin(editor_button_plugin)


func _exit_tree() -> void:
	if is_instance_valid(editor_button_plugin):
		remove_inspector_plugin(editor_button_plugin)
		editor_button_plugin = null


class SceneExtractorButtonsPlugin extends EditorInspectorPlugin:
	var node_object
	func _can_handle(object: Object) -> bool:
		print(object.get_scene_file_path())
		if(object is Node):
			print(object.get_scene_file_path())
			return object.get_scene_file_path().contains(".blend")
		return false
		
	func pressed():
		generate_objects_scenes(node_object)
		
	func pressed_static_bodies():
		generate_objects_scenes_static(node_object)
	
	func generate_objects_scenes_static(node : Node):
		print("Generating Models")
		var folder = node.get_scene_file_path().replace(".blend", "/")
		for child in node.get_children():
			if(child is MeshInstance3D):
				var file_name = folder+child.name+".tscn"
				print("Generating Model: "+file_name)
				var packed_scene  = PackedScene.new()
				var cloned_child = child.duplicate()

				#static_body.add_child(cloned_child)
				cloned_child.owner = cloned_child
				(cloned_child as MeshInstance3D).create_trimesh_collision()
				cloned_child.get_child(0).owner = cloned_child
				cloned_child.get_child(0).get_child(0).owner = cloned_child
				
				packed_scene.pack(cloned_child)
				ResourceSaver.save(packed_scene, file_name)
				cloned_child.queue_free()
				
	func generate_objects_scenes(node : Node):
		print("Generating Models")
		var folder = node.get_scene_file_path().replace(".blend", "/")
		for child in node.get_children():
			if(child is MeshInstance3D):
				var file_name = folder+child.name+".tscn"
				print("Generating Model: "+file_name)
				var packed_scene  = PackedScene.new()
				packed_scene.pack(child)
				ResourceSaver.save(packed_scene, file_name)
		
	func _parse_begin(object: Object) -> void:
		node_object = object
		var button = Button.new()
		button.text = "Generate Individual Scenes"
		button.pressed.connect(pressed)
		add_custom_control(button)
		var button_with_collision = Button.new()
		button_with_collision.text = "Generate Individual Scenes (Static Bodies)"
		button_with_collision.pressed.connect(pressed_static_bodies)
		add_custom_control(button_with_collision)

