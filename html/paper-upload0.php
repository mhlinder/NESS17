
<?php

// POST sends a bunch of variables, including `from`, which indicates
// whether this request was routed through the abstract submission
// page

$regnum      = $_POST['regnum'];
$session     = $_POST['session'];
$presenter   = $_POST['presenter'];
$email       = $_POST['email'];
$affiliation = $_POST['affiliation'];
$title       = $_POST['title'];
$authors     = $_POST['authors'];
$abstract    = $_POST['abstract'];
$conf        = $_POST['conf'];

$from        = $_POST['from'];

$upload      = $_POST["uploadchk"];

if (!isset($from)) { ?>

  <p>
    To submit to the paper competition, please
    <a href="abstractform">submit a poster abstract</a>.
  </p>

<?php } else if (!isset($upload)) { ?>

  <p>
    <strong>Please upload your paper below. For paper submission
      guidelines, please see the
      <a href="ness2017flyer.pdf">flyer</a>.</strong>
  </p>

  <p>
    Please only upload a PDF file. Your file will be associated with
    your abstract confirmation number, <?php echo $conf; ?>.
  </p>

  <p>
    <form action="paper-upload.php" method="post" enctype="multipart/form-data">
      <input type="file" name="paper" id="paper"><br />

      <input type="hidden" name="from" id="from" value="abstractsend0">
      <input type="hidden" name="uploadchk" id="uploadchk" value="true">

      <input type="hidden" name="regnum" value="<?php echo $regnum; ?>">
      <input type="hidden" name="session" value="<?php echo $session; ?>">
      <input type="hidden" name="presenter" value="<?php echo $presenter; ?>">
      <input type="hidden" name="email" value="<?php echo $email; ?>">
      <input type="hidden" name="affiliation" value="<?php echo $affiliation; ?>">
      <input type="hidden" name="title" value="<?php echo $title; ?>">
      <input type="hidden" name="authors" value="<?php echo $authors; ?>">
      <input type="hidden" name="abstract" value="<?php echo $abstract; ?>">
      <input type="hidden" name="conf" value="<?php echo $conf; ?>">

      <input type="submit" value="Upload Paper" name="submit">
    </form>
  </p>

<?php } else {

    $savedir = "abstractdata/save/posters/";

    $fn = $savedir . $abstract . "-" . basename($_FILES["paper"]["name"]);
    // echo $_FILES["paper"]["tmp_name"];
    // echo $fn;

    if (move_uploaded_file($_FILES["paper"]["tmp_name"], $fn)) {
        echo "Your file was uploaded successfully.";
    } else {
        echo "There was an error uploading your file. Please contact our webmaster.";
    }

} ?>

