<cfscript>
	
	// Create an instance of our light-weight encode wrapper component, giving
	// it the instance of the OWASP Encode class to proxy.
	encoder = new lib.Encoder( createObject( "java", "org.owasp.encoder.Encode" ) );

	// Setup the input that we are going to test.
	input = "You & me are ""cool"" <Truth />!";

	// Try running the above input through each encoder method.
	arrayEach(
		[
			"forCDATA",
			"forCssString",
			"forCssUrl",
			"forHtml",
			"forHtmlAttribute",
			"forHtmlContent",
			"forHtmlUnquotedAttribute",
			"forJava",
			"forJavaScript",
			"forJavaScriptAttribute",
			"forJavaScriptBlock",
			"forJavaScriptSource",
			"forUri",
			"forUriComponent",
			"forXml",
			"forXmlAttribute",
			"forXmlComment",
			"forXmlContent"
		],
		function( required string methodName ) {

			// Run the value through the OWASP encoder (wrapper).
			var encodedValue = invoke( encoder, methodName, [ input ] );

			// When outputting the value, run the encoded value through the native
			// htmlEditFormat() method so that we can see some of the HTML-specific
			// encodings that were put in place.
			writeOutput(
				methodName & " --- " &
				htmlEditFormat( encodedValue ) &
				"<br />"
			);

		}
	);

</cfscript>