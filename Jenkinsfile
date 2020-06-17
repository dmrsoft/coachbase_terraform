pipeline {
    agent {
    node {
        label 'jenkins-gts-slave'
           }
         }
    environment {
        BRANCH_NAME = "${env.BRANCH_NAME}"
        GIT_URL = scm.getUserRemoteConfigs()[0].getUrl()
     }
    stages {
        stage('tag') {
             when {
                branch 'master'
            }
            steps {
                withCredentials([usernamePassword(credentialsId: '7acb40ad-f9c8-468c-9705-fe2d6c76610f', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                sh '''#!/bin/bash
                GIT_REPO1=`echo $GIT_URL | cut -d"/" -f5 | cut -d"." -f1`
                echo "Working on repo: $GIT_REPO1 , Checkout & pull for Enable git release/tag"
                git checkout $BRANCH_NAME
                git pull https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/DimaNet/$GIT_REPO1

                echo "Git fetch tags to know the current Version"
                git fetch https://$GIT_USERNAME:$GIT_PASSWORD@github.com/DimaNet/$GIT_REPO1 --tags
                LAST_TAG=`git describe --abbrev=0`
                if [ -z "$LAST_TAG" ] ; then
                    LAST_TAG="v1.0.0"
                fi

                echo "Create new release number"
                IFS=. read major minor build <<< $LAST_TAG
                NEW_VERSION=$major.$minor.$((build+1))

                echo "About to tag with Version $NEW_VERSION"
                git tag -a $NEW_VERSION -m "Created in $BUILD_URL"
                git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/DimaNet/$GIT_REPO1 --follow-tags
               '''
              }
            }
        }
    }
}
