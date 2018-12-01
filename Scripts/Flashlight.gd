extends Light2D

var maxBattery = 5
var battery
var batteryRechargingFactor = 0.5
var batteryRechargeDelay = 2
var timeToRecharge

func _ready():
	timeToRecharge = batteryRechargeDelay
	battery = maxBattery


func _process(delta):
	var flashlightActive = Input.is_action_pressed('flashlight') && battery > 0
	timeToRecharge = batteryRechargeDelay if flashlightActive else timeToRecharge - delta
	if flashlightActive:
		battery -= delta
	elif timeToRecharge <= 0:
		battery += delta * batteryRechargingFactor
	battery = clamp(battery, -maxBattery, maxBattery)
	set_activated(flashlightActive)


func is_activated():
	return is_enabled()


func set_activated(activation):
	set_enabled(activation)

