extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Play the animation and randomly choose one of the three animation types.
	# The property "sprite_frames" returns an array: ["walk", "swim", "fly"]
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()]) # randi() % n selects a random integer between 0 and n-1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Delete the enemy when they leave the screen.
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
