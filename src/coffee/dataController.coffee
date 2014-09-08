# data controller
$(window).on "go", () ->
	d3.json("data/world-110m.json", (error, success) ->
		if not error
			window.app.data.world = success

			$(window).trigger "data-loaded"
	)
