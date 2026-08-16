# Test Proxy Server

[proxy_server.py](proxy_server.py) is a minimal HTTP/HTTPS forward proxy for manually
testing iCurlHTTP's "Override System Proxy" setting (see [issue #3](https://github.com/jasonacox/iCurlHTTP/issues/3)).
It's pure Python standard library, no dependencies required, and listens on
both IPv4 (`0.0.0.0`) and IPv6 (`[::]`) on the same port.

## Running It

```
python3 proxy_server.py [port]        # default port 8899
```

Each request it handles (or tunnels, for HTTPS) is logged to the terminal so
you can visually confirm traffic from iCurlHTTP is passing through it.

## New Settings

New settings option:

* Override System Proxy (check)
* Proxy: localhost:8899

<img width="500" alt="Image" src="https://github.com/user-attachments/assets/02d749ba-19fa-4a42-915f-40f31b1e1959" />

Leaving Proxy blank with the override checked forces iCurlHTTP to bypass any
proxy entirely (direct connection) - no server needed for that case.

## Example Connect Trace

Localhost IPv6 failed + IPv4 success and then IPv6 success (testing)

<img width="500" alt="Image" src="https://github.com/user-attachments/assets/2fc26902-415d-42ee-8061-203788f64522" />
<img width="500" alt="Image" src="https://github.com/user-attachments/assets/83058ff4-13d0-43cb-bb16-cb7e43a799fc" />
