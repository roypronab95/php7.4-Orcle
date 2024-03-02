<?php

// // Host and port to check
// $host = '192.168.31.208';
// $port = 1521; // Change to the desired port

// // Timeout in seconds
// $timeout = 5;

// // Attempt to open a socket connection
// $socket = @fsockopen($host, $port, $errno, $errstr, $timeout);

// // Check if the socket connection was successful
// if ($socket) {
//     echo "Connection to $host on port $port succeeded.";
//     fclose($socket);
// } else {
//     echo "Connection to $host on port $port failed: $errstr ($errno)";
// }


// die;

// Oracle database connection settings
$host = '192.168.31.208'; // Change this to your Oracle database host
$port = '1521'; // Change this to your Oracle database port
$sid = 'XEPDB1'; // Change this to your Oracle database SID
$username = 'roy_portal'; // Change this to your Oracle database username
$password = 'roy_portal'; // Change this to your Oracle database password

// Attempt to establish a connection to the Oracle database
$conn = oci_connect($username, $password, "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$host)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$sid)))");

// Check if the connection was successful
if (!$conn) {
    $error = oci_error();
    die("Failed to connect to Oracle: " . $error['message']);
}

// Query example
$sql = "SELECT * FROM employees"; // Change this to your SQL query

// Prepare the SQL statement
$stmt = oci_parse($conn, $sql);

// Execute the SQL statement
$result = oci_execute($stmt);

// Check if the execution was successful
if (!$result) {
    $error = oci_error($stmt);
    die("Failed to execute query: " . $error['message']);
}

// Fetch the results
echo "<h1>Results:</h1>";
echo "<table border='1'>";
while ($row = oci_fetch_array($stmt, OCI_ASSOC+OCI_RETURN_NULLS)) {
    echo "<tr>";
    foreach ($row as $item) {
        echo "<td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "") . "</td>";
    }
    echo "</tr>";
}
echo "</table>";

// Clean up
oci_free_statement($stmt);
oci_close($conn);
?>
