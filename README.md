jenkins-plugins-collection
==========================

Introduction
------------
This project builds a Docker image that contains pre-loaded Jenkins plugins.

The Docker images are hosted on hub.docker.com as "opendevopsrepo/jenkins-plugins-collection:VERSION" and contain a /plugins directroy that contains the pre-loaded Jenkins plugins.

You can see all avalable versions under
(https://hub.docker.com/r/opendevopsrepo/jenkins-plugins-collection/tags)


How to use the Docker image
---------------------------
Here is an (stupid) example of using such Docker image (in real live you will probably combine such Docker image with other Docker images, e.g. in a Kubernetes environment):

    # show all plugins
    #docker run --rm opendevopsrepo/jenkins-plugins-collection:jenkins.2.289-pluginset.1-20211113 ls -l /plugins
    docker run --rm opendevopsrepo/jenkins-plugins-collection:jenkins.2.319.1-pluginset.2-20220119-2 ls -l /plugins

    # show the versions of the specified plugins (i.e. without the dependencies):
    #docker run --rm opendevopsrepo/jenkins-plugins-collection:jenkins.2.289-pluginset.1-20211113 cat /src/plugins.txt
    docker run --rm opendevopsrepo/jenkins-plugins-collection:jenkins.2.319.1-pluginset.2-20220119-2 cat /src/plugins.txt

    # safe cleanup
    docker system prune
    # or full cleanup (delete all local docker images)
    docker system prune -a --volumes


How to build for a different Jenkins version
--------------------------------------------

Change the Jenkins version in:

    # update specification
    vi Dockerfile
    vi VERSION
    # maybe you also want or need to update plugins.txt (see next section)

    # push
    git add -A .
    git commit -m "Updated Jenkins version"
    git push

About a minute after git push the new Docker image should be available
as opendevopsrepo/jenkins-plugins-collection:VERSION.
You can check the availability under
(https://hub.docker.com/r/opendevopsrepo/jenkins-plugins-collection/tags)


How to build with an updated plugins.txt
----------------------------------------

    # update specification
    vi plugins.txt
    vi VERSION
    
    # push
    git add -A .
    git commit -m "Updated plugins.txt"
    git push

About a minute after git push the new Docker image should be available
as opendevopsrepo/jenkins-plugins-collection:VERSION. 
You can check the availability under
(https://hub.docker.com/r/opendevopsrepo/jenkins-plugins-collection/tags)


How to retrieve the latest plugin versions to set them in plugins.txt
---------------------------------------------------------------------

    # run locally, not on CI
    # (downloads and later removes all plugins - 
    #  so it can take a while depending on your internet connection)
    awk -F ':' < plugins.txt 'NF {print $1":latest"}' | grep -v "#" > /tmp/plugins-latest.txt
    cat /tmp/plugins-latest.txt | docker run --rm -i jenkins/jenkins:2.319.1-jdk11 /usr/local/bin/install-plugins.sh | tee /tmp/plugins-latest.txt

    # then take the version numbers of the from the actually used plugins
    # from the end of the output in section "Installed plugins:"
    # and use them as version numbers in "plugins.txt"
    diff plugins.txt /tmp/plugins-latest.txt
    vi /tmp/plugins-latest.txt

    # safe cleanup
    rm /tmp/plugins-latest.txt
    docker system prune
    # or full cleanup (delete all local docker images)
    rm /tmp/plugins-latest.txt
    docker system prune -a --volumes
        

How to fork this repo and its automatic CI builds
-------------------------------------------------
* have a GitHub.com and a hub.docker.com account ready
* fork this git repo into your own GitHub.com repo
* create an hub.docker.com access token (https://hub.docker.com/settings/security)
* set this hub.docker.com access token in your GitHub.com repo settings/secrets (https://github.com/your-GitHub.com-username/your-GitHub.com-repo-name/settings/secrets/actions)
    * set DOCKERHUB_USERNAME={your hub.docker.com user name}
    * set DOCKERHUB_TOKEN={your hub.docker.com access token from above}
* in .github/workflows/github-actions.yml replace tag "opendevopsrepo/jenkins-plugins-collection" with "{your hub.docker.com username}/{your new hub.docker.com repo name}"
* set a Readme text on hub.docker.com (https://hub.docker.com/repository/docker/your-hub.docker.com-username/your-new-hub.docker.com-repo-name/general)

After this setup, every push to "main" branch in your GitHub.com repo should trigger a CI build (GitHub action) that uploads the docker image to your hub.docker.com repo.

