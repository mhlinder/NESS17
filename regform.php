
<form id="registration" name="registration" method="post" enctype="multipart/form-data" action="regsubmit.php">
  <table>
    <tr>
      <td>Short Course:</td>
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
      <td>NESS Registration<span class="red">*</span></td>
      <td>
	<select name="registration">
	  <option selected="selected">Non-Student ($40)</option>
	  <option>Student ($20)</option>
	</select>
      </td>
    </tr>

    <tr>
      <td>First name<span class="red">*</span></td>
      <td><input type="text" name="first-name" /></td>
    </tr>
    
    <tr>
      <td>Last name<span class="red">*</span></td>
      <td><input type="text" name="last-name" /></td>
    </tr>
    
    <tr>
      <td>Email<span class="red">*</span></td>
      <td><input type="text" name="email" /></td>
    </tr>
    
    <tr>
      <td>Organization / Institution<span class="red">*</span></td>
      <td><input type="text" name="org" /></td>
    </tr>
    
    <tr>
      <td>Departmental affiliation</td>
      <td><input type="text" name="dept" /></td>
    </tr>

     <tr>
      <td>Reception</td>
      <td>
	<input type="radio" name="reception" value="No" checked> No
	<input type="radio" name="reception" value="Yes"> Yes
      </td>
    </tr>

    <tr>
      <td>Dinner</td>
      <td>
	<input type="radio" name="dinner" value="No" checked> No
	<input type="radio" name="dinner" value="Yes"> Yes
      </td>
    </tr>

    <tr>
      <td>Donation to NESS fund</td>
      <td>$<input type="text" name="donation" value="0" size="3" /></td>
    </tr>

    <tr>
      <td>Comments</td>
      <td>
	<textarea name="comments" rows="2" cols="25"></textarea>
      </td>
    </tr>
    
  </table>

  <input type="submit" name="Submit" value="Submit registration" />

</form>

<span class="red">Items marked with * are required.</span>
