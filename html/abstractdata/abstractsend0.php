
<?php

$regnum      = $_POST['regnum'];
$session     = $_POST['session'];
$presenter   = $_POST['presenter'];
$email       = $_POST['email'];
$affiliation = $_POST['affiliation'];
$title       = $_POST['title'];
$authors     = $_POST['authors'];
$abstract    = $_POST['abstract'];

$hash = rand(0, 10000);
$conf = strtoupper("ABSTRACT-$hash");

$fp = fopen('abstractdata/abstracts.csv', 'a');
$fpcheck1 = fputcsv($fp, array($session, $presenter, $email,
                               $affiliation, $title, $authors, $conf,
                               $regnum));
fclose($fp);

$fp = fopen('abstractdata/save/' . $conf . '.txt', 'w');
$fpcheck2 = fwrite($fp, $abstract);
fclose($fp);

if (!$fpcheck1 || !$fpcheck2) {
    echo("<p class=\"red\">There was an error and your abstract was was not saved! Please resubmit.</p>");
} else { ?>
    <p class="red">Your registration was successful.</p>
    <p>
      Your registration confirmation number is <?php echo $conf; ?>. A
      confirmation email has been sent to <?php echo $email; ?>.
      <span class="red">Please record this number for your reference.</span>
<?php
$subject = "NESS 2017: Abstract Confirmation";

$headers = "MIME-Version: 1.0" . "\r\n";
$headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
$headers .= 'From: NESS 2017<m.henry.linder@uconn.edu>' . "\r\n";
$msg =  "
<p>
  <table>
    <tr><td><strong>Abstract number</strong></td><td>$conf</td></tr>
    <tr><td><strong>Registration number</strong></td><td>$regnum</td></tr>
    <tr><td><strong>Session</strong></td><td>$session</td></tr>
    <tr><td><strong>Presenting author</strong></td><td>$presenter</td></tr>
    <tr><td><strong>Presenter email</strong></td><td>$email</td></tr>
    <tr><td><strong>Presenter affiliation</strong></td><td>$affiliation</td></tr>
    <tr><td><strong>Title</strong></td><td>$title</td></tr>
    <tr><td><strong>Full author list</strong></td><td>$authors</td></tr>
    <tr><td><strong>Abstract text</strong></td><td>$abstract</td></tr>
  </table>
</p>
";

echo $msg;

if (strcmp($session, "00. Poster session") == 0) {
    
    echo "<p>You have registered to present at the poster session. <strong>If you would like to submit a paper, please click the link in your email.</strong></p>";
    
    $msg .= "<p>You have registered to present at the poster session. <strong>If you would like to submit a paper, please note your abstract number above, and click <a href=\"http://ness.stat.uconn.edu/paper-upload\">here</a>.</p>";

}

$success = mail($email, $subject, $msg, $headers);

}

?>

