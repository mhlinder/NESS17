
<?php

$conf        = $_POST['conf'];
$upload      = $_POST["uploadchk"];

if (!isset($upload)) { ?>

  <p>
    <strong>Please upload your paper below. For paper submission
      guidelines, please see the
      <a href="ness2017flyer.pdf">flyer</a>.</strong>
  </p>

  <p>
    Please only upload a PDF file. You must provied your abstract submission confirmation number.<?php echo $conf; ?>.
  </p>

  <p>
    <form action="paper-upload.php" method="post" enctype="multipart/form-data">
      <input type="file" name="paper" id="paper"><br />

      <input type="hidden" name="uploadchk" id="uploadchk" value="true">

      Abstract number <input type="text" name="conf" /><br/>

      <input type="submit" value="Upload Paper" name="submit">
    </form>
  </p>

<?php } else {

    $savedir = "abstractdata/save/posters/";

    $fn = $savedir . $conf . "-" . basename($_FILES["paper"]["name"]);
    // echo $_FILES["paper"]["tmp_name"];
    // echo $fn;

    if (move_uploaded_file($_FILES["paper"]["tmp_name"], $fn)) {
        echo "Your file was uploaded successfully.";
    } else {
        echo "There was an error uploading your file. Please contact our webmaster.";
    }

} ?>

