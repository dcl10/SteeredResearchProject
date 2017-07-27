<?php
    session_start();
?>
<!DOCTYPE html>

<!--
    Here the results of the analysis of the effects of Aflatoxin on gene expression in rats from pipeline 5
    in Wang et al. are presented. The user can search a database of our results and visualise
    RNASeq reads on an embedded sesson of the UCSC Genome Browser.
    There is also a nice Easter egg from Daniel at the bottom.
-->

<html>
<head>
  <title>DEADRATS | main page</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <style>
  body {
      position: relative; 
  }
  #section1 {padding-top:50px;color: #fff; background-color: #006622;}
  #section2 {padding-top:50px;color: #000; background-color: #ffffff;}
  #section3 {padding-top:50px;color: #fff; background-color: #71da71;}
  footer {
      background-color: #555;
      color: white;
      padding: 15px;
      }
    iframe {
        border: none;
        padding-bottom: 25px;
       }
      h1 {font-size: 50px;
      padding-bottom: 15px;
      }
      .text-input {background : none; border : none;}
  </style>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="50">

    <?php
    // Parse the configuration file and get the credentials for the database
    $db = parse_ini_file("../config_file.ini");
    $servername = $db['host'];
    $username = $db['user'];
    $password = $db['pass'];
    $db_name = $db['name'];
    
    //Connect to the database
    $conn = new mysqli($servername, $username, $password, $db_name);
    
    // Determine if the connection was successful or not
    if ($conn -> connect_error) {
        $message = $conn -> connect_error;
    } else {
        $message = "Connected successfully";
    }
    ?>
    
<!-- Building the top navigation bar -->    
<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
	<span class="icon-bar"></span>                         
      </button>
      <a class="navbar-brand" href="#">DEADRATS</a>
    </div>
    <div>
      <div class="collapse navbar-collapse" id="myNavbar">
        <ul class="nav navbar-nav">
          <li><a href="#section1">Home</a></li>
          <li><a href="#section2">Summary</a></li>
          <li><a href="#section3">Search Gene</a></li>
        </ul>
      </div>
    </div>
  </div>
</nav>    

<!-- Title of the page -->
<div id="section1" class="container-fluid text-center">
    <h1>Dynamic Environment for Adaptable Display of RNA-seq and Annotations of Toxicogenomic Sequences</h1>
</div>
<!-- The summary section -->
<div id="section2" class="container-fluid text-center">
    <h1>Summary</h1>
    <p>RNA-seq is a modern technique for measuring gene expression which rivals the accuracy and speed of microarrays. This technique is particularly helpful as it can account for multiple transcripts, making identifying transcriptomes with this method more accurate than with the other. Wang et al, (2014) studied the differences in RNA-seq data analysis programs within gene expression profiling. They compared 6 different transcriptomic pipelines that compared the gene expression profiles of rats which had been exposed to various DNA damaging agents. </p><br>
    <p>Herein, pipeline 5 from Wang et al. (2014) was implemented to analyse RNA-seq reads from rats exposed to aflatoxin. This pipeline used TopHat, Bowtie and Cufflinks to assemble the transcriptome and estimate the expression levels of all the genes. A RNA-seq specialist package in R called limma was used to determine which genes significantly differentially expressed. A website with an attendant database was constructed to display the results of the analysis on a gene by basis. </p><br>
    <p>It was found that there was no significant difference in the differential expression measured when the RNA-seq reads were mapped to rn4 and when mapped to rn6. The number of differentially expressed genes (DEGs) was 293 for each genome, 317 if the ERCC control samples were included. While the same number of DEGs were found for each genome, they were not the same genes. 247 genes were found to be differentially expressed in both genomes. The most differentially expressed genes in rn4 and rn6 are both peptidase inhibitors that are highly expressed in rat liver. In the rats treated with aflatoxin, expression of these genes was completely suppressed. </p><br>
    <span class="col-sm-1"></span>
    <iframe src="http://143.210.153.229:3838/srp2017b/table/" width="100%" height="450px" class="col-sm-10"></iframe>
    <span class="col-sm-1"></span>
    <iframe src="http://143.210.153.229:3838/srp2017b/volcano/" width="100%" height="650px" class="col-sm-12"></iframe>
</div> 
<!-- This section lets the user search for a gene in the database and view information on it.
There form contains a search bar and a button. On action, the form will execute the PHP
to search the database for the relevant information such as fold change in expression
and locus.
-->
<div id="section3" class="container-fluid text-center">
  <h1>Search Gene</h1>
        <p>Search here to view gene data</p>
	<span class="col-sm-2"></span>
	<div class="col-sm-8">
        <form action="<?php echo htmlspecialchars("my_homepage.php#section3")?>" method="post">
            <div class="input-group">
                <input type=text name="search" placeholder="Enter gene name..." class="form-control">
                <div class="input-group-btn">
                    <button class="btn btn-default" type="submit">
                        <i class="glyphicon glyphicon-search"></i>
                    </button>
                </div>
            </div>
        </form>
        <?php
    	if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["search"])):
        	$input = htmlspecialchars($_POST["search"]);
            if ($input) {
                $sql = "SELECT * FROM gene_id_and_name WHERE gene_name LIKE \"%$input%\"";
                $result = $conn -> query($sql);
            }
            if ($result -> num_rows > 0): ?>
			<div class="table-responsive">
				<table class="table">
					<thead>
						<tr>
							<th>Gene Name</th>
                            <th>Gene ID</th>
                            <th></th>
						</tr>
					</thead>
					<tbody>
					<?php while ($row = $result -> fetch_object()): ?>
					<tr>
                        <form action="<?php echo htmlspecialchars("results.php")?>" method="post">
                            <td><input type="text" readonly class= "text-input" name="gene_name" value="<?php echo $row->gene_name ?>" /></td>
                            <td><input type="text" readonly class= "text-input" name="gene_id" value="<?php echo $row->gene_id ?>" /></td>
                            <td><input type="submit" value="View" class="btn btn-default"></td>
                        </form>
					</tr>
					<?php endwhile; ?>
					</tbody>
				</table>
			</div>
		<?php else: ?>
			<p><em>No results.</em></p>
		<?php endif; ?>
		<?php else: ?>
			<br />
		<?php
			endif; 
			$conn->close();
		?>
	</div>
	<span class="col-sm-2"></span>
</div>
<!-- Let's see who notices... -->
<footer class="container-fluid text-center">
    <a class="up-arrow" href="#section1" data-toggle="tooltip" title="TO TOP" style="color: white">
    <span class="glyphicon glyphicon-chevron-up"></span><br>To Top
  </a><br><br>
  <p>DEADRATS is a subsidiary of the Dank Bioinformatics Memes Corporation</p>
</footer>

</body>
</html>
