
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
          <option value="Complex Data / Network Modeling (Huang)">Complex Data / Network Modeling (Huang)</option>
          <option value="Big Data (Bar)">Big Data (Bar)</option>
          <option value="Bayesian Applications in High-dimensional and Multivariate Modeling (Song)">Bayesian Applications in High-dimensional and Multivariate Modeling (Song)</option>
          <option value="New Advances in Analysis of Complex Data: Heterogeneity and High Dimensions (Xie)"> New Advances in Analysis of Complex Data: Heterogeneity and High Dimensions (Xie)</option>
          <option value="Spatial Analysis of Public Health Data (Ziniti)">Spatial Analysis of Public Health Data (Ziniti)</option>
          <option value="Network Data Analysis (Airoldi)">Network Data Analysis (Airoldi)</option>
          <option value="New Vistas in Statistics with Applications (Polunchenko)">New Vistas in Statistics with Applications (Polunchenko)</option>
          <option value="Machine Learning and Big Data Analytics (Bi)">Machine Learning and Big Data Analytics (Bi)</option>
          <option value="Panel Discusson on Career in Statistics (Ting)">Panel Discusson on Career in Statistics (Ting)</option>
          <option value="Analysis and Modeling of Temporally Dependent Data (Zhang)">Analysis and Modeling of Temporally Dependent Data (Zhang)</option>
          <option value="Survival Analysis (Chiou)">Survival Analysis (Chiou)</option>
          <option value="Statistical Approaches to Data Modeling and Analysis (Conlon)">Statistical Approaches to Data Modeling and Analysis (Conlon)</option>
          <option value="Social Networks and Causal Inference (Sussman)">Social Networks and Causal Inference (Sussman)</option>
          <option value="Extremes (Wan)">Extremes (Wan)</option>
          <option value="Statistical Innovations in Genomics (Ouyang)">Statistical Innovations in Genomics (Ouyang)</option>
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

