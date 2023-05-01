<?php
    // Load the session state into the environment for the CGI calls
    foreach($_SERVER as $key => $value)
        putenv("$key=$value");
    putenv("HTTP_X_SYNO_TOKEN=a");

    // Obtain the current Unraid state to get the CSRF token
    if (!isset($var)) $var = parse_ini_file('/usr/local/emhttp/state/var.ini');
    $csrftoken = $var["csrf_token"];
    
    $cmd = "tailscale --socket=/var/packages/Tailscale/var/tailscaled.sock web -cgi";
    $descriptorspec = array(
        0 => array("pipe", "r"),  // stdin is a pipe that the child will read from
        1 => array("pipe", "w"),  // stdout is a pipe that the child will write to
     );
    $process = proc_open($cmd, $descriptorspec, $pipes);

    if (is_resource($process)) {    
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            fwrite($pipes[0], $_POST['ts_data']); 
            fclose($pipes[0]);
        }
    
        $output = stream_get_contents($pipes[1]);
        fclose($pipes[1]);
        $return_value = proc_close($process);
    }

    $out = explode(PHP_EOL,$output);
    $out = array_slice($out,2);

    foreach($out as $line)
    {
        if(str_contains($line, 'function postData'))
        {
            // Inject a new fetch() function to handle the Unraid CSRF token
            $js = <<<EOD
            const { fetch: originalFetch } = window;

            window.fetch = async (...args) => {
                let [resource, config ] = args;
                
                var formBody = [];

                var encodedKey = encodeURIComponent("csrf_token");
                var encodedValue = encodeURIComponent("$csrftoken");
                formBody.push(encodedKey + "=" + encodedValue);

                encodedKey = encodeURIComponent("ts_data");
                encodedValue = encodeURIComponent(config.body);
                formBody.push(encodedKey + "=" + encodedValue);

                formBody = formBody.join("&");

                const formData = new FormData();

                console.log("In patched function");
                console.log(config.body);

                console.log(resource);
                console.log(formBody);

                return originalFetch(resource, {
                    method: "POST",
                    headers: {
                        "Accept": "application/json",
                        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                    },
                    body: formBody,
                });
            };

            EOD;
            echo ($js . PHP_EOL);
        }

        if(str_contains($line, 'document.location.href = url;'))
        {
            $line = 'window.open(url, "_blank");';
        }
        echo($line . PHP_EOL);
    }
?>