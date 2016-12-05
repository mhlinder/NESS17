
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
                               $lines = file('CCIHE2015.txt', FILE_IGNORE_NEW_LINES);
                               echo(implode($lines, '", "'));
                               ?>"];

     $( function() {
         $("#affiliation").autocomplete({
             source: institution_list
         });
     });
    </script>

    <script src="abstracts.js">
    </script>

  </head>

  <body>
        <input id="affiliation">
  </body>

</html>

