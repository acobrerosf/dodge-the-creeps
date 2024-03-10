extends Area2D

signal hit

@export var speed = 400 # The @export keyword allows us to set its value in the Inspector
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector: (0,0)
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		# The player will move faster diagonally than if just horizontally.
		# We can prevent it by normalizing the velocity, which means we set its length to 1,
		# then multiply by the desired speed.
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Update player's position
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) # Prevent player from leaving the screen
	
	# Choose the right animation
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk" # Use the walk animation
		$AnimatedSprite2D.flip_v = false # We don't need to flip the animation vertically
		$AnimatedSprite2D.flip_h = velocity.x < 0 # Flip animation horizontally if moving to the left
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # Flip animation vertically if moving down


func _on_body_entered(body):
	hide() # Player disappears after being hit
	hit.emit()
	# Must be deferred as we can't change physis properties on a physics callback.
	# Disabling the area's collision shape can cause an error if it happens in the middle of the engine's collision processing.
	# Using set_deferred() tells Godot to wait to disable the shape until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true) # Disable player's collision so we don't trigger hit signal more than once

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
