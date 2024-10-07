extends Node2D

@export var projectile : PackedScene
@export var rotate_speed : int
@export var speedbar_speed : int
@export var min_velocity : int = 800
@export var max_velocity : int = 1400

var clockwise = true # Current "direction" of the turret.
var increasing = true # Current "direction" of the speedbar.
# When num_clicks is 1, the angle has been set.
# When num_clicks is 2, the speed has been set.
var num_clicks = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($"Turret Control/Spawnpoint".position)
	match num_clicks:
		0:
			rotate_cannon(delta)
		1:
			change_speed(delta)
		2:
			shoot_projectile()
			num_clicks = 1 # Go back to change speed.  Testing!
			#num_clicks = 4 # Stop paying attention to clicks.

func rotate_cannon(delta):
	if clockwise:
		$"Turret Control".rotation_degrees += rotate_speed*delta
	else:
		$"Turret Control".rotation_degrees -= rotate_speed*delta
	
	if $"Turret Control".rotation_degrees > 15:
		clockwise = false
	if $"Turret Control".rotation_degrees < -85:
		clockwise = true

func change_speed(delta):
	if increasing:
		$Speedbar.value += delta*speedbar_speed
	else:
		$Speedbar.value -= delta*speedbar_speed
		
	if $Speedbar.value >= 100:
		increasing = false
	if $Speedbar.value <= 0:
		increasing = true

func shoot_projectile():
	var newProjectile = projectile.instantiate()
	var velocity = min_velocity + (max_velocity - min_velocity)*$Speedbar.value/100
	print(velocity)
	newProjectile.linear_velocity = Vector2(cos($"Turret Control".rotation), sin($"Turret Control".rotation))*max_velocity*$Speedbar.value
	newProjectile.linear_velocity = Vector2(cos($"Turret Control".rotation), sin($"Turret Control".rotation))*velocity
	$"Turret Control/Spawnpoint".add_child(newProjectile)
	
	#print(str($"Turret Control".rotation_degrees) + " " + str(x) + " " + str(y))
	#print(Vector2(100, 0).rotated($"Turret Control".rotation))
	#newProjectile.apply_force(Vector2(100, 0).rotated($"Turret Control".rotation))
	

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			num_clicks += 1
			#print(num_clicks)
