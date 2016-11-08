
<?php

$shortcourse = $_POST['shortcourse'];
$sconly = $_POST['sconly'];
$registration = $_POST['registration'];
$name = $_POST['name'];
$email = $_POST['email'];
$org = $_POST['org'];
$dept = $_POST['dept'];
$reception = $_POST['reception'];
$dinner = $_POST['dinner'];
$donation = $_POST['donation'];
$charge = $_POST['charge'];
$comments = $_POST['comments'];

$hash = substr(md5(uniqid(rand(), true)), 16, 6);
$conf = "NESS$hash";

$table =  "<table>
    <tr><td><b>Invoice #</b></td>$conf<td></tr>
    <tr><td><b>Short Course</b></td><td>$shortcourse</td></tr>
    <tr><td><b>Short course only</b></td><td>$sconly</td></tr>
    <tr><td><b>Registration</b></td><td>$registration</td></tr>
    <tr><td><b>Name</b></td><td>$name</td></tr>
    <tr><td><b>Email</b></td><td>$email</td></tr>
    <tr><td><b>Reception</b></td><td>$reception</td></tr>
    <tr><td><b>Dinner</b></td><td>$dinner</td></tr>
    <tr><td><b>Donation</b></td><td>$$donation</td></tr>
    <tr><td><b>Comments</b></td><td>$comments</td></tr>
    <tr style=\"border-top: 1px solid black;\">
	<td style=\"padding-top: 12px;\"><b>Total charge</b></td>
	<td style=\"padding-top: 12px;\">$$charge</td>
    </tr>
</table>";

$date = date("F j, Y");

$msg = "<h2>Your registration for the 31st New England Statistical
Symposium was received on $date.</h2>

<p>NESS will be hosted on April 21&ndash;22, 2017,
by the Department of Statistics at the University of Connecticut.</p>

<p>$table</p>";

// Send email confirmation

$subject = "NESS 2017: Confirmation";

$headers = "MIME-Version: 1.0" . "\r\n";
$headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
$headers .= 'From: NESS 2017<m.henry.linder@uconn.edu>' . "\r\n";

$fp = fopen('reg.csv', 'a');
$fpcheck = fputcsv($fp, array($conf,$name, $email, $shortcourse, $sconly,
			      $registration, $reception, $dinner,
			      $donation, $comments, $charge)); 
fclose($fp);

if (!$fpcheck) {
    echo "<p class=\"red\">There was an error and your registration was not saved!</p>";
    echo $fpcheck;
} else {
    echo $msg;
    mail($email, $subject, $msg, $headers);
    echo "<p class=\"red\">A confirmation will be sent to $email.</span></p>";
    if ($charge > 0) {
        echo "";
    }
}

?>

