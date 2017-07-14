<!DOCTYPE html>
<html>
<head>
  <title>DEADRATS</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <style>
  body {
      position: relative; 
  }
  #section1 {padding-top:50px;color: #fff; background-color: #1E88E5;}
  #section2 {padding-top:50px;color: #fff; background-color: #673ab7;}
  #section3 {padding-top:50px;color: #fff; background-color: #ff9800;}
  #section4 {padding-top:50px;color: #fff; background-color: #00bcd4;}
  #section5 {padding-top:50px;color: #fff; background-color: #009688;}
  #section51 {padding-top:50px;color: #fff; background-color: #009688;}
  #section52 {padding-top:50px;color: #fff; background-color: #009688;}
  #section53 {padding-top:50px;color: #fff; background-color: #009688;}
  #section54 {padding-top:50px;color: #fff; background-color: #009688;}
  #section55 {padding-top:50px;color: #fff; background-color: #009688;}
  #section56 {padding-top:50px;color: #fff; background-color: #009688;}
      
  footer {
      background-color: #555;
      color: white;
      padding: 15px;
      }

  </style>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="50">

    <?php
    // Connect to the database
    $db = parse_ini_file("config_file.ini");
    
    $servername = $db['host'];
    $username = $db['user'];
    $password = $db['pass'];
    $db_name = $db['name'];
    
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
	      <li><a href="#section4">Genome Browser</a></li>
          <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">The Team <span class="caret"></span></a>
            <ul class="dropdown-menu">
                <li><a href="#section5">The Team</a></li>
              <li><a href="#section51">Amy</a></li>
              <li><a href="#section52">Carey</a></li>
		      <li><a href="#section53">Daniel</a></li>
		      <li><a href="#section54">Elinor</a></li>
		      <li><a href="#section55">Raymond</a></li>
		      <li><a href="#section56">James</a></li>
            </ul>
          </li>
        </ul>
      </div>
    </div>
  </div>
</nav>    

<!-- Title of the page -->
<div id="section1" class="container-fluid">
    <div class="jumbotron" id="section1">
        <h1>Dynamic Environment for Adaptable Display of RNA-seq and Annotations of Toxicogenomic Sequences</h1>
    </div>
</div>
<!-- The summary section -->
<div id="section2" class="container-fluid text-center">
  <h1>Summary</h1>
<p><strong>This is where we will add a summary of our findings...</strong></p>
        <p><strong>IF WE HAD ANY!!!1!</strong></p>
</div>
<!-- This section lets the user search for a gene in the database and view information on it.
There form contains a search bar and a button. On action, the form will execute the PHP
to search the database for the relevant information such as fold change in expression
and locus.
-->
<div id="section3" class="container-fluid text-center">
  <h1>Search Gene</h1>
        <p>Search here to view gene data</p>
        <?php echo "<p>$message</p>";?>
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
    	if ($_SERVER["REQUEST_METHOD"] == "POST" && $_POST["search"]):
        	$input = htmlspecialchars($_POST["search"]);
            if ($input) {
                $sql = "SELECT * FROM Experimental WHERE geneID LIKE \"%$input%\"";
                $result = $conn -> query($sql);
                echo $sql . "<br>";
            }
        
            
            if ($result -> num_rows > 0): ?>
		<form action="<?php echo htmlspecialchars("results.php")?>" method="post">
			<div class="table-responsive">
				<table class="table">
					<thead>
						<tr>
							<th>Gene ID</th>
						</tr>
					</thead>
					<tbody>
					<?php while ($row = $result -> fetch_object()): ?>
					<tr>
						<td><input type="submit" class="btn btn-default" value="<?php echo $row->geneID ?>" /></td>
					</tr>
					<?php endwhile; ?>
					</tbody>
				</table>
			</div>
		</form>
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
<!-- This section contains an embedded UCSC Genome Browser window. -->
<div id="section4" class="container-fluid text-center">
  <h1>Genome Browser</h1>
  <p>Here you can browse the rat genome and view the BAM tracks</p>
    <form action="<?php echo htmlspecialchars("my_homepage.php#section4")?>" method="post">
    <div class="btn-group">
        <button class="btn btn-success" type="submit" value="rn6" name="genome">rn6</button>
        <button class="btn btn-success" type="submit" value="rn4" name="genome">rn4</button>
    </div>
    </form><br>
    <?php
        if ($_SERVER["REQUEST_METHOD"] == "POST" && $_POST["genome"]){
        	$genome = htmlspecialchars($_POST["genome"]);
            if ($genome) {
                $url = "https://genome.ucsc.edu/cgi-bin/hgTracks?db=$genome&position=chr1&hgct_customText=track%20type=bam%20name=Our_Bam_Trackk%20description=%22The%20BAM%20track%22%20visibility=full%20bigDataUrl=https://s3.eu-west-2.amazonaws.com/bio-files-storage/accepted_hits.bam";
                $height = "500px";
                $width = "100%";
            }
        }
    ?>
    <span class="col-sm-1"></span>
    <div class="col-sm-10 center-block">
    <embed src="<?php echo $url ?>" height="<?php echo $height; ?>" width="<?php echo $width ?>">
    </div>
    <span class="col-sm-1"></span>
</div>
<!-- This section is information about the team members. -->
<div id="section5" class="container-fluid text-center">
<h1>The Team</h1>
<!-- possibly insert group photo -->
</div>
<div id="section51" class="container-fluid text-center">
  <h2>Amy</h2>
  <p>Quality Conctrol manager</p>
</div>
<div id="section52" class="container-fluid text-center">
  <h2>Carey</h2>
  <p>The concise one</p>
</div>
<div id="section53" class="container-fluid text-center">
  <h2>Daniel</h2>
    <p>Web co-developer</p>
</div>
<div id="section54" class="container-fluid text-center">
  <h2>Elinor</h2>
    <p>The numerate one</p>
    <p>Web co-developer</p>
</div>
<div id="section55" class="container-fluid text-center">
  <h2>James</h2>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
</div>
<div id="section56" class="container-fluid text-center">
  <h2>Raymond</h2>
    <p>He who writes in a verbose manner</p>
</div>
<!-- Let's see who notices... -->
<footer class="container-fluid text-center">
  <p>DEADRATS is a subsidiary of the Dank Bioinformatics Memes Corporation</p>
</footer>

</body>
</html>
