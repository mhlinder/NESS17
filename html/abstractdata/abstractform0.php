
<form id="abstracts" name="abstracts" method="post" enctype="multipart/form-data" action="abstractconf">
  <table>

    <tr>
      <td>Registration confirmation number</td>
      <td><input type="text" name="regnum" placeholder="NESS17-1234" size="30" /></td>
    </tr>

    <tr>
      <td>Session</td>
      <td>
        <select name="session" style="width: 100%;">
          <option value="Huang, Complex Data / Network Modeling">1: Huang, "Complex Data / Network Modeling"</option>
          <option value="Bar, Big Data">2: Bar, "Big Data"</option>
          <option value="Song, Bayesian Applications in High-dimensional and Multivariate Modeling">3: Song, "Bayesian Applications in High-dimensional and Multivariate Modeling"</option>
          <option value="Xie, New Advances in Analysis of Complex Data: Heterogeneity and High Dimensions">4: Xie, " New Advances in Analysis of Complex Data: Heterogeneity and High Dimensions"</option>
          <option value="Ziniti, Spatial Analysis of Public Health Data">5: Ziniti, "Spatial Analysis of Public Health Data"</option>
          <option value="Airoldi, Network Data Analysis">6: Airoldi, "Network Data Analysis"</option>
          <option value="Polunchenko, New Vistas in Statistics with Applications">7: Polunchenko, "New Vistas in Statistics with Applications"</option>
          <option value="Bi, Machine Learning and Big Data Analytics">8: Bi, "Machine Learning and Big Data Analytics"</option>
          <option value="Ting, Panel Discusson on Career in Statistics">9: Ting, "Panel Discusson on Career in Statistics"</option>
          <option value="Zhang, Analysis and Modeling of Temporally Dependent Data">9: Zhang, "Analysis and Modeling of Temporally Dependent Data"</option>
          <option value="Chiou, Survival Analysis">10: Chiou, "Survival Analysis"</option>
          <option value="Conlon, Statistical Approaches to Data Modeling and Analysis">11: Conlon, "Statistical Approaches to Data Modeling and Analysis"</option>
          <option value="Sussman, Social Networks and Causal Inference">12: Sussman, "Social Networks and Causal Inference"</option>
          <option value="Wan, Extremes">13: Wan, "Extremes"</option>
          <option value="Ouyang, Statistical Innovations in Genomics">14: Ouyang, "Statistical Innovations in Genomics"</option>
        </select>
      </td>
    </tr>

    <tr>
      <td>Presenting author</td>
      <td><input type="text" name="presenter" placeholder="Jerzy Neyman" size="30" /></td>
    </tr>

    <tr>
      <td>Presenter email</td>
      <td><input type="text" name="email" placeholder="jneyman@berkeley.edu" size="30" /></td>
    </tr>

    <tr>
      <td>Presenter affiliation</td>
      <td><input type="text" name="affiliation" id="affiliation" placeholder="University of California, Berkeley" size="30" /></td>
    </tr>

    <tr>
      <td>Title</td>
      <td><input type="text" name="title" placeholder="On the Problem of the Most Efficient Tests of Statistical Hypotheses" size="30" /></td>
    </tr>

   <tr>
      <td>Full author list</td>
      <td><input type="text" name="authors" size="30" placeholder="Jerzy Neyman, Egon Pearson" /></td>
   </tr>

   <tr>
     <td valign="top">Abstract text</td>
     <td><textarea rows="5" cols="30" form="abstracts" name="abstract"
                   placeholder="The problem of testing statistical hypotheses is an old one."></textarea></td>
   </tr>

   <tr>
     <td>
       <input type="submit" name="Submit" value="Submit abstract" />
     </td>
     <td></td>
   </tr>

  </table>
  <emph class="red">LaTeX formatting is permitted for all text entry fields.</emph>
</form>

<script>
 var institution_list = ["<?php
                               $lines = file('abstractdata/schools.txt', FILE_IGNORE_NEW_LINES);
                               echo(implode($lines, '", "'));
                               ?>"];
 $(function() {
     $("#affiliation").autocomplete({
         source: institution_list,
         messages: {
             noResults: '',
             results: function() {}
         }
     });
 });
</script>

