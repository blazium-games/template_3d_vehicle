extends Node3D

const Rules = preload("res://scripts/rules.gd")
var rules = Rules.new()

@onready var walker: CharacterBody3D = $Walker
@onready var seat: MeshInstance3D = $Seat

func _ready() -> void:
	var marks := rules.road_marks(3)
	var cursor := 0.0
	for mark in marks:
		var slab := MeshInstance3D.new()
		var box_mesh := BoxMesh.new()
		box_mesh.size = Vector3(2, 0.1, 1 + mark)
		slab.mesh = box_mesh
		slab.position = Vector3(0, 0.05, cursor)
		add_child(slab)
		cursor -= 3.0

func _physics_process(_delta: float) -> void:
	if rules.seated:
		var throttle := Input.is_action_pressed("stride_north")
		if rules.drive_step(throttle):
			seat.position.z -= 0.15 if throttle else 0.0
		if rules.may_stretch():
			_go("res://scenes/stretch.tscn")
		return
	var wish := Vector2(
		Input.get_action_strength("stride_east") - Input.get_action_strength("stride_west"),
		Input.get_action_strength("stride_south") - Input.get_action_strength("stride_north")
	)
	walker.velocity.x = wish.x * 3.0
	walker.velocity.z = wish.y * 3.0
	if not walker.is_on_floor():
		walker.velocity.y -= 12.0 * _delta
	walker.move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary"):
		if rules.seated:
			rules.leave_seat()
			walker.visible = true
		elif rules.try_enter():
			walker.global_position = seat.global_position + Vector3(0, 0.8, 0)
			walker.visible = false

func _go(next_path: String) -> void:
	get_tree().change_scene_to_file(next_path)
