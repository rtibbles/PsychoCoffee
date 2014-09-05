module "Parameter Model Tests",

    setup: ->
        @parameter = new PsychoCoffee.Parameter.Model

test "Default values", ->
    expect 6

    equal @parameter.get("randomized"), false
    equal @parameter.get("returnType"), "fixedList"
    equal @parameter.get("dataType"), ""
    equal @parameter.get("parameterName"), "Untitled Parameter"
    deepEqual @parameter.get("parameters"), []
    deepEqual @parameter.get("parameterizedAttributes"), {}


test "Methods", ->
    expect 1
    
    parameterList = @parameter.returnParameterList("testing", null, {})
    deepEqual parameterList, []
