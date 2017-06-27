<!DOCTYPE html>
<html>
<body>
    
    <?php
    $servername = "localhost";
    $username = "user";
    $password = "password";
    $db_name = "TestSeqDB";
    
    $conn = new mysqli($servername, $username, $password, $db_name);
    
    if ($conn -> connect_error) {
        die ("Connection failed: " . $conn -> connect_error);
    } else {
        echo "Connection successful :)";
    }
    ?>

    <?php
    $output = "";
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        $output = $_POST["name"];
    } else $output = "Did not get posted";
    ?>
    
<form action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>" method="post">
Gene: <input type="text" name="name" value="<?php echo $output; ?>"><br>
<input type="submit" name="submit">
</form>
    <?php
    $sql = "SELECT * FROM Experimental WHERE geneID = \"$output\"";
    $result = $conn -> query($sql);
    echo $sql . "<br>";
    $table = "<table> <tr> <th>Gene ID</th><th>Fold Change</th> <tr>";
    
    if ($result -> num_rows > 0) {
        while ($row = $result -> fetch_assoc()) {
            $table .= "<tr><td>".$row["geneID"]."</td><td>".$row["foldChange"]."</td></tr>";  
            //echo "gene: " .  $row["geneID"] . " " . "fold change: " . $row["foldChange"]."<br>";
        }
        echo $table;
    } else echo "<strong>No results today</strong>";
    ?>
    
</body>
</html>