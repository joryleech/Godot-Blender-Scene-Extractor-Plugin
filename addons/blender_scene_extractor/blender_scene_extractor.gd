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
		if(object is Node):
			return object.get_scene_file_path().contains(".blend")
		return false
		
	func pressed():
		generate_objects_scenes(node_object)
		
	func pressed_static_bodies():
		generate_objects_scenes_static(node_object)
		
	func pressed_mesh_library():
		generate_mesh_library(node_object, false)
		
	func pressed_mesh_library_with_collision():
		generate_mesh_library(node_object, true)
		
	func generate_folder(path):
		var dir = DirAccess.open("res://")
		if not dir.dir_exists_absolute (path):
			dir.make_dir_absolute(path)
		
	func generate_objects_scenes_static(node : Node):
		print("Generating Models")
		var folder = node.get_scene_file_path().replace(".blend", "/")
		generate_folder(folder)
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
		generate_folder(folder)
		for child in node.get_children():
			if(child is MeshInstance3D):
				var file_name = folder+child.name+".tscn"
				print("Generating Model: "+file_name)
				var packed_scene  = PackedScene.new()
				packed_scene.pack(child)
				ResourceSaver.save(packed_scene, file_name)
				
	func generate_mesh_library(node : Node, generate_collision : bool):
		print("Generating Mesh Library")
		var folder = node.get_scene_file_path().replace(".blend", "/")
		generate_folder(folder)
		var mesh_library : MeshLibrary = MeshLibrary.new()
		for child in node.get_children():
			if(child is MeshInstance3D):
				print("Adding Model: "+child.name)
				var index : int = mesh_library.get_last_unused_item_id()
				mesh_library.create_item(
					index
				)
				if(generate_collision):
					mesh_library.set_item_shapes(index, [child.mesh.create_trimesh_shape()])
				mesh_library.set_item_mesh(index, child.mesh)
				mesh_library
		var file_name = folder+node.name+"-ml.tres"
		print("Generated Mesh Library:"+file_name)
		var error : Error = ResourceSaver.save(mesh_library, file_name)
		
	func add_button(name : String, function):
		var button = Button.new()
		button.text = name
		button.pressed.connect(function)
		add_custom_control(button)
		
	func _parse_begin(object: Object) -> void:
		node_object = object

		add_button("Generate Individual Scenes", pressed)
		add_button("Generate Individual Scenes (Static Bodies)", pressed_static_bodies)
		add_button("Generate Mesh Library", pressed_mesh_library)
		add_button("Generate Mesh Library (With Collision)", pressed_mesh_library_with_collision)


