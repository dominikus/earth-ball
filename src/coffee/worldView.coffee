# world view

# partially based on Mike's World Tour:
# http://bl.ocks.org/mbostock/4183330

$(window).on "data-loaded", () ->

	[width, height, projection, canvas, c, path, graticule] = [undefined]
	[globe, world, land, countries, borders] = [undefined]

	setup = () ->
		width = $("#vis").width()
		height = $("#vis").width()

		projection = d3.geo.orthographic()
			.translate([width/2, height/2])
			.scale(width / 2)
			.clipAngle(90)

		canvas = d3.select("#vis").append("canvas")
			.attr({
				"width": width
				"height": height
				})

		c = canvas.node().getContext("2d")

		graticule = d3.geo.graticule()

		path = d3.geo.path()
			.projection(projection)
			.context(c)

		globe = {type: "Sphere"}
		world = window.app.data.world
		land = topojson.feature(world, world.objects.land)
		countries = topojson.feature(world, world.objects.countries).features
		borders = topojson.mesh(world, world.objects.countries, (a,b) -> a != b)

		# show warning for non-mobile users
		c.font = "20px Dosis"
		c.fillText("BEST VIEWED ON ", 0, 50)
		c.fillText("PORTABLE DEVICES", 0, 80)
		c.fillText("(SERIOUSLY)", 0, 110)

		$(window).trigger "map-ready"

	render = () ->
		console.log "render"
		# get orientation
		orientation = window.app.data.orientation

		if orientation? and orientation.beta? and orientation.gamma? and orientation.alpha?
			#projection.rotate([orientation.gamma, -orientation.beta])
			#projection.rotate([orientation.gamma, -orientation.beta, orientation.alpha])
			projection.rotate([-orientation.gamma, orientation.beta, -orientation.alpha])
		else
			i = 1
			p = d3.geo.centroid(countries[i])
			projection.rotate([-p[0], -p[1]])

		c_ocean = "#91cde3"
		c_land = "#FF8400"
		c_background = "#3C3C3C"

		c.fillStyle = c_background
		c.clearRect(0,0, width, height)


		c.fillStyle = c_ocean
		c.beginPath()
		path(globe)
		c.fill()

		c.fillStyle = c_land
		c.strokeStyle = "white"
		c.lineWidth = 2
		c.beginPath()
		path(land)
		c.fill()
		c.stroke()

		c.strokeStyle = "white"
		c.lineWidth = .5
		c.beginPath()
		path(graticule())
		c.stroke()

		c.strokeStyle = "white"
		c.lineWidth = .5
		c.beginPath()
		path(globe)
		c.stroke()


	setup()
	$(window).on "orientation-changed", render
