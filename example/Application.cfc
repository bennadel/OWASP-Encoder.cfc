component 
	output = "false"
	hint = "I define the applications settings and event handlers."
	{

	// Define the application settings.
	this.name = hash( getCurrentTemplatePath() );
	this.applicationTimeout = createTimeSpan( 0, 0, 10, 0 );

	// Get the current directory and the root directory.
	this.appDirectory = getDirectoryFromPath( getCurrentTemplatePath() );
	this.projectDirectory = ( this.appDirectory & "../" );

	// Map the lib directory so we can create our components.
	this.mappings[ "/lib" ] = ( this.projectDirectory & "lib/" );
	this.mappings[ "/jars" ] = ( this.projectDirectory & "jars/" );

	// Set up the custom JAR files for this ColdFusion application.
	this.javaSettings = {
		loadPaths: [
			this.mappings[ "/jars" ]
		],
		loadColdFusionClassPath: false,
		reloadOnChange: false
	};

}