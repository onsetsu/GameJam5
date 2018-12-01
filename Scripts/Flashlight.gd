extends Light2D

var maxBattery = 5
var battery
var batteryRechargingFactor = 1.25
var batteryRechargeDelay = 0.4
var timeToRecharge

func _ready():
	timeToRecharge = batteryRechargeDelay
	battery = maxBattery
	$PointLight.set_color(get_color())
	$CanvasLayer/BatteryStatus.set_max(maxBattery)
	$CanvasLayer/BatteryStatus.set_min(0)


func _process(delta):
	var flashlightActive = Input.is_action_pressed('flashlight') && battery > 0
	timeToRecharge = batteryRechargeDelay if flashlightActive else timeToRecharge - delta
	if flashlightActive:
		battery -= delta
	elif timeToRecharge <= 0:
		battery += delta * batteryRechargingFactor
	battery = clamp(battery, -maxBattery, maxBattery)
	set_energy(clamp(battery, 0, 1))
	set_activated(flashlightActive)
	$CanvasLayer/BatteryStatus.set_value(battery)


func is_activated():
	return is_enabled()


func set_activated(activation):
	set_enabled(activation)
	$PointLight.set_enabled(activation)

