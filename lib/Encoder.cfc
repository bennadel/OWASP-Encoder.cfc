component
	output = false
	hint = "I provide a simple wrapper to the OWASP Java Encoder that handles proper Java-casting."
	{

	/**
	* I initialize the wrapper around the given OWASP Java class.
	* 
	* @owaspEncoder I am the OWASP Java encoder.
	* @output false
	*/
	public any function init( required any owaspEncoder ) {

		encoder = owaspEncoder;

		return( this );

	}


	// ---
	// PUBLIC METHODS.
	// ---


	// All of the .encodeCONTEXT() Java methods use the same (String)::String signature
	// and can, therefore, all be implemented using the encodeForCurrentContext() private 
	// method. The encodeForCurrentContext() method will determine the correct context 
	// at runtime when the individual methods are invoked.
	this.forCDATA = encodeForCurrentContext;
	this.forCssString = encodeForCurrentContext;
	this.forCssUrl = encodeForCurrentContext;
	this.forHtml = encodeForCurrentContext;
	this.forHtmlAttribute = encodeForCurrentContext;
	this.forHtmlContent = encodeForCurrentContext;
	this.forHtmlUnquotedAttribute = encodeForCurrentContext;
	this.forJava = encodeForCurrentContext;
	this.forJavaScript = encodeForCurrentContext;
	this.forJavaScriptAttribute = encodeForCurrentContext;
	this.forJavaScriptBlock = encodeForCurrentContext;
	this.forJavaScriptSource = encodeForCurrentContext;
	this.forUri = encodeForCurrentContext;
	this.forUriComponent = encodeForCurrentContext;
	this.forXml = encodeForCurrentContext;
	this.forXmlAttribute = encodeForCurrentContext;
	this.forXmlComment = encodeForCurrentContext;
	this.forXmlContent = encodeForCurrentContext;


	// ---
	// PRIVATE METHODS.
	// ---


	/**
	* I take the given string and encode it for the context as defined by the method 
	* name at runtime. The context is being dynamically derived since this simple 
	* method signature is being used to power all of the .forCONTEXT() methods.
	* 
	* @input I am the string being encoded.
	* @output false
	*/
	private string function encodeForCurrentContext( required string input ) {

		var methodName = getFunctionCalledName();
		var methodArguments = [ javaCast( "string", input ) ];

		return( invoke( encoder, methodName, methodArguments ) );

	}

}