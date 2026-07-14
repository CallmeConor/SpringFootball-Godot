extends Resource

class_name SpringData

var cPosition: float = 0
var cVelocity: float = 0
var cEquilibrium: float = 0

@export var frequency = 10
@export var damping_ratio = 0.2

func SpringData(position: float, velocity: float, equilibrium: float):
	cPosition = position
	cVelocity = velocity
	cEquilibrium = equilibrium

func AddVelocity(velocity: float):
	cVelocity += velocity

func GetVelocity() -> float:
	return cVelocity

func GetPosition() -> float:
	return cPosition

func SetEquilibrium(equilibrium: float):
	cEquilibrium = equilibrium

func GetEquilibrium():
	return cEquilibrium
