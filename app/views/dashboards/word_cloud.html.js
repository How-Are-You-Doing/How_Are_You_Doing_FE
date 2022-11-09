<html>
  <head>
    <title>JavaScript Tag Cloud Chart</title>  
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-base.min.js"></script>
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-tag-cloud.min.js"></script>
    <style>
      html, body, #container {
      width: 85%;
      height: 85%;
      margin: 0;
      padding: 0;
      }
    </style>    
  </head>
  <body>
    <div id="container"></div>
    <script>
    anychart.onDocumentReady(function () {

      var data = [
        {"x": "Affectionate", "value": 5, category: "emotion"},
        {"x": "Confident", "value": 5, category: "emotion"},
        {"x": "Grateful", "value": 5, category: "emotion"},
        {"x": "Peaceful", "value": 5 , category: "emotion"},
        {"x": "Engaged", "value": 5, category: "emotion"},
        {"x": "Excited", "value": 5 , category: "emotion"},
        {"x": "Inspired", "value": 5 , category: "emotion"},
        {"x": "Joyful", "value": 5 , category: "emotion"},
        {"x": "Exhilirated", "value": 5 , category: "emotion"},
        {"x": "Refreshed", "value": 5 , category: "emotion"},
        {"x": "Hopeful", "value": 5 , category: "emotion"},
        {"x": "Afraid", "value": 5 , category: "emotion"},
        {"x": "Confused", "value": 5 , category: "emotion"},
        {"x": "Embarrassed", "value": 5 , category: "emotion"},
        {"x": "Tense", "value": 5 , category: "emotion"},
        {"x": "Annoyed", "value": 5  , category: "emotion"},
        {"x": "Disconnected", "value": 5  , category: "emotion"},
        {"x": "Fatigue", "value": 5 , category: "emotion"},
        {"x": "Vulnerable", "value": 5 , category: "emotion"},
        {"x": "Angry", "value": 5 , category: "emotion"},
        {"x": "Disquiet", "value": 5 , category: "emotion"},
        {"x": "Pain", "value": 5 , category: "emotion"},
        {"x": "Aversion", "value": 5 , category: "emotion"},
        {"x": "Sad", "value": 5 , category: "emotion"}
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
        var url = "https://en.wikipedia.org/wiki/" + e.point.get("x");
        window.open(url, "_blank");
      });

      // display chart
      chart.container("container");
      chart.draw();
      });
        
    </script>
  </body>
</html>



// {"x": "Mandarin chinese", "value": 1090000000, category: "Sino-Tibetan"},
// {"x": "English", "value": 983000000, category: "Indo-European"},
// {"x": "Hindustani", "value": 544000000, category: "Indo-European"},
// {"x": "Spanish", "value": 527000000, category: "Indo-European"},
// {"x": "Arabic", "value": 422000000, category: "Afro-Asiatic"},
// {"x": "Malay", "value": 281000000, category: "Austronesian"},
// {"x": "Russian", "value": 267000000, category: "Indo-European"},
// {"x": "Bengali", "value": 261000000, category: "Indo-European"},
// {"x": "Portuguese", "value": 229000000, category: "Indo-European"},
// {"x": "French", "value": 229000000, category: "Indo-European"},
// {"x": "Hausa", "value": 150000000, category: "Afro-Asiatic"},
// {"x": "Punjabi", "value": 148000000, category: "Indo-European"},
// {"x": "Japanese", "value": 129000000, category: "Japonic"},
// {"x": "German", "value": 129000000, category: "Indo-European"},
// {"x": "Persian", "value": 121000000, category: "Indo-European"}