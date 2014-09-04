module "Parameter Model Tests",

    setup: ->
        window.parameter = new PsychoCoffee.Parameter.Model

test "Default values", ->
    expect 6

    equal window.parameter.get("randomized"), false
    equal window.parameter.get("returnType"), "fixedList"
    equal window.parameter.get("dataType"), ""
    equal window.parameter.get("parameterName"), "Untitled Parameter"
    deepEqual window.parameter.get("parameters"), []
    deepEqual window.parameter.get("parameterizedAttributes"), {}


test "Methods", ->
    expect 1
    
    parameterList = window.parameter.returnParameterList("testing", null, {})
    deepEqual parameterList, []
