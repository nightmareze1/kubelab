➜  gke gcloud auth login
Your browser has been opened to visit:

    https://accounts.google.com/o/oauth2/auth?redirect_uri=http%3A%2F%2Flocalhost%3A8085%2F&prompt=select_account&response_type=code&client_id=32555940559.apps.googleusercontent.com&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcloud-platform+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fappengine.admin+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fcompute+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Faccounts.reauth&access_type=offline


WARNING: `gcloud auth login` no longer writes application default credentials.
If you need to use ADC, see:
  gcloud auth application-default --help

You are now logged in as [ezequiel.arielli@rappi.com].
Your current project is [kube-204921].  You can change this setting by running:
  $ gcloud config set project PROJECT_ID


Updates are available for some Cloud SDK components.  To install them,
please run:
  $ gcloud components update

➜  gke gcloud config set project kubetest-220610
Updated property [core/project].
➜  gke gcloud container clusters create kubetest

➜  gke gcloud container clusters create kubetest   --machine-type=n1-standard-1 --region=us-east1 --num-nodes=2 --enable-autorepair --enable-autoscaling --min-nodes=1 --max-nodes=3 --scopes=service-control,service-management,compute-rw,storage-ro,cloud-platform,logging-write,monitoring-write,pubsub,datastore
This will enable the autorepair feature for nodes. Please see
https://cloud.google.com/kubernetes-engine/docs/node-auto-repair for more
information on node autorepairs.

Creating cluster kubetest...done.
Created [https://container.googleapis.com/v1/projects/kubetest-220610/zones/us-east1/clusters/kubetest].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/us-east1/kubetest?project=kubetest-220610
kubeconfig entry generated for kubetest.
NAME      LOCATION  MASTER_VERSION  MASTER_IP      MACHINE_TYPE   NODE_VERSION  NUM_NODES  STATUS
kubetest  us-east1  1.9.7-gke.6     35.231.159.83  n1-standard-1  1.9.7-gke.6   6          RUNNING

➜  gke k get nodes
NAME                                      STATUS    ROLES     AGE       VERSION
gke-kubetest-default-pool-21fbd157-8ftj   Ready     <none>    56s       v1.9.7-gke.6
gke-kubetest-default-pool-21fbd157-ckqs   Ready     <none>    49s       v1.9.7-gke.6
gke-kubetest-default-pool-ab3fa9fa-1vg4   Ready     <none>    1m        v1.9.7-gke.6
gke-kubetest-default-pool-ab3fa9fa-6lc2   Ready     <none>    1m        v1.9.7-gke.6
gke-kubetest-default-pool-fc03e629-f99m   Ready     <none>    54s       v1.9.7-gke.6
gke-kubetest-default-pool-fc03e629-fbvr   Ready     <none>    1m        v1.9.7-gke.6

# Install helm manager.
➜  gke kubectl create serviceaccount --namespace kube-system tiller

➜  gke kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

➜  gke kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'      
helm init --service-account tiller --upgrade

➜  gke helm install --name nginx-ingress stable/nginx-ingress --set rbac.create=true

➜  gke helm ls
NAME         	REVISION	UPDATED                 	STATUS  	CHART               	APP VERSION	NAMESPACE
nginx-ingress	1       	Fri Oct 26 08:17:45 2018	DEPLOYED	nginx-ingress-0.19.2	0.14.0     	default

➜  gke k get po |grep ingress
nginx-ingress-controller-7d745cf7b-9vqvr        1/1       Running   0          38s

➜  gke helm ls
NAME         	REVISION	UPDATED                 	STATUS  	CHART               	APP VERSION	NAMESPACE
nginx-ingress	1       	Fri Oct 26 08:17:45 2018	DEPLOYED	nginx-ingress-0.19.2	0.14.0     	default
➜  gke k get po |grep ingress
nginx-ingress-controller-7d745cf7b-9vqvr        1/1       Running   0          38s
nginx-ingress-default-backend-c6f8f7b87-wnsfq   1/1       Running   0          38s

➜  gke k get svc
NAME                            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
kubernetes                      ClusterIP      10.15.240.1     <none>        443/TCP                      6m
nginx-ingress-controller        LoadBalancer   10.15.246.32    <pending>     80:31088/TCP,443:30262/TCP   53s
nginx-ingress-default-backend   ClusterIP      10.15.244.213   <none>        80/TCP                       53s

➜  gke k get svc
NAME                            TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                      AGE
kubernetes                      ClusterIP      10.15.240.1     <none>           443/TCP                      6m
nginx-ingress-controller        LoadBalancer   10.15.246.32    35.196.125.129   80:31088/TCP,443:30262/TCP   1m
nginx-ingress-default-backend   ClusterIP      10.15.244.213   <none>           80/TCP
nginx-ingress-default-backend-c6f8f7b87-wnsfq   1/1       Running   0          38s

➜  kube-test k create ns staging
namespace/staging created

➜  kube-test k create ns production
namespace/production created

➜  kube-test k create -f redis-master.yml
deployment.apps/redis-master created

➜  kube-test k get deploy,po -n staging
NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.extensions/redis-master   1         1         1            0           13s

NAME                                READY     STATUS              RESTARTS   AGE
pod/redis-master-585798d8ff-x2mwj   0/1       ContainerCreating   0          12s

➜  kube-test k get deploy,po -n staging
NAME                                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.extensions/redis-master   1         1         1            1           26s

NAME                                READY     STATUS    RESTARTS   AGE
pod/redis-master-585798d8ff-x2mwj   1/1       Running   0          25s

➜  kube-test k logs -f pod/redis-master-585798d8ff-x2mwj -n staging
                _._
           _.-``__ ''-._
      _.-``    `.  `_.  ''-._           Redis 2.8.19 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
 (    '      ,       .-`  | `,    )     Running in stand alone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 1
  `-._    `-._  `-./  _.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |           http://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
 |`-._`-._    `-.__.-'    _.-'_.-'|
 |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
      `-._    `-.__.-'    _.-'
          `-._        _.-'
              `-.__.-'

[1] 26 Oct 11:25:58.186 # Server started, Redis version 2.8.19
[1] 26 Oct 11:25:58.186 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
[1] 26 Oct 11:25:58.186 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
[1] 26 Oct 11:25:58.186 * The server is now ready to accept connections on port 6379

➜  kube-test ls
redis-master.yml

➜  kube-test vi svc-redis-master.yml

➜  kube-test k create -f svc-redis-master.yml
service/redis-master created

➜  kube-test k create -f redis-slave.yml
deployment.apps/redis-slave created

➜  kube-test k get pods -n staging
NAME                            READY     STATUS    RESTARTS   AGE
redis-master-585798d8ff-x2mwj   1/1       Running   0          3m
redis-slave-865486c9df-lbpjk    1/1       Running   0          27s
redis-slave-865486c9df-znbzh    1/1       Running   0          27s

➜  kube-test vi svc-redis-slave.yml

➜  kube-test k create -f svc-redis-slave.yml
service/redis-slave created

➜  kube-test k get svc -n staging
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
redis-master   ClusterIP   10.15.240.23    <none>        6379/TCP   2m
redis-slave    ClusterIP   10.15.255.107   <none>        6379/TCP   7s

➜  kube-test vi svc-frontend-app.yml

➜  kube-test k create -f svc-frontend-app.yml
service/frontend created

➜  kube-test k get svc -n staging
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
frontend       NodePort    10.15.242.196   <none>        80:31928/TCP   10s
redis-master   ClusterIP   10.15.240.23    <none>        6379/TCP       6m
redis-slave    ClusterIP   10.15.255.107   <none>        6379/TCP       3m

➜  kube-test k create -f ing-frontend-service.yml
ingress.extensions/frontend created

add to my /etc/hosts 3
5.196.125.129 staging-guestbook.mstakx.io
35.196.125.129 guestbook.mstakx.io

➜  kube-test cp -R staging-frontend production-frontend

➜  kube-test ls
production-frontend staging-frontend

➜  kube-test cd production-frontend

➜  production-frontend ls
deploy-frontend-app.yml  ing-frontend-service.yml redis-master.yml         redis-slave.yml          svc-frontend-app.yml     svc-redis-master.yml     svc-redis-slave.yml

➜  production-frontend vi deploy-frontend-app.yml

➜  production-frontend vi ing-frontend-service.yml

➜  production-frontend vi redis-master.yml

➜  production-frontend vi redis-slave.yml

➜  production-frontend ls
deploy-frontend-app.yml  ing-frontend-service.yml redis-master.yml         redis-slave.yml          svc-frontend-app.yml     svc-redis-master.yml     svc-redis-slave.yml

➜  production-frontend vi ing-frontend-service.yml

➜  production-frontend ls
deploy-frontend-app.yml  ing-frontend-service.yml redis-master.yml         redis-slave.yml          svc-frontend-app.yml     svc-redis-master.yml     svc-redis-slave.yml

➜  production-frontend vi svc-frontend-app.yml

➜  production-frontend egrep -r staging .
./ing-frontend-service.yml:  - host: staging-guestbook.mstakx.io
./svc-redis-master.yml:  namespace: staging
./svc-redis-slave.yml:  namespace: staging

➜  production-frontend vi svc-redis-master.yml

➜  production-frontend vi svc-redis-slave.yml

➜  production-frontend ls
deploy-frontend-app.yml  ing-frontend-service.yml redis-master.yml         redis-slave.yml          svc-frontend-app.yml     svc-redis-master.yml     svc-redis-slave.yml

➜  production-frontend vi ing-frontend-service.yml

➜  production-frontend k create -f .

➜  production-frontend egrep -r staging .

➜  production-frontend vi svc-redis-slave.yml

➜  production-frontend k create -f .
deployment.apps/frontend created
ingress.extensions/frontend created
deployment.apps/redis-master created
deployment.apps/redis-slave created
service/frontend created
service/redis-master created
service/redis-slave created
➜  production-frontend curl -I -XGET -H"Host: guestbook.mstakx.io" http://35.196.125.129
HTTP/1.1 200 OK
Server: nginx/1.13.12
Date: Fri, 26 Oct 2018 13:23:17 GMT
Content-Type: text/html
Content-Length: 921
Connection: keep-alive
Vary: Accept-Encoding
Last-Modified: Wed, 09 Sep 2015 18:35:04 GMT
ETag: "399-51f54bdb4a600"
Accept-Ranges: bytes
Vary: Accept-Encoding

![alt text](https://raw.githubusercontent.com/nightmareze1/kubelab/master/6.png)

➜  production-frontend curl -XGET -H"Host: guestbook.mstakx.io" http://35.196.125.129
<html ng-app="redis">
  <head>
    <title>Guestbook</title>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.12/angular.min.js"></script>
    <script src="controllers.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.13.0/ui-bootstrap-tpls.js"></script>
  </head>
  <body ng-controller="RedisCtrl">
    <div style="width: 50%; margin-left: 20px">
      <h2>Guestbook</h2>
    <form>
    <fieldset>
    <input ng-model="msg" placeholder="Messages" class="form-control" type="text" name="input"><br>
    <button type="button" class="btn btn-primary" ng-click="controller.onRedis()">Submit</button>
    </fieldset>
    </form>
    <div>
      <div ng-repeat="msg in messages track by $index">
        {{msg}}
      </div>
    </div>
    </div>
  </body>
</html>

![alt text](https://raw.githubusercontent.com/nightmareze1/kubelab/master/5.png)

➜  production-frontend curl -XGET -H"Host: staging-guestbook.mstakx.io" http://35.196.125.129
<html ng-app="redis">
  <head>
    <title>Guestbook</title>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.2.12/angular.min.js"></script>
    <script src="controllers.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.13.0/ui-bootstrap-tpls.js"></script>
  </head>
  <body ng-controller="RedisCtrl">
    <div style="width: 50%; margin-left: 20px">
      <h2>Guestbook</h2>
    <form>
    <fieldset>
    <input ng-model="msg" placeholder="Messages" class="form-control" type="text" name="input"><br>
    <button type="button" class="btn btn-primary" ng-click="controller.onRedis()">Submit</button>
    </fieldset>
    </form>
    <div>
      <div ng-repeat="msg in messages track by $index">
        {{msg}}
      </div>
    </div>
    </div>
  </body>
</html>

➜  production-frontend vi autoscaling.yml

➜  production-frontend k create -f autoscaling.yml
horizontalpodautoscaler.autoscaling/frontend created

➜  production-frontend k get hpa
No resources found.

➜  production-frontend k get hpa -n production
NAME       REFERENCE             TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
frontend   Deployment/frontend   <unknown>/30%   1         5         0          9s

in another terminal i up 10 load-generator application using this
➜ kubectl run -i --tty load-generator-1 --image=busybox /bin/sh --namespace production
while true; do wget -q -O- http://frontend ;done

![alt text](https://raw.githubusercontent.com/nightmareze1/kubelab/master/3.png)

Every 2.0s: kubectl top po -n production                                                                      ntkzz.local: Fri Oct 26 10:45:56 2018

NAME                                CPU(cores)   MEMORY(bytes)
frontend-67f65745c-7r4x8            37m          6Mi
frontend-67f65745c-n87l4            38m          6Mi
load-generator-16-f785db896-4dz2r   42m          0Mi
load-generator-2-558d9cbb64-vvxk5   20m          0Mi
load-generator-3-849c566884-549jt   20m          0Mi
load-generator-4-6769b8bd7b-2nlmh   18m          0Mi
load-generator-5-644494c48-6dlrw    18m          0Mi
load-generator-7-779b5987f6-ww5zk   41m          0Mi
redis-master-585798d8ff-68dc5       0m           0Mi
redis-slave-865486c9df-q5x2g        0m           1Mi
redis-slave-865486c9df-xt9nn        0m           1Mi

➜  watch kubectl get hpa -n production
Every 2.0s: kubectl get hpa -n production                                                                                                                                                                                                                         ntkzz.local: Fri Oct 26 10:43:18 2018

NAME       REFERENCE             TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
frontend   Deployment/frontend   49%/30%   1         5         2          14m

➜  ~ k delete deploy -n production $(k get deploy -n production |grep load-generator | awk '{print $1}' )
deployment.extensions "load-generator-16" deleted
deployment.extensions "load-generator-2" deleted
deployment.extensions "load-generator-3" deleted
deployment.extensions "load-generator-4" deleted
deployment.extensions "load-generator-5" deleted
deployment.extensions "load-generator-7" deleted

➜  staging-frontend k create -f autoscaling.yml
horizontalpodautoscaler.autoscaling/frontend created

# I repeat the similar test with staging-guestbook
kubectl run -i --tty load-generator-16 --image=busybox /bin/sh --namespace staging
while true; do wget -q -O- http://frontend ;done

![alt text](https://raw.githubusercontent.com/nightmareze1/kubelab/master/4.png)

Every 2.0s: kubectl get hpa -n staging                                                                                                                                                                                                                            ntkzz.local: Fri Oct 26 10:50:55 2018

NAME       REFERENCE             TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
frontend   Deployment/frontend   0%/30%    1         5         3          40s

Every 2.0s: kubectl top po -n staging                                                                        ntkzz.local: Fri Oct 26 10:55:18 2018

NAME                                CPU(cores)   MEMORY(bytes)
frontend-67f65745c-bg95m            0m           6Mi
load-generator-16-f785db896-w5v8h   0m           0Mi
load-generator-2-558d9cbb64-97z4x   0m           0Mi
load-generator-3-849c566884-lw9vw   0m           0Mi
load-generator-4-6769b8bd7b-m5zbq   0m           0Mi
load-generator-5-644494c48-7bxx4    0m           0Mi
load-generator-7-779b5987f6-gdr9t   0m           0Mi
redis-master-585798d8ff-x2mwj       1m           0Mi
redis-slave-865486c9df-lbpjk        1m           1Mi
redis-slave-865486c9df-znbzh        1m           1Mi

Every 2.0s: kubectl get hpa -n staging                                                                                                                                                                                                                            ntkzz.local: Fri Oct 26 10:58:17 2018

NAME       REFERENCE             TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
frontend   Deployment/frontend   75%/30%   1         5         1          8m

Every 2.0s: kubectl get hpa -n staging                                                                                                                                                                                                                            ntkzz.local: Fri Oct 26 10:59:13 2018

NAME       REFERENCE             TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
frontend   Deployment/frontend   79%/30%   1         5         3          8m

➜  staging-frontend kubectl get po -n staging
NAME                                READY     STATUS    RESTARTS   AGE
frontend-67f65745c-78252            1/1       Running   0          48s
frontend-67f65745c-bg95m            1/1       Running   0          2h
frontend-67f65745c-xgwcc            1/1       Running   0          48s
load-generator-16-f785db896-5c6s8   1/1       Running   0          1m
load-generator-2-558d9cbb64-tsrbr   1/1       Running   0          1m

![alt text](https://raw.githubusercontent.com/nightmareze1/kubelab/master/1.png)

![alt text](https://raw.githubusercontent.com/nightmareze1/kubelab/master/2.png)

load-generator-3-849c566884-5ltvx   1/1       Running   0          1m
load-generator-4-6769b8bd7b-chdx8   1/1       Running   0          1m
load-generator-5-644494c48-f72xz    1/1       Running   0          1m
load-generator-7-779b5987f6-9v5nb   1/1       Running   0          1m
redis-master-585798d8ff-x2mwj       1/1       Running   0          2h
redis-slave-865486c9df-lbpjk        1/1       Running   0          2h
redis-slave-865486c9df-znbzh        1/1       Running   0          2h

➜  app1 k delete deploy -n staging $(k get deploy -n staging |grep load-generator | awk '{print $1}' )
deployment.extensions "load-generator-16" deleted
deployment.extensions "load-generator-2" deleted
deployment.extensions "load-generator-3" deleted
deployment.extensions "load-generator-4" deleted
deployment.extensions "load-generator-5" deleted
deployment.extensions "load-generator-7" deleted

