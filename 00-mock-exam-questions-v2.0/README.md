## Question 1

An NGINX Deploy named `nginx-static` is Running in the `nginx-static` NS. It is configured using a CfgMap named nginx-config. Update the nginx-config CfgMap to allow only TLSv1.3 connections.re-create, restart, or scale resources as necessary. By using command to test the changes:

[candidate@cka2025] $ curl --tls-max 1.2 [https://web.k8s.local](https://web.k8s.local/)

As TLSV1.2 should not be allowed anymore, the command should fail

## Question 2

Migrate an existing web application from Ingress to Gateway API.

We must maintain HTTPSuccess.

A GatewayClass named `nginx` is installed in the cluster.

First, create a Gateway named `web-gateway` with hostname gateway.web.k8s.local that maintains the existing TLS and listener configuration from the existing ingress resource named web.

Next, create an HTTPRoute named `web-route` with hostname gateway.web.k8s.local that maintains the existing routing rules from the current Ingress resource named web.

You can test your Gateway API configuration with the following command:

[candidate@cka2025] $ curl https:[//gateway.web.k8s.local](https://gateway.web.k8s.local/)

Finally, delete the existing Ingress resource named web.

## Question 3

Create a new HorizontalPodAutoscaler (HPA) named `apache-server`in the `autoscale`

namespace. This HPA mustītarget the existing Deployment called `apache-server` in the `autoscale` namespace.

Set the HPA to target for 50% CPU usage per Pod.

Configure hpa to have at min 1 Pod and no more than 4 Pods[max]. Also, we have to set the downscale stabilization window to 30 seconds.

## Question 4

Create a new Ingress resource `echo` in `echo-sound` namespace

Exposing Service `echoserver-service` on http://example.org/echo using Service port 8080

The availability of Service `echoserver-service` can be checked

using the following command, which should return 200:

[candidate@cka2025] $ curl -o /dev/null -s -w "%{http_code}\n“ http://example.org/echo

