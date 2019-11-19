
# haproxy-consul-lb

This project is meant to be a standalone lb solution with automatic service registration.  It should be flexible enough to let services started with the appropriate tags be configured in an appropriate way for serving through haproxy.  Eventually this vague description will be replaced with actual useful information.

## environment variables for haproxy container

HTTP_LISTEN: true/false  determines if there will be an http listener.  Otherwise only the https listener will be started.

## service tags used by haproxy

`vhostname=virtualhost.name.org` Set this to define virtual host names that the lb will route to the service.  Can be specified more than once.
`web` This controls if a backend will be created.  You'll want most services to define this, it could probably be named better.

## how to play with this

To start out, run:

```docker-compose up --build -d```

This should start you out with the required services.  You'll probably need to figure out your own particular network situation to access the server, but the consul ui can be accessed on port 8500, the haproxy stats ui can be found on port 1936, and haproxy itself has an http listener on 8080

(you can get most of this info from docker-compose.yml)

then, bring up some helloworld services (I use nginxdemos/hello):

```for i in {1..5}; do docker run --rm --network lbtest_default -d -P -e SERVICE_NAME=hi -e SERVICE_TAGS=web -e SERVICE_CHECK_HTTP='/' --name hi$i nginxdemos/hello; done```

The haproxy conf template will route to vhosts as defined by tags, _if_ it has the tag "web".  You should be able to hit the http://vhostname url and see the response from the load balanced containers, as well as see the backend updated in the haproxy stats interface.

stop these demos with

```for i in {1..5}; do docker stop  hi$i; done```

and observe them leave

## some useful things

Because you can define port forwarding for multiple ips, you can have internal and external hosts.  Just define the appropriate vhostname, and you're set, for example, you can set forwards via docker:

pub.lic.ip.addr:443:443
pri.vate.ip.addr:443:443

You can then set SERVICE_TAGS=web,vhostname\=service.public.ip.name.org,vhostname\=service.private.ip.name.org and assuming those names resolve to their respective ips, the service will be available at both.  Note: your private services will then be exposed publicly via simple Host: header spoofing if you do this.  

You can also expose the dns port for consul on a different local ip.
