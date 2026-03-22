extends CenterContainer

@export var ReticalDraw : Control
@warning_ignore("shadowed_global_identifier")
@export var WeaponController : WeaponController
@export var player_controller : PlayerController

# all the weapons
const MD_ARE_18 = preload("uid://d0mhjhy1536qp")
const MD_BMR_99 = preload("uid://cwb7ejvgbfthi")
const MD_P_11 = preload("uid://d2e3oxubj53dw")
const MD_RICO_KBM = preload("uid://bwnd6lufp0ey2")

# changes the crosshair based on the current weapon
func _process(_delta: float) -> void:
	if WeaponController.current_weapon == MD_ARE_18:
		ReticalDraw.set_crosshair_radius(15.0)
		ReticalDraw.set_crosshair_thickness(5.0)
		ReticalDraw.set_crosshair_gap_angle(100.0)
		ReticalDraw.set_crosshair_segments(10)
		if player_controller.zoomed_in:
			ReticalDraw.set_crosshair_radius(7.5)
	if WeaponController.current_weapon == MD_BMR_99:
		ReticalDraw.set_crosshair_radius(15.0)
		ReticalDraw.set_crosshair_thickness(4.0)
		ReticalDraw.set_crosshair_gap_angle(30.0)
		ReticalDraw.set_crosshair_segments(2)
		if player_controller.zoomed_in:
			ReticalDraw.set_crosshair_radius(7.5)
	if WeaponController.current_weapon == MD_P_11:
		ReticalDraw.set_crosshair_radius(15.0)
		ReticalDraw.set_crosshair_thickness(0.5)
		ReticalDraw.set_crosshair_gap_angle(45.0)
		ReticalDraw.set_crosshair_segments(16)
		if player_controller.zoomed_in:
			ReticalDraw.set_crosshair_radius(7.5)
	if WeaponController.current_weapon == MD_RICO_KBM:
		ReticalDraw.set_crosshair_radius(20.0)
		ReticalDraw.set_crosshair_thickness(20.0)
		ReticalDraw.set_crosshair_gap_angle(70.0)
		ReticalDraw.set_crosshair_segments(30)
		if player_controller.zoomed_in:
			ReticalDraw.set_crosshair_radius(10.0)
