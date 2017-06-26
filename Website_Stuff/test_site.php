<!DOCTYPE html>
<html>
<body>

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
    <?php echo $output;?>
    
</body>
</html>