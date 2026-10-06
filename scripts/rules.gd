extends RefCounted

var seated := false

func road_marks(seed_value: int) -> PackedFloat32Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var marks := PackedFloat32Array()
	for _i in 5:
		marks.append(rng.randf_range(0.0, 4.0))
	return marks

func try_enter() -> bool:
	if seated:
		return false
	seated = true
	return true

func leave_seat() -> void:
	seated = false

var travel := 0.0
var fuel := 8.0

func drive_step(throttle: bool) -> bool:
	if not seated:
		return false
	if fuel <= 0.0:
		return false
	if throttle:
		fuel -= 1.0
		travel += 1.0
	return true

func may_stretch() -> bool:
	return travel >= 6.0
