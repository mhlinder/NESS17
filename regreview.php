
<table>

    <?php

    $shortcourse = $_POST['short-course'];
    $registration = $_POST['registration'];
    $fname = $_POST['first-name'];
    $lname = $_POST['last-name'];
    $email = $_POST['email'];
    $org = $_POST['org'];
    $dept = $_POST['dept'];
    $reception = $_POST['reception'];
    $dinner = $_POST['dinner'];
    $donation = $_POST['donation'];
    $comments = $_POST['comments'];

    $email = strtolower($email);
    $comments = stripslashes($comments);

    if (empty($fname) || empty($lname) || empty($email) || empty($org)) { ?>

	<h2>Registration unsuccessful!</h2>
	<p><span class="red">Please fill in all required fields.</span></p>
	<p><input name="Back" type="button" class="text" value="Back"
		  onClick="javascript:history.back()" /></p>
	
    <?php } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) { ?>

	<h2>Registration unsuccessful!</h2>
	<p><span class="red">The email provided is invalid.</span></p>
	<p><input name="Back" type="button" class="text" value="Back"
		  onClick="javascript:history.back()" /></p>

    <?php } elseif (!is_numeric($donation) || (int)$donation < 0) { ?>

	<h2>Registration unsuccessful!</h2>
	<p><span class="red">The donation must be a positive value.</span></p>
	<p><input name="Back" type="button" class="text" value="Back"
		  onClick="javascript:history.back()" /></p>

    <?php } else {

	$charge = 0;
	if ($registration == "Non-Student") {
	    $charge += 40;
	} elseif ($registration == "Student") {
	    $charge += 20;
	}

	$charge += (int)$donation;

	$name = $fname . " " . $lname;

	?>

	<table>
	    <tr><td>Short Course</td><td><?php echo $shortcourse; ?></td></tr>
	    <tr><td>Registration</td><td><?php echo $registration; ?></td></tr>
	    <tr><td>Name</td><td><?php echo $name; ?></td></tr>
	    <tr><td>Email</td><td><?php echo $email; ?></td></tr>
	    <tr><td>Reception</td><td><?php echo $reception; ?></td></tr>
	    <tr><td>Dinner</td><td><?php echo $dinner; ?></td></tr>
	    <tr><td>Donation</td><td>$<?php echo $donation; ?></td></tr>
	    <tr><td>Comments</td><td><?php echo $comments; ?></td></tr>
	    <tr><td>Total charge:</td><td>$<?php echo $charge; ?></td></tr>
	</table>

    <?php }

    ?>

</table>

