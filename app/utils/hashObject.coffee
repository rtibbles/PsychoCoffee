###
Derived from:
 Javascript HashCode v1.0.0
 This function returns a hash code (MD5) based on the argument object.
 http://pmav.eu/stuff/javascript-hash-code

 Example:
  var s = "my String";
  alert(HashCode.value(s));

 pmav, 2010
###

serialize = (object) ->
    serializedCode = ""

    type = typeof object

    if type == 'object'

        for element of object
            serializedCode += "[" + type + ":" +
                element + serialize(object[element]) + "]"


    else if type == 'function'
        serializedCode += "[" + type + ":" + object.toString() + "]"
    else
        serializedCode += "[" + type + ":" + object + "]"

    return serializedCode.replace(/\s/g, "")

module.exports = (object) ->

    md5(serialize(object))