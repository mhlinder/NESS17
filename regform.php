
<form id="registration" name="registration" method="post" enctype="multipart/form-data" action="regsubmit.php">
  <table>
    <tr>
      <td><b>Short Course:</b></td>
      <td>
	<select name="short-course">
	  <option selected="selected">No short course</option>
	  <option>Short Course 1</option>
	  <option>Short Course 2</option>
	  <option>Short Course 3</option>
	</select>
      </td>
    </tr>

    <tr>
      <td><b>NESS Registration</b><span class="red">*</span></td>
      <td>
	<select name="registration">
	  <option selected="selected">Non-Student ($40)</option>
	  <option>Student ($20)</option>
	</select>
      </td>
    </tr>

    <tr>
      <td><b>First name</b><span class="red">*</span></td>
      <td><input type="text" name="first-name" /></td>
    </tr>
    
    <tr>
      <td><b>Last name</b><span class="red">*</span></td>
      <td><input type="text" name="last-name" /></td>
    </tr>
    
    <tr>
      <td><b>Email</b><span class="red">*</span></td>
      <td><input type="text" name="email" /></td>
    </tr>
    
    <tr>
      <td><b>Organization / Institution</b><span class="red">*</span></td>
      <td><input type="text" name="org" /></td>
    </tr>
    
    <tr>
      <td><b>Departmental affiliation</b></td>
      <td><input type="text" name="dept" /></td>
    </tr>

     <tr>
      <td><b>Reception</b></td>
      <td>
	<input type="radio" name="dinner" value="No" checked>No
	<input type="radio" name="dinner" value="Yes">Yes
      </td>
    </tr>

    <tr>
      <td><b>Dinner</b></td>
      <td>
	<input type="radio" name="dinner" value="No" checked>No
	<input type="radio" name="dinner" value="Yes">Yes
      </td>
    </tr>

    <tr>
      <td><b>Donation to NESS fund</b></td>
      <td>$<input type="text" name="donation" /></td>
    </tr>

    <tr>
      <td><b>Comments</b></td>
      <td>
	<textarea name="comments" rows="2" cols="25"></textarea>
      </td>
    </tr>
    
  </table>

  <input type="submit" name="Submit" value="Submit registration" />

</form>

<span class="red">Items marked with * are required.</span>
