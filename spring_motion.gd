class_name spring_motion

	# <summary>
	# Calculate a spring motion development for a given deltaTime quickly without 
	# considering corner cases for dampingRatio or angularFrequency 
	# </summary>
	# <param name="position">"Live" position value</param>
	# <param name="velocity">"Live" velocity value</param>
	# <param name="equilibriumPosition">Goal (or rest) position</param>
	# <param name="deltaTime">Time to update over</param>
	# <param name="angularFrequency">Angular frequency of motion</param>
	# <param name="dampingRatio">Damping ratio of motion</param>
static func CalcDampedSimpleHarmonicMotionFast(cPosition: float, cVelocity: float, cEquilibrium: float, deltaTime: float, angularFrequency: float, dampingRatio: float) -> void:
		print("Internal start - Pos: ", cPosition, ". Vel: ", cVelocity)
		var x: float = cPosition - cEquilibrium
		print("Internal start - X: ", x, ". Eq Pos: ", cEquilibrium)
		cVelocity = cVelocity + (-dampingRatio * cVelocity) - (angularFrequency * x)
		print("Internal start - Vel: ", cVelocity, ". Damp Rat: ", dampingRatio)
		cPosition = cPosition + cVelocity * deltaTime
		print("Internal end - Pos: ", cPosition, ". Vel: ", cVelocity)
	# <summary>
	# Calculate a spring motion development for a given deltaTime quickly without 
	# considering corner cases for dampingRatio or angularFrequency 
	# </summary>
	# <param name="position">"Live" position value</param>
	# <param name="velocity">"Live" velocity value</param>
	# <param name="equilibriumPosition">Goal (or rest) position</param>
	# <param name="deltaTime">Time to update over</param>
	# <param name="angularFrequency">Angular frequency of motion</param>
	# <param name="dampingRatio">Damping ratio of motion</param>
static func CalcDampedSimpleHarmonicMotionFastV2(position: Vector2, velocity: Vector2, equilibriumPosition: Vector2, deltaTime: float, angularFrequency: float, dampingRatio: float) -> void:
		var x = position - equilibriumPosition
		velocity += (-dampingRatio * velocity) - (angularFrequency * x)
		position += velocity * deltaTime

	# <summary>
	# Calculate a spring motion development for a given deltaTime quickly without 
	# considering corner cases for dampingRatio or angularFrequency 
	# </summary>
	# <param name="position">"Live" position value</param>
	# <param name="velocity">"Live" velocity value</param>
	# <param name="equilibriumPosition">Goal (or rest) position</param>
	# <param name="deltaTime">Time to update over</param>
	# <param name="angularFrequency">Angular frequency of motion</param>
	# <param name="dampingRatio">Damping ratio of motion</param>
static func CalcDampedSimpleHarmonicMotionFastV3(position: Vector3, velocity: Vector3, equilibriumPosition: Vector3, deltaTime: float, angularFrequency: float, dampingRatio: float) -> void:
		var x = position - equilibriumPosition
		velocity += (-dampingRatio * velocity) - (angularFrequency * x)
		position += velocity * deltaTime
