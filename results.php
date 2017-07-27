<!DOCTYPE html>
<html lang="en">
<head>
  <title>DEADRATS | results</title>
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
  #section5 {padding-top:50px;color: #000; background-color: #ffffff;}
      
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
  </style>
</head>
<body>
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
      <a class="navbar-brand" href="my_homepage.php">DEADRATS</a>
    </div>
    <div>
      <div class="collapse navbar-collapse" id="myNavbar">
        <ul class="nav navbar-nav">
          <li><a href="my_homepage.php#section1">Home</a></li>
          <li><a href="my_homepage.php#section2">Summary</a></li>
          <li><a href="my_homepage.php#section3">Search Gene</a></li>
        </ul>
      </div>
    </div>
  </div>
</nav> 
<!-- Title of the page -->
<div class="container-fluid text-center" id="section1">
        <?php 
            //initialise the gene name and id variables
            $gene_name = $_POST["gene_name"];
            $gene_id = $_POST["gene_id"];
        ?>
        <!-- Page header depends on the gene selected on the homepage search bar -->
        <h1>Results for: <?php echo $gene_name; ?> | <?php echo $gene_id?></h1>
</div>
<!-- 
    Table showing statistics on the selected gene depending on the genome to which it was mapped
    and whether it is describes if it is differentially expressed.
-->
<div class="container-fluid text-center" id="section2">
    <h1>Statistics</h1>
    <?php
        //retrieve statistical information about the gene from the DEADRATS databse
        $rn4sql = "SELECT * FROM rn4_stats WHERE gene_id ='$gene_id'";
        $rn4results = $conn -> query($rn4sql);
        $rn6sql = "SELECT * FROM rn6_stats WHERE gene_id ='$gene_id'";
        $rn6results = $conn -> query($rn6sql);
    ?>
    <span class="col-sm-2"></span>
    <div class="table-responsive col-sm-8">
        <table class="table">
        <thead>
        <tr>
            <th>Genome</th>
            <th>logFC</th>
            <th>P-value</th>
            <th>Adjusted P-value</th>
            <th>t-test</th>
            <th>Differentially expressed?*</th>
        </tr>
        </thead>
        <tfoot>
            <tr>*A gene is differentially expressed if P-value is less than 0.05 and absolute logFC is greater than 1.5</tr>
        </tfoot>    
        <tbody>
        <tr>
            <td>rn4</td>
            <?php $row = $rn4results->fetch_object() ?>
            <td><?php echo $row -> logFC ?> </td>
            <td><?php echo $row -> P ?></td>
            <td><?php echo $row -> adjP ?></td>
            <td><?php echo $row -> t ?></td>
            <td><?php echo $row -> dif_ex ?></td>
        </tr>
        <tr>
            <td>rn6</td>
            <?php $row = $rn6results->fetch_object() ?>
            <td><?php echo $row -> logFC ?> </td>
            <td><?php echo $row -> P ?></td>
            <td><?php echo $row -> adjP ?></td>
            <td><?php echo $row -> t ?></td>
            <td><?php echo $row -> dif_ex ?></td>
        </tr>
        </tbody>
    </table>
    </div>
    <span class="col-sm-2"></span>
</div>
<!-- Container for the R Shiny app -->
<div id="section3" class="container-fluid text-center">
    <h1>Expression</h1>
    <p>Here you can view the FPKM of a gene in each rat and compare the FPKM between rn4 and rn6.</p>
    <p>To view the FPKM of <?php echo $gene_name; ?>, try pasting "<?php echo $gene_id; ?>" into the search bar below.</p>
    <span class="col-sm-2"></span>
    <iframe src="http://143.210.153.229:3838/srp2017b/graph/" class="col-sm-8" height="500px"><!-- put the Shiny app here --></iframe>
    <span class="col-sm-2"></span>
</div>
<!-- This section contains an embedded UCSC Genome Browser window. -->
<div id="section5" class="container-fluid text-center">
  <h1>Genome Browser</h1>
  <p>Here you can browse the rat genome and view the BAM tracks</p>
    <span class="col-sm-2"></span>
    <form action="<?php echo htmlspecialchars("results.php#section5"); ?>" method="post" class="col-sm-8 form-inline">
        Choose rat: <div class="form-group">
            <input type="text" hidden="hidden" value="<?php echo $gene_name ?>" name="gene_name">
            <input type="text" hidden="hidden" value="<?php echo $gene_id ?>" name="gene_id">
            <select class="form-control" name="rat">
                <option value="Control 1">Control 1</option>
                <option value="Control 2">Control 2</option>
                <option value="Experimental 1">Experimental 1</option>
                <option value="Experimental 2">Experimental 2</option>
                <option value="Experimental 3">Experimental 3</option>
            </select>
        </div>
        Choose genome: <div class="btn-group">
            <input class="btn btn-default" type="submit" value="rn6" name="genome">
            <input class="btn btn-default" type="submit" value="rn4" name="genome">
        </div>
    </form>
    <br><br>
    <span class="col-sm-2"></span><br>
    <?php
        /*
            Here the URL to be submitted to the UCSC Genome browser is defined.
            The user is presented a form allowing them to choose the genome, either rn6 or rn4,
            and the rat whose bam file they wish to add as a custom track.
        */
        $rat = false;
        if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["genome"])){
        	$genome = htmlspecialchars($_POST["genome"]);
            if ($genome == "rn6") {
                switch ($_POST["rat"]) {
                    case "Control 1" : $rat = "sorted_control1_rn6.bam";
                        break;
                    case "Control 2" : $rat = "sorted_control2_rn6.bam";
                        break;
                    case "Experimental 1" : $rat = "sorted_afl4_rn6.bam";
                        break;
                    case "Experimental 2" : $rat = "sorted_afl6_rn6.bam";
                        break;
                    case "Experimental 3" : $rat = "sorted_afl8_rn6.bam";
                        break;
                }
            }
            else {
                switch ($_POST["rat"]) {
                    case "Control 1" : $rat = "sorted_control1_rn4.bam";
                        break;
                    case "Control 2" : $rat = "sorted_control2_rn4.bam";
                        break;
                    case "Experimental 1" : $rat = "sorted_afl4_rn4.bam";
                        break;
                    case "Experimental 2" : $rat = "sorted_afl6_rn4.bam";
                        break;
                    case "Experimental 3" : $rat = "sorted_afl8_rn4.bam";
                        break;
                }
            }
            $url = "https://genome.ucsc.edu/cgi-bin/hgTracks?db=$genome&position=$gene_id&hgct_customText=track%20type=bam%20name=Our_Bam_Track%20description=%22The%20BAM%20track%22%20visibility=dense%20bigDataUrl=https://s3.eu-west-2.amazonaws.com/bio-files-storage/$rat";
            $height = "550px";
            $width = "100%";
        }
    ?>
    <span class="col-sm-1"></span>
    <!-- 
        This div contains the genome browser. It is only visible if there is a server request and the user has
        defined which rat's BAM they wish to view.
    -->
    <div class="col-sm-10 center-block">
    <?php if ($rat && $_SERVER["REQUEST_METHOD"] == "POST" && $_POST["genome"]): ?>
        <p><?php echo "Current selection: Rat = ".$_POST["rat"].", Genome = ".$_POST["genome"].", Gene = $gene_name"; ?></p>
        <iframe src="<?php echo $url ?>" height="<?php echo $height ?>" width="<?php echo $width ?>"></iframe>
    <?php elseif ($_SERVER["REQUEST_METHOD"] == "POST" && !$rat && $_POST["genome"]): ?>
    <!-- If the user selects a genome but no rat the user is prompted to choose a rat. -->
    <p><strong>Select a rat then push one of the genome buttons.</strong></p><br>
    <?php endif; ?>
    </div>
    <span class="col-sm-1"></span>
</div>
<!-- Let's see who notices... -->
<footer class="container-fluid text-center">
    <a class="up-arrow" href="#section1" data-toggle="tooltip" title="TO TOP" style="color: white">
        <span class="glyphicon glyphicon-chevron-up"></span><br>To Top
    </a><br><br>
    <p>DEADRATS is a subsidiary of the Dank Bioinformatics Memes Corporation</p>
</footer>
</body>    