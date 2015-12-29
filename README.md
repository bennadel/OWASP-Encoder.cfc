
# OWASP Encoder.cfc - Java Encoder Proxy For ColdFusion

by [Ben Nadel][bennadel] (on [Google+][googleplus])

The Open Web Application Security Project (OWASP) maintains a project called the 
[Java Encoder][javaencoder]. The Java Encoder is a high-performance encoder class that 
encodes String values for **safe use** in different contexts. In a Java project, this 
encoder is dead-simple to use. However, in a ColdFusion project, care has to be taken 
when invoking the methods since the method signatures require the use `javaCast()` in 
order to ensure `java.lang.String` inputs.

This project is a light-weight ColdFusion component wrapper for the Java Encoder class 
that takes care of all of the `javaCast()` invocation for you. The `Encoder.cfc` 
implements all of the same top-level .forCONTEXT() methods. These methods can accept any
"simple value" (number, string, date, boolean, etc.), and will `javaCast()` the input to
a String internally, invoke the proxied method, and return the result.

## Encode-For Methods

I found the documentation on the encode methods very hard to find. As such, I am 
reproducing it here for convenience.

### forCDATA( String ) :: String

Encodes data for an XML CDATA section. On the chance that the input contains a terminating
`"]]>"`, it will be replaced by `"]]>]]<![CDATA[>"`. As with all XML contexts, characters 
that are invalid according to the XML specification will be replaced by a space character.
Caller must provide the CDATA section boundaries.

### forCssString( String ) :: String

Encodes for CSS strings. The context must be surrounded by quotation characters. It is
safe for use in both style blocks and attributes in HTML.

### forCssUrl( String ) :: String

Encodes for CSS URL contexts. The context must be surrounded by "url(" and ")". It is 
safe for use in both style blocks and attributes in HTML. Note: this does not do any 
checking on the quality or safety of the URL itself. The caller should insure that the
URL is safe for embedding (e.g. input validation) by other means.

### forHtml( String ) :: String

Encodes for (X)HTML text content and text attributes. Since this method encodes for 
both contexts, it may be slightly less efficient to use this method over the methods 
targeted towards the specific contexts (`forHtmlAttribute(String)` and 
`forHtmlContent(String)`. In general this method should be preferred unless you are 
really concerned with saving a few bytes or are writing a framework that utilizes this 
package.

| Input Character | Encoded Result | Notes |
| --------------- | -------------- | ----- |
| U+0026 `&`      | `&amp;`        |       |	
| U+003C `<`      | `&lt;`         |       |
| U+003E `>`      | `&gt;`         | This escape is not strictly required, but is included for maximum compatibility. |
| U+0022 `"`      | `&#34;`        | `"&quot;"` would also be valid. The numeric version is used since it is shorter. |
| U+0027 `'`      | `&#39;`        |       |

In addition to the above translation, only characters that are valid according to the
XML specification are allowed through. Invalid characters are replaced with a single 
space character (U+0020). This additional step enables XHTML compliance when utilizing
this method.

### forHtmlAttribute( String ) :: String

This method encodes for HTML text attributes.

### forHtmlContent( String ) :: String

This method encodes for HTML text content. It does not escape quotation characters and
is thus unsafe for use with HTML attributes. Use either forHtml or forHtmlAttribute for 
those methods.

### forHtmlUnquotedAttribute( String ) :: String

Encodes for unquoted HTML attribute values. `forHtml(String)` or 
`forHtmlAttribute(String)` should usually be preferred over this method as quoted 
attributes are XHTML compliant.

When using this method, the caller is not required to provide quotes around the attribute
(since it is encoded for such context). The caller should make sure that the attribute 
value does not abut unsafe characters--and thus should usually err on the side of 
including a space character after the value.

### forJava( String ) :: String

Encodes for a Java string. This method will use `"\b"`, `"\t"`, `"\r"`, `"\f"`, `"\n"`,
`"\""`, `"\'"`, `"\\"`, octal and unicode escapes. Valid surrogate pairing is not checked.
The caller must provide the enclosing quotation characters. This method is useful for when
writing code generators and outputting debug messages.

### forJavaScript( String ) :: String

Encodes for a JavaScript string. It is safe for use in HTML script attributes (such as 
onclick), script blocks, JSON files, and JavaScript source. The caller MUST provide the 
surrounding quotation characters for the string. Since this performs additional encoding
so it can work in all of the JavaScript contexts listed, it may be slightly less efficient
then using one of the methods targetted to a specific JavaScript context 
(`forJavaScriptAttribute(String)`, `forJavaScriptBlock(java.lang.String)`, 
`forJavaScriptSource(java.lang.String)`). Unless you are interested in saving a few bytes 
of output or are writing a framework on top of this library, it is recommend that you 
use this method over the others.

| Input Character | Encoded Result | Notes |
| --------------- | -------------- | ----- |
| U+0008 `BS`     | `\b`           | Backspace character |
| U+0009 `HT`     | `\t`           | Horizontal tab character |
| U+000A `LF`     | `\n`           | Line feed character |
| U+000C `FF`     | `\f`           | Form feed character |
| U+000D `CR`     | `\r`           | Carriage return character |
| U+0022 `"`      | `\x22`         | The encoding `\"` is not used here because it is not safe for use in HTML attributes. (In HTML attributes, it would also be correct to use `"\&quot;"` |.)
| U+0027 `'`      | `\x27`         | The encoding `\'` is not used here because it is not safe for use in HTML attributes. (In HTML attributes, it would also be correct to use `"\&#39;"`. |)
| U+002F `/`      | `\/`           | This encoding is used to avoid an input sequence `"</"` from prematurely terminating a `</script>` block. |
| U+005C `\`      | `\\`           |  |
| U+0000 to U+001F | `\x##`        | Hexadecimal encoding is used for characters in this range that were not already mentioned in above. |

### forJavaScriptAttribute( String ) :: String

This method encodes for JavaScript strings contained within HTML script attributes (such
as onclick). It is NOT safe for use in script blocks. The caller MUST provide the 
surrounding quotation characters. This method performs the same encode as 
forJavaScript(String) with the exception that / is not escaped.

**Unless you are interested in saving a few bytes of output or are writing a framework 
on top of this library, it is recommend that you use `forJavaScript(String)` over this
method.**

### forJavaScriptBlock( String ) :: String

This method encodes for JavaScript strings contained within HTML script blocks. It is
NOT safe for use in script attributes (such as onclick). The caller must provide the 
surrounding quotation characters. This method performs the same encode as 
`forJavaScript(String)` with the exception that `"` and `'` are encoded as `\"` and `\'`
respectively.

**Unless you are interested in saving a few bytes of output or are writing a framework 
on top of this library, it is recommend that you use `forJavaScript(String)` over this
method.**

### forJavaScriptSource( String ) :: String

This method encodes for JavaScript strings contained within a JavaScript or JSON file. 
This method is NOT safe for use in ANY context embedded in HTML. The caller must provide
the surrounding quotation characters. This method performs the same encode as 
`forJavaScript(String)` with the exception that `/` is not escaped, and `"` and `'` are 
encoded as `\"` and `\'` respectively.

**Unless you are interested in saving a few bytes of output or are writing a framework 
on top of this library, it is recommend that you use `forJavaScript(String)` over this
method.**

### forUri( String ) :: String

Performs percent-encoding of a URL according to RFC 3986. The provided URL is assumed to
a valid URL. This method does not do any checking on the quality or safety of the URL 
itself. In many applications it may be better to use URI instead. Note: this is a 
particularly dangerous context to put untrusted content in, as for example a 
`"javascript:"` URL provided by a malicious user would be "properly" escaped, and still 
execute.

### forUriComponent( String ) :: String

Performs percent-encoding for a component of a URI, such as a query parameter name or 
value, path or query-string. In particular this method insures that special characters in
the component do not get interpreted as part of another component.

### forXml( String ) :: String

Encoder for XML and XHTML.

### forXmlAttribute( String ) :: String

Encoder for XML and XHTML attribute content.

### forXmlComment( String ) :: String

Encoder for XML comments. **NOT FOR USE WITH (X)HTML CONTEXTS**. (X)HTML comments may be 
interpreted by browsers as something other than a comment, typically in vendor specific 
extensions (e.g. `<--if[IE]-->`). For (X)HTML it is recommend that unsafe content never
be included in a comment.

The caller must provide the comment start and end sequences.

This method replaces all invalid XML characters with spaces, and replaces the "--" 
sequence (which is invalid in XML comments) with "-~" (hyphen-tilde). This encoding 
behavior may change in future releases. If the comments need to be decoded, the caller 
will need to come up with their own encode/decode system.

### forXmlContent( String ) :: String

Encoder for XML and XHTML text content.


[bennadel]: http://www.bennadel.com
[googleplus]: https://plus.google.com/108976367067760160494?rel=author
[javaencoder]: https://www.owasp.org/index.php/OWASP_Java_Encoder_Project