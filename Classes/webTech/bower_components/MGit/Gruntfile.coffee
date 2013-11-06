'use strict'

module.exports = (grunt) ->
	# load all grunt tasks
	require('matchdep').filterDev('grunt-*').forEach (task) ->
		grunt.log.ok [task + " is loaded"]
		grunt.loadNpmTasks task
		return

	config =
		build: '.build'
		src: ''

	# Project configuration.
	grunt.initConfig
		config: config

		gruntfile:
			src: 'Gruntfile.coffee'

		coffee:
			main:
				files: [
					expand: true
					cwd: '<%= config.src %>'
					src: ['{,*/}*.coffee', '!Gruntfile.coffee']
					dest: '<%= config.build %>'
					ext: '.js'
				]

		concat:
			main:
				options:
					separator: ';'
				src: ['<%= config.build %>/MGit.js', 'submodules/node-uuid/uuid.js']
				dest: '<%= config.build %>/MGit.js'

		jshint:
			options:
				jshintrc: '.jshintrc'

		watch:
		#	gruntfile:
				# files: '<%= jshint.gruntfile.src %>'
				# tasks: ['jshint:gruntfile']

			main:
				files: '<%= config.src %>/*'
				tasks: ['default']



	# Default task.
	grunt.registerTask 'default', ['coffee', 'concat']

	grunt.registerTask 'watch', ['watch']

	return
