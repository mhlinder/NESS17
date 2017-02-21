<?php
$upload = $_POST["uploadchk"];

if (!isset($upload)) { ?>

  <form action="paper-upload.php" method="post" enctype="multipart/form-data">
    <input type="file" name="paper" id="paper"><br />
    <input type="hidden" name="uploadchk" id="uploadchk" value="true">
    <input type="submit" value="Upload Paper" name="submit">
  </form>

<?php } else {

    $savedir = "abstractdata/save/posters/";

    $fn = $savedir . basename($_FILES["paper"]["name"]);
    echo $_FILES["paper"]["tmp_name"];
    echo $fn;

    if (move_uploaded_file($_FILES["paper"]["tmp_name"], $fn)) {
        echo "Your file was uploaded successfully.";
    } else {
        echo "There was an error uploading your file, please contact our webmaster.";
    }

} ?>

