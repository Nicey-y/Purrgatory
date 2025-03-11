extends CharacterBody2D
class_name EnemyFrog

const MAX_COOLDOWN_TICK = 20
var cooldownTick = MAX_COOLDOWN_TICK
var isInCooldown = false

const SPEED = 50.0
var direction:Vector2 = Vector2.RIGHT

const DAMAGE = 1
var health = 10

var detectedByPlayer = false

var facing_right_tex = load("res://resources/sprites/frog.png")
var facing_left_tex = load("res://resources/sprites/frog_facing_left.png")
var isFacingRight = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_wall():
		if direction == Vector2.RIGHT:
			direction = Vector2.LEFT

		else:
			direction = Vector2.RIGHT
		switch_texture()
	
	velocity.x = SPEED * direction.x

	move_and_slide()
	
func _process(float):
	if detectedByPlayer and health > 0:
		if Input.is_action_pressed("attack") and not isInCooldown:
			takes_damage(PlayerCat.RAW_DAMAGE)
			print("Dealt damage on Enemy")
			isInCooldown = true
			if health <= 0: 
				queue_free()
	
	trigger_cooldown_clock()

func trigger_cooldown_clock():
	if isInCooldown:
		if cooldownTick == 0:
			# reset clock
			cooldownTick = MAX_COOLDOWN_TICK
			isInCooldown = false
		else:
			cooldownTick = cooldownTick - 1

func takes_damage(damage):
	if health > 0:
		health = health - damage
	else:
		print("Enemy dead")

func _on_damagable_body_entered(body: Node2D) -> void:
	detectedByPlayer = true

func _on_damagable_body_exited(body: Node2D) -> void:
	detectedByPlayer = false

func switch_texture():
	if isFacingRight:
		isFacingRight = false
		$Sprite2D.texture = facing_left_tex
	else:
		isFacingRight = true
		$Sprite2D.texture = facing_right_tex
