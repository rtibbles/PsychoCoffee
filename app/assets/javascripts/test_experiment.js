$(function(){
var experiment = new PsychoCoffee.Experiment.Model({"title": "Test Experiment"});

experiment.get("trials").create({
    "title": "Instructions"
});

experiment.get("trials").at(0).get("trialObjects").create({
    "subModelTypeAttribute": "TextVisualTrialObject",
    "text": "You will now hear some sentences.\nSome will be completely audible, others will be difficult to make out.\nFor each sentence, identify whether which emotion they most sound like."
});

experimentView = new PsychoCoffee.ExperimentView({model: experiment});

experimentView.render();
experimentView.appendTo("#app");
});