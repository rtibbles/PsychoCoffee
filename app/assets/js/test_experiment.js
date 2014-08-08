$(function(){
window.experiment = new PsychoCoffee.Experiment.Model({title: "Test Experiment"});

window.trial = experiment.get("trials").create({
    title: "Instructions"
});

experiment.get("trials").at(0).get("trialObjects").create({
    subModelTypeAttribute: "TextVisualTrialObject",
    text: "You will now hear some sentences.\nSome will be completely audible, others will be difficult to make out.\nFor each sentence, identify whether which emotion they most sound like.",
    duration: 10,
    delay: 0,
    fontSize: 24,
    fontFamily: "arial",
    fontStyle: "normal",
    x: 400,
    y: 400,
    width: 100,
    height: 100,
    opacity: 0.5,
});

experiment.get("trials").at(0).get("trialObjects").create({
    subModelTypeAttribute: "ImageVisualTrialObject",
    duration: 3,
    delay: 3,
    file: "/images/test.png"
});

experiment.get("trials").at(0).get("trialObjects").create({
    subModelTypeAttribute: "AudioTrialObject",
    duration: 3,
    delay: 3,
    file: "/sounds/test.mp3"
});

experimentView = new PsychoCoffee.ExperimentView({model: experiment});

// setTimeout(experimentView.clock.startTimer,5000);
});