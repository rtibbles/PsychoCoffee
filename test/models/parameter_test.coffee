module "Parameter Model Tests",

    setup: ->
        @parameter = new PsychoCoffee.Parameter.Model

test "Default values", ->
    expect 4

    equal @parameter.get("randomized"), false
    equal @parameter.get("returnType"), "fixedList"
    equal @parameter.get("dataType"), "String"
    deepEqual @parameter.get("parameters"), []

test "Methods", ->
    expect 1
    
    parameterList = @parameter.returnParameterList("testing", null, {})
    deepEqual parameterList, []
