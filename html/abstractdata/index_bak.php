
<html>

  <head>
    <script
        src="https://code.jquery.com/jquery-3.1.1.min.js"
        crossorigin="anonymous"></script>
    <script
        src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"
        crossorigin="anonymous"></script>

    <script>
      var institution_list = ["<?php
                               $lines = file('schools.txt', FILE_IGNORE_NEW_LINES);
                               echo(implode($lines, '", "'));
                               ?>"];
     $( function() {
         $("#affiliation").autocomplete({
             source: institution_list,
             messages: {
                 noResults: '',
                 results: function() {}
             }
         })
     });
    </script>

    <link rel="stylesheet" href="abstracts.css">

    </script>

  </head>

  <body>
        <input id="affiliation">
        <div id="completion"><ul></ul></div>
        Text below
  </body>

</html>

