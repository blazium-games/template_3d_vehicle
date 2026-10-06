extends AutoworkTest

const Rules = preload("res://scripts/rules.gd")

func test_seed() -> void:
	var rules = Rules.new()
	assert_eq(rules.road_marks(3), rules.road_marks(3), "same seed")

func test_enter_once() -> void:
	var rules = Rules.new()
	assert_true(rules.try_enter(), "first enter")
	assert_false(rules.try_enter(), "already seated")
	rules.leave_seat()
	assert_true(rules.try_enter(), "after exit")

func test_drive_gate() -> void:
	var rules = Rules.new()
	assert_false(rules.drive_step(true), "not seated")
	assert_false(rules.may_stretch(), "no travel")
	assert_true(rules.try_enter(), "enter")
	assert_false(rules.try_enter(), "second enter")
	for _i in 6:
		assert_true(rules.drive_step(true), "throttle")
	assert_true(rules.may_stretch(), "end of road")
	rules.fuel = 0.0
	assert_false(rules.drive_step(true), "no fuel")
	assert_true(load("res://scenes/stretch.tscn") != null, "stretch loads")
