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
  #section1 {padding-top:50px;height:500px;color: #fff; background-color: #1E88E5;}
  #section2 {padding-top:50px;height:500px;color: #fff; background-color: #673ab7;}
  #section3 {padding-top:50px;height:500px;color: #fff; background-color: #ff9800;}
  #section4 {padding-top:50px;height:500px;color: #fff; background-color: #00bcd4;}
  #section51 {padding-top:50px;height:500px;color: #fff; background-color: #009688;}
  #section52 {padding-top:50px;height:500px;color: #fff; background-color: #009688;}
  #section53 {padding-top:50px;height:500px;color: #fff; background-color: #009688;}
  #section54 {padding-top:50px;height:500px;color: #fff; background-color: #009688;}
  #section55 {padding-top:50px;height:500px;color: #fff; background-color: #009688;}
  #section56 {padding-top:50px;height:500px;color: #fff; background-color: #009688;}
  </style>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="50">

    <?php
    // Connect to the database
    $servername = "localhost";
    $username = "username";
    $password = "password";
    $db_name = "TestSeqDB";
    
    $conn = new mysqli($servername, $username, $password, $db_name);
    
    // Determine if the connection was successful or not
    if ($conn -> connect_error) {
        $message = $conn -> connect_error;
    } else {
        $message = "Connected successfully";
    }
    ?>
    
    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $input = htmlspecialchars($_POST["search"]);
    }
    ?>
    
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
	<li><a href="#section4">Section4</a></li>
          <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">The Team <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="#section51">Amy</a></li>
              <li><a href="#section52">Carey</a></li>
		<li><a href="#section53">Dan</a></li>
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

<div id="section1" class="container-fluid">
    <div class="jumbotron" id="section1">
        <h1>Dynamic Environment for Adaptable Display of RNA-seq and Annotations of Toxicogenomic Sequences</h1>
        <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
        <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
    </div>
</div>
<div id="section2" class="container-fluid text-center">
  <h1>Summary</h1>
<p><strong>This is where we will add a summary of our findings...</strong></p>
        <p><strong>IF WE HAD ANY!!!1!</strong></p>
</div>
<div id="section3" class="container-fluid text-center">
  <h1>Search Gene</h1>
        <p>Search here to view gene data</p>
        <?php echo "<p>$message</p>";?>
	<span class="col-sm-2"></span>
	<div class="col-sm-8">
        <form action="<?php echo htmlspecialchars("scrollspy.php#section3")?>" method="post">
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
        $sql = "SELECT * FROM Experimental WHERE geneID LIKE \"%$input%\"";
        $result = $conn -> query($sql);
        echo $sql . "<br>";
        $table = "";
        if ($input) {
            
            if ($result -> num_rows > 0) {
                $table = "<thead><tr> <th>Gene ID</th><th>Fold Change</th> </tr></thead>";
                while ($row = $result -> fetch_assoc()) {
                    $table .= "<tbody><tr><td>".$row["geneID"]."</td><td>".$row["foldChange"].
                        "</td><td><button class=\"btn btn-default\" type=\"submit\"><i class=\"glyphicon glyphicon-search\"></i></button></td></tr>";  
                    }
                $table .= "</tbody>";
            } else $table = "<strong>No results today</strong>";
        }
        ?>
        <?php $conn->close();?>
        <div class="table-responsive">
            <table class="table"><?php echo $table;?></table>
        </div>
	</div>
	<span class="col-sm-2"></span>
</div>
<div id="section4" class="container-fluid">
  <h1>Section 4 Submenu 1</h1>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
</div>
<div id="section51" class="container-fluid">
  <h1>Amy</h1>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
</div>
<div id="section52" class="container-fluid">
  <h1>Carey</h1>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
</div>
<div id="section53" class="container-fluid">
  <h1>Dan</h1>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
</div>
<div id="section54" class="container-fluid">
  <h1>Elinor</h1>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
</div>
<div id="section55" class="container-fluid">
  <h1>James</h1>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
</div>
<div id="section56" class="container-fluid">
  <h1>Raymond</h1>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
  <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
</div>

</body>
</html>