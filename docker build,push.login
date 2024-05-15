[]we need to get docker login code, for that go to Pipeline Syntax (in writting pipeline code in down side we have Pipeline Syntax option ), 
[]select with credential:bind credential to veriable.
[]select Add in that select Secret text, in Variable give any name and in Credentials, go to Add in Kind select Secret text and in Secret give dockerhub password, and in ID give whatever and Add 
[] generate pipeline script 

pipeline {
    environment {
        registry = "kanchana0812/projnew"
        
    }
    agent any 
    stages
    { 
        stage('Checkout')
        {
            steps
            { 
                git credentialsId: 'GIT_PATH', url: 'https://github.com/kanchana08/Dockerfile_python.git'
                }
            
        }
        stage('Build')
        { 
            steps
            {
                script
                {
                    sh 'docker system prune -af'
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                    
                }
                
            } 
            
        }
        stage('Stop and Remove Previous Container')
        {
            steps
            {
                script
                { 
                    sh "docker stop sampleapplication || true && docker rm sampleapplication || true" 
                    
                }
                
            }
            
        }
        stage('Run Docker Container')
        {
            steps {
                script {
                    sh"docker run --rm -dit --name sampleapplication -p 8081:5001 kanchana0812/projnew:${BUILD_NUMBER}"
                    
                }
                
            }
            
        }
        stage('Deploy our image')
        {
            steps
            {
                script
                {
                    withCredentials([string(credentialsId: 'Docker_PSW', variable: 'dockerpsw')]) {
                        sh 'docker login -u kanchana0812 -p ${dockerpsw} '
                        sh 'docker push kanchana0812/projnew:$BUILD_NUMBER'
                        
                    }
                    
                }
                
            }
        }
    }
}


===================================================================================================================================================================================


pipeline {
    environment {
        registry = "kanchana0812/projnew"
        CONTAINER_NAME = 'sampleapplication' 
        DOCKER_IMAGE_NAME = 'kanchana0812/projnew'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        
    }
    agent any
    stages {
        stage('Checkout') {
            steps { 
                git credentialsId: 'GIT_PATH', url: 'https://github.com/kanchana08/Dockerfile_python.git'
                
            }
            
        }
        stage('Build') { 
            steps {
                script {
                    sh 'docker system prune -af'
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                    
                }
                
            }
            
        }
        stage('Stop and Remove Previous Container') {
            steps { 
                script {
                    sh "docker stop ${CONTAINER_NAME} || true && docker rm ${CONTAINER_NAME} || true" 
                    
                } 
            } 
        }
        stage('Run Docker Container') {
            steps {
                script {
                    sh"docker run --rm -dit --name ${CONTAINER_NAME} -p 8081:5001 ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    
                } 
            } 
        } 
        stage('Deploy our image') {
            steps{
                script{
                    withCredentials([string(credentialsId: 'Docker_PSW', variable: 'dockerpsw')]) {
                        sh 'docker login -u kanchana0812 -p ${dockerpsw} '
                        sh 'docker push kanchana0812/projnew:$BUILD_NUMBER'
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}





