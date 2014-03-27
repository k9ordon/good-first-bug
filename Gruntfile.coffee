# http://tbranyen.com/post/coffeescript-has-the-ideal-syntax-for-configurations
module.exports = ->

	# Initialize the configuration.
	@initConfig

		jshint:
			files: ["backbone.layoutmanager.js","node/index.js"]
			options:
				browser: true
				boss: true

		useminPrepare:
			html: 'index.html',
			options:
				dest: 'dist'

		usemin:
			html: ['dist/index.html']

		copy:
			buildHtml:
				src: 'index.html', dest: 'dist/index.html'

		connect:
			server:
				options:
					port: 9001,
					base: 'dist',
					keepalive: true

	# Load external Grunt task plugins.
	@loadNpmTasks "grunt-contrib-copy"
	@loadNpmTasks "grunt-contrib-concat"
	@loadNpmTasks "grunt-contrib-cssmin"
	@loadNpmTasks "grunt-contrib-uglify"

	@loadNpmTasks "grunt-contrib-jshint"
	@loadNpmTasks "grunt-contrib-connect"
	@loadNpmTasks "grunt-usemin"


	@registerTask "build", [
		"copy:buildHtml",
		"useminPrepare",
		"concat",
	#	"cssmin",
		"uglify",
		"usemin"
	]

	@registerTask "up", [
		"jshint",
		"build",
		"connect"
	]

	@registerTask "default", [
		"jshint",
		"build"
	]
