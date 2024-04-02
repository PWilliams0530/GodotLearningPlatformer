extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var player
var chase = false
var SPEED = 50

func _ready():
	get_node("AnimatedSprite2D").play("Idle")

func _physics_process(delta):
	#gravity for drog
	velocity.y += gravity * delta
	
	if chase == true:
		player = get_node("../../Player/Player")
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Jump")
		var direction = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("AnimatedSprite2D").flip_h = true #right
		else:
			get_node("AnimatedSprite2D").flip_h = false #left
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x = 0
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		print("in range")
		chase = true
		
func _on_player_detection_body_exited(body):
	if body.name == "Player":
		print("out of range")
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		body.health -= 3
		death()

func death():
		chase = false
		get_node("AnimatedSprite2D").play("Death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()
