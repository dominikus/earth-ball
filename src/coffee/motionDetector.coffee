# motion detector

$(window).on "map-ready", () ->
	handleOrientation = (orientData) ->
		absolute = orientData.absolute
		alpha = orientData.alpha
		beta = orientData.beta
		gamma = orientData.gamma

		window.app.data.orientation = {
			"absolute": absolute
			"alpha": alpha
			"beta": beta
			"gamma": gamma
		}

		$(window).trigger "orientation-changed"

	handleMotionEvent = (event) ->
		x = event.accelerationIncludingGravity.x
		y = event.accelerationIncludingGravity.y
		z = event.accelerationIncludingGravity.z

	window.addEventListener("deviceorientation", handleOrientation, true)
	window.addEventListener("devicemotion", handleMotionEvent, true)
