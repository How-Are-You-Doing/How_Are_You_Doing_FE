    <script>
    anychart.onDocumentReady(function () {

      var data = [
        {"x": "Affectionate", "value": 5, category: "Needs are Satisfied"},
        {"x": "Confident", "value": 5, category: "Needs are Satisfied"},
        {"x": "Grateful", "value": 5, category: "Needs are Satisfied"},
        {"x": "Peaceful", "value": 5 , category: "Needs are Satisfied"},
        {"x": "Engaged", "value": 5, category: "Needs are Satisfied"},
        {"x": "Excited", "value": 5 , category: "Needs are Satisfied"},
        {"x": "Inspired", "value": 5 , category: "Needs are Satisfied"},
        {"x": "Joyful", "value": 5 , category: "Needs are Satisfied"},
        {"x": "Exhilirated", "value": 5 , category: "Needs are Satisfied"},
        {"x": "Refreshed", "value": 5 , category: "Needs are Satisfied"},
        {"x": "Hopeful", "value": 5 , category: "Needs are Satisfied"},
        {"x": "Afraid", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Confused", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Embarrassed", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Tense", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Annoyed", "value": 5  , category: "Needs are not Satisfied"},
        {"x": "Disconnected", "value": 5  , category: "Needs are not Satisfied"},
        {"x": "Fatigue", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Vulnerable", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Angry", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Disquiet", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Pain", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Aversion", "value": 5 , category: "Needs are not Satisfied"},
        {"x": "Sad", "value": 5 , category: "Needs are not Satisfied"}
      ];

      // create a tag cloud chart
      var chart = anychart.tagCloud(data);

      // set the chart title
      chart.title('I Am Feeling...')
      // set array of angles, by which words will be placed
      chart.angles([0])
      // enable color range
      chart.colorRange(true);
      // set color range length
      chart.colorRange().length('80%');

      // format tooltips
      var formatter = "{%value}{scale:(1)(1000)(1000)(1000)|()( thousand)( million)( billion)}";
      var tooltip = chart.tooltip();
      tooltip.format(formatter);

      // add an event listener
      chart.listen("pointClick", function(e){
        var url = "http://localhost:3000/dashboard?emotion=" + e.point.get("x");
        window.location.href = url;
      });

      // display chart
      chart.container("container");
      chart.draw();
      });
        
    </script>