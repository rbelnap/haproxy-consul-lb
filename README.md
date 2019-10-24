
# haproxy-consul-lb

This project is meant to be a standalone lb solution with automatic service registration.  It should be flexible enough to let services started with the appropriate tags be configured in an appropriate way for serving through haproxy.  Eventually this vague description will be replaced with actual useful information.

## how to play with this

To start out, run:

```docker-compose up --build -d```

This should start you out with the required services.  You'll probably need to figure out your own particular network situation to access the server, but the consul ui can be accessed on port 8500, the haproxy stats ui can be found on port 1936, and haproxy itself has an http listener on 8080

(you can get most of this info from docker-compose.yml)

then, bring up some helloworld services (I use nginxdemos/hello):

```for i in {1..5}; do docker run --rm --network lbtest_default -d -P -e SERVICE_NAME=hi -e SERVICE_TAGS=web -e SERVICE_CHECK_HTTP='/' --name hi$i nginxdemos/hello; done```

The haproxy conf template will be updated with the service name at `/$SERVICE_NAME/` url, _if_ it has the tag "web".  You should be able to hit the http://hostname:8080/hi/ url and see the response from the load balanced containers, as well as see the backend updated in the haproxy stats interface.

stop these demos with

```for i in {1..5}; do docker stop  hi$i; done```

and observe them leave

