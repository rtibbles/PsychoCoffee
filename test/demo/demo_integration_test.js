test("/", function() {
  visit("/").then(function() {
    equal(find("h2").text(), "Welcome to PsychoCoffee", "Application header is rendered");
    equal(find("li").length, 3, "There are three items in the list");
  });
});
