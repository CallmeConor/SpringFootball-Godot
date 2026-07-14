class_name SpringMotion

class damped_spring_motion_parameters:
	var posPosCoef: float
	var posVelCoef: float
	var velPosCoef: float
	var velVelCoef: float

static func calc_damped_simple_harmonic_motion(spring: SpringData, deltaTime):
	var motionParams: damped_spring_motion_parameters = calc_damped_spring_motion_parameters(deltaTime, spring.frequency, spring.damping_ratio)
	var updated_spring: SpringData = update_damped_spring_motion(spring, motionParams)
	spring.cPosition = updated_spring.cPosition
	spring.cVelocity = updated_spring.cVelocity
	spring.cEquilibrium = updated_spring.cEquilibrium

static func calc_damped_spring_motion_parameters(deltaTime, angularFrequency, dampingRatio) -> damped_spring_motion_parameters:
	var pOutParams = damped_spring_motion_parameters.new()

	var epsilon: float = 0.0001

	dampingRatio = clampf(dampingRatio, 0, dampingRatio)
	angularFrequency = clampf(angularFrequency, 0, angularFrequency)

	if angularFrequency < epsilon:
		pOutParams.posPosCoef = 1.0
		pOutParams.posVelCoef = 0.0
		pOutParams.velPosCoef = 0.0
		pOutParams.velVelCoef = 1.0
		return pOutParams

	if dampingRatio > 1.0 + epsilon:
		# over-damped
		var za: float = -angularFrequency * dampingRatio
		var zb: float = angularFrequency * sqrt(dampingRatio * dampingRatio - 1.0)
		var z1: float = za - zb
		var z2: float = za + zb

		# Value e (2.7) raised to a specific power
		var e1: float = exp(z1 * deltaTime)
		var e2: float = exp(z2 * deltaTime)

		var invTwoZb: float = 1.0 / (2.0 * zb)

		var e1_Over_TwoZb: float = e1 * invTwoZb
		var e2_Over_TwoZb: float = e2 * invTwoZb

		var z1e1_Over_TwoZb: float = z1 * e1_Over_TwoZb
		var z2e2_Over_TwoZb: float = z2 * e2_Over_TwoZb

		pOutParams.posPosCoef = e1_Over_TwoZb * z2 - z2e2_Over_TwoZb + e2
		pOutParams.posVelCoef = -e1_Over_TwoZb + e2_Over_TwoZb

		pOutParams.velPosCoef = (z1e1_Over_TwoZb - z2e2_Over_TwoZb + e2) * z2
		pOutParams.velVelCoef = -z1e1_Over_TwoZb + z2e2_Over_TwoZb

	elif dampingRatio < 1.0 - epsilon:
		# under-damped
		var omegaZeta: float = angularFrequency * dampingRatio;
		var alpha: float = angularFrequency * sqrt(1.0 - dampingRatio * dampingRatio)

		var expTerm: float = exp(-omegaZeta * deltaTime)
		var cosTerm: float = cos(alpha * deltaTime)
		var sinTerm: float = sin(alpha * deltaTime)

		var invAlpha: float = 1.0 / alpha

		var expSin: float = expTerm * sinTerm
		var expCos: float = expTerm * cosTerm
		var expOmegaZetaSin_Over_Alpha: float = expTerm * omegaZeta * sinTerm * invAlpha

		pOutParams.posPosCoef = expCos + expOmegaZetaSin_Over_Alpha
		pOutParams.posVelCoef = expSin * invAlpha

		pOutParams.velPosCoef = -expSin * alpha - omegaZeta * expOmegaZetaSin_Over_Alpha
		pOutParams.velVelCoef = expCos - expOmegaZetaSin_Over_Alpha

	else:
		# critically damped
		var expTerm: float = exp(-angularFrequency * deltaTime)
		var timeExp: float = deltaTime * expTerm
		var timeExpFreq: float = timeExp * angularFrequency

		pOutParams.posPosCoef = timeExpFreq + expTerm
		pOutParams.posVelCoef = timeExp

		pOutParams.velPosCoef = -angularFrequency * timeExpFreq
		pOutParams.velVelCoef = -timeExpFreq + expTerm

	return pOutParams

static func update_damped_spring_motion(spring: SpringData, damped_motion_parameters: damped_spring_motion_parameters) -> SpringData:
	var oldPos: float = spring.cPosition - spring.cEquilibrium # update in equilibrium relative space
	var oldVel: float = spring.cVelocity

	spring.cPosition = oldPos * damped_motion_parameters.posPosCoef + oldVel * damped_motion_parameters.posVelCoef + spring.cEquilibrium
	spring.cVelocity = oldPos * damped_motion_parameters.velPosCoef + oldVel * damped_motion_parameters.velVelCoef

	return spring

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
static func calc_damped_simple_harmonic_motion_fast(spring: SpringData, deltaTime: float) -> SpringData:
	var x: float = spring.cPosition - spring.cEquilibrium
	spring.cVelocity += (-spring.damping_ratio * spring.cVelocity) - (spring.frequency * x)
	spring.cPosition += spring.cVelocity * deltaTime
	return spring

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
