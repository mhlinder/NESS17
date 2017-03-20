
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
    Please submit two copies of your paper: one that is labelled with your name and contact information, and one that is blinded (no identifying information). Submissions must be in PDF format. You must provied your abstract submission confirmation number.
  </p>

  <p>
    <form action="paper-upload2.php" method="post" enctype="multipart/form-data">

      <table style="border: none;">
        <tr>
          <td><strong>Paper</strong></td>
          <td><input type="file" name="paper" id="paper"></td>
        </tr>

        <tr>
          <td><strong>Blinded paper</strong></td>
          <td><input type="file" name="blind" id="blind"></td>
        </tr>

        <tr>
          <td><strong>Abstract number</strong></td>
          <td><input type="text" name="conf" /></td>
        </tr>
      </table>

      <input type="hidden" name="uploadchk" id="uploadchk" value="true">

      <input type="submit" value="Upload Paper" name="submit">
    </form>
  </p>

<?php } else {

    $savedir = "abstractdata/save/posters/";

    $fn = $savedir . $conf . "-TEST-" . basename($_FILES["paper"]["name"]);
    $fn_blind = $savedir . $conf . "-TEST-" . basename($_FILES["blind"]["name"]);
    // echo $fn . "<br />" . $fn_blind;

    if (move_uploaded_file($_FILES["paper"]["tmp_name"], $fn) &&
        move_uploaded_file($_FILES["blind"]["tmp_name"], $fn_blind)) {
        echo "Your file was uploaded successfully.";
    } else {
        echo "There was an error uploading your file. Please contact our webmaster.";
    }

} ?>

