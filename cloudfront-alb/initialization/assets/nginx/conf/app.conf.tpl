server {
    listen       80;
    listen       [::]:80;
    server_name  $UD_SERVER_NAME;

    set $frontend_endpoint $UD_FRONTEND;

    proxy_http_version      1.1;
    # Defines a timeout for establishing a connection with a proxied server
    proxy_connect_timeout 15; # 60s by default. It should be noted that this timeout cannot usually exceed 75 seconds.
    # Limits the time during which a request can be passed to the next server.
    proxy_next_upstream_timeout 15; # disabled by default

    location / {
        rewrite ^(.*)/$ $1/index.html;

        proxy_set_header Authorization '';

        proxy_pass http://$frontend_endpoint$request_uri;

        proxy_intercept_errors on;
        error_page 502 503 504 513 = @fallback;
        error_page 403 = @notfound;
    }

    location @fallback {
        return 200 "<html><body>Under maintenance</body></html>";
        add_header Content-Type text/html;
    }

    location @notfound {
        proxy_pass http://$frontend_endpoint/index.html;
    }
}