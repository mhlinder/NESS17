
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
          <option disabled selected value></option>
<option value="00. Poster session">00. Poster session</option>
<option value="01. Huang, Complex Data / Network Modeling">01. Huang, "Complex Data / Network Modeling"</option>
<option value="02. Bar, Big Data">02. Bar, "Big Data"</option>
<option value="03. Song, Bayesian Applications in High-dimensional and Multivariate Modeling">03. Song, "Bayesian Applications in High-dimensional and Multivariate Modeling"</option>
<option value="04. Xie, New Advances in Analysis of Complex Data: Heterogeneity and High Dimensions">04. Xie, "New Advances in Analysis of Complex Data: Heterogeneity and High Dimensions"</option>
<option value="05. Ziniti, Spatial Analysis of Public Health Data">05. Ziniti, "Spatial Analysis of Public Health Data"</option>
<option value="06. Airoldi, Network Data Analysis">06. Airoldi, "Network Data Analysis"</option>
<option value="07. Polunchenko, New Vistas in Statistics with Applications">07. Polunchenko, "New Vistas in Statistics with Applications"</option>
<option value="08. Bi, Machine Learning and Big Data Analytics">08. Bi, "Machine Learning and Big Data Analytics"</option>
<option value="09. Ting, Panel Discusson on Career in Statistics">09. Ting, "Panel Discusson on Career in Statistics"</option>
<option value="10. Zhang, Statistical Approaches in Modeling and Incorporating Dependence">10. Zhang, "Statistical Approaches in Modeling and Incorporating Dependence"</option>
<option value="11. Chiou, Survival Analysis">11. Chiou, "Survival Analysis"</option>
<option value="12. Conlon, Statistical Approaches to Data Modeling and Analysis">12. Conlon, "Statistical Approaches to Data Modeling and Analysis"</option>
<option value="13. Sussman, Social Networks and Causal Inference">13. Sussman, "Social Networks and Causal Inference"</option>
<option value="14. Davis, Wan, Extremes">14. Davis, Wan,  "Extremes"</option>
<option value="15. Ouyang, Statistical Innovations in Genomics">15. Ouyang, "Statistical Innovations in Genomics"</option>
<option value="16. Gan, Statistical Applications in Finance and Insurance">16. Gan, "Statistical Applications in Finance and Insurance"</option>
<option value="17. Chen, Recent Developments on High-Dimensional Statistics and Regularized Estimation">17. Chen, "Recent Developments on High-Dimensional Statistics and Regularized Estimation"</option>
<option value="18. Shao, Application of Statistical / Predictive Modeling in Health Related Industry">18. Shao, "Application of Statistical / Predictive Modeling in Health Related Industry"</option>
<option value="19. Dey, Feinberg Memorial Session: Bayesian Statistics with Applications">19. Dey, "Feinberg Memorial Session: Bayesian Statistics with Applications"</option>
<option value="20. Wang, Subgroup Analysis">20. Wang, "Subgroup Analysis"</option>
<option value="21. Teng, Pharmaceutical Statistics">21. Teng, "Pharmaceutical Statistics"</option>
<option value="22. Ting">22. Ting</option>
<option value="23. Zhang, Graphical Models, Networks, Regulatome and Multivariate Analysis">23. Zhang, "Graphical Models, Networks, Regulatome and Multivariate Analysis"</option>
<option value="24. Amemiya, Space-Time Statistical Solutions at IBM Research">24. Amemiya, "Space-Time Statistical Solutions at IBM Research"</option>
<option value="25. Soaita, Biopharmaceuticals">25. Soaita, "Biopharmaceuticals"</option>
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

