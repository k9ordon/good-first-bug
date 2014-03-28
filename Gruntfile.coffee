# http://tbranyen.com/post/coffeescript-has-the-ideal-syntax-for-configurations

module.exports = ->

	@initConfig

		jshint:
			files: ["js/_*.js"]
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

		less:
			build:
				files:
					'.tmp/build_less/bootstrap.css': 'bower_components/bootstrap/less/bootstrap.less',
					'.tmp/build_less/app.css': 'less/app.less'

		connect:
			server:
				options:
					port: 9001,
					base: 'dist',
					keepalive: true

	@loadNpmTasks "grunt-contrib-copy"
	@loadNpmTasks "grunt-contrib-concat"
	@loadNpmTasks "grunt-contrib-cssmin"
	@loadNpmTasks "grunt-contrib-uglify"
	@loadNpmTasks "grunt-contrib-less"
	@loadNpmTasks "grunt-contrib-jshint"
	@loadNpmTasks "grunt-contrib-connect"
	@loadNpmTasks "grunt-usemin"

	@registerTask "build", [
		"copy:buildHtml",
		"less",
		"useminPrepare",
		"concat",
		"cssmin",
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
