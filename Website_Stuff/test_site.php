<!DOCTYPE html>
<html>
<body>
    
<form action="<?php echo $_SERVER["PHP_SELF"] ?>" method="post">
    <div class="form-group">
        <select class="form-control" name="get">
            <option value="1">1</option>
            <option value="2">2</option>
        </select>
        <input type="submit">
    </div>
</form>
    <?php
     if ($_SERVER["REQUEST_METHOD"] == "POST") {
         $output = $_POST["get"];
         echo $output;
     }
    ?>
</body>
</html>