pipeline{
	agent any

	environment {
		NEXUS_URL = "http://ec2-3-138-174-41.us-east-2.compute.amazonaws.com:8081/"
		
	}
	stages{
		stage ('1-git-clone'){
			steps{
				checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'git-id', url: 'https://github.com/pretei45/java-test.git']])
			}
		}
		stage ('2-Maven Build'){
			steps{
				sh 'mvn clean package'
			}
		}
		stage ('3-Code Quality Analysis'){
			steps{
				sh 'mvn clean verify sonar:sonar \
                -Dsonar.projectKey=practicecodereview \
                -Dsonar.projectName='practicecodereview' \
                -Dsonar.host.url=http://ec2-3-144-237-156.us-east-2.compute.amazonaws.com:9000 \
                -Dsonar.token=sqp_8184006574c8ab4e7098cddfac2cc17fb39a83ac'
			}
		}
		stage ('4-Nexus Backup'){
			steps{
				withCredentials([usernamePassword(credentialsId: 'nexus-id', usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]) {
                    sh "docker tag simple-web-app:latest ${NEXUS_URL}/simple-web-app:latest"
                    sh "docker login -u ${NEXUS_USERNAME} -p ${NEXUS_PASSWORD} ${NEXUS_URL}"
                    sh "docker push ${NEXUS_URL}/simple-web-app:latest"
				}	
			}
		}
        stage ('5-Image Build'){
            steps{
                sh "docker build -t simple-web-app ."
            }
        }
		stage ('6-Deploy'){
			steps{
				sh 'docker run -p 8080:8080 simple-web-app:latest'
			}
		}
	}
}