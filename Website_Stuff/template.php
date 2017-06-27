<!DOCTYPE html>
<html lang="en">
<head>
  <title>DEADRATS</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <style>
    /* Remove the navbar's default margin-bottom and rounded borders */ 
    .navbar {
      margin-bottom: 0;
      border-radius: 0;
    }
    
    /* Set height of the grid so .sidenav can be 100% (adjust as needed) */
    .row.content {height: 450px}
    
    /* Set gray background color and 100% height */
    .sidenav {
      padding-top: 20px;
      background-color: #f1f1f1;
      height: 100%;
    }
    
    /* Set black background color, white text and some padding */
    footer {
      background-color: #555;
      color: white;
      padding: 15px;
    }
    /*.centre {
        background-color: aqua;*/
    
    
    /* On small screens, set height to 'auto' for sidenav and grid */
    @media screen and (max-width: 767px) {
      .sidenav {
        height: auto;
        padding: 15px;
      }
      .row.content {height:auto;} 
    }
  </style>
</head>
<body>
    
    <?php
    // Connect to the database
    $servername = "localhost";
    $username = "dcl10";
    $password = "1-Puddlejumper";
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
    $output = "";
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $input = $_POST["search"];
    }
    ?>

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="#">Logo</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav">
        <li class="active"><a href="#">Home</a></li>
        <li><a href="#">About</a></li>
        <li><a href="#">Projects</a></li>
        <li><a href="#">Contact</a></li>
      </ul>
      <ul class="nav navbar-nav navbar-right">
        <li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
      </ul>
    </div>
  </div>
</nav>
  
<div class="container-fluid text-center">    
  <div class="row content">
    <div class="col-sm-2 sidenav">
      <p><a href="#">Link</a></p>
      <p><a href="#">Link</a></p>
      <p><a href="#">Link</a></p>
    </div>
    <div class="col-sm-8 text-left centre"> 
      <h1>Dynamic Environment for Adaptable Display of RNA-seq and Annotations of Toxicogenomic Sequences</h1>
      <p><?php echo $message; ?></p>
      <hr>
      <h3>Summary</h3>
        <p><strong>This is where we will add a summary of our findings...</strong></p>
        <p><strong>IF WE HAD ANY!!!1!</strong></p>
      <hr>
      <h3>Search Gene</h3>
        <p>Search here to view gene data</p>
        <form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"])?>" method="post">
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
        $sql = "SELECT * FROM Experimental WHERE geneID = \"$input\"";
        $result = $conn -> query($sql);
        echo $sql . "<br>";
        $table = "";
        if ($input) {
            
            if ($result -> num_rows > 0) {
                $table = "<tr> <th>Gene ID</th><th>Fold Change</th> <tr>";
                while ($row = $result -> fetch_assoc()) {
                    $table .= "<tr><td>".$row["geneID"]."</td><td>".$row["foldChange"]."</td></tr>";  
                    //echo "gene: " .  $row["geneID"] . " " . "fold change: " . $row["foldChange"]."<br>";
                }
            } else $table = "<strong>No results today</strong>";
        }
        ?>
        <?php $conn->close();?>
        <table><?php echo $table;?></table>
        <hr>
    </div>
    <div class="col-sm-2 sidenav">
      <!--<div class="well">
        <p>ADS</p>
      </div>-->
      <!--<div class="well">
        <p>ADS</p>
      </div>-->
    </div>
  </div>
</div>

<footer class="container-fluid text-center">
  <p>This website is trademarked to DEADRATS. F U A team</p>
</footer>

</body>
</html>

