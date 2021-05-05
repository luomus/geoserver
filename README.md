# TODO

UPDATE THIS DOCUMENTATION -UPDATED

# Create persitant volumes

* backrestrepo
* backup
* pgconf
* pgdata

## Import
1. env-secrets.yaml
2. db-pod.yaml
3. db-service.yaml


## Login to openshift with oc command and run commands:
1.  `oc new-build --binary=true --image-stream=jboss-webserver31-tomcat8-openshift:1.2 --name=geoserver`
2.  `cd geoserver-2.18.1` (you can download one and extract the files in this folder)
3.  `jar -cvf ROOT.war *` Build war that has all the needed extensions
4.  `oc start-build geoserver --from-dir=./  --follow` (Just building with custom war is not working for some reason???? `oc start-build geoserver --from-file=ROOT.war --follow`)
5.  `oc new-app geoserver`
6.  `oc set volume dc/geoserver --add --name=geoserver-data -t pvc --claim-class=pomppa24 --claim-name=geoserver-claim --claim-size=3G --mount-path=/geoserver-data`
7.  `oc set volume dc/geoserver --add --name=geoserver-lib -t pvc --claim-class=pomppa24 --claim-name=geoserver-lib --claim-size=500Mi --mount-path=/opt/webserver/webapps/ROOT/WEB-INF/lib`
8.  `cd..`
10. `oc get pods` (note the running geoserver pod name)
11. Install postgis using instructions in the openshift folder
12. `./update.sh`

## Add route
* add [public route](https://console-openshift-console.apps.ocp-prod-0.k8s.it.helsinki.fi/k8s/ns/luomus-geoserver/routes) from the os console

## Adding extensions to geoserver
1. download geoserver war file
2. make directory `geoserver-<version>`
3. cd to that directory and copy the geoserver.war there
4. deflate the war file `jar -xvf geoserver.war`
5. add the extensions to WEB-INF/lib folder
6. build the war and deploy with oc
