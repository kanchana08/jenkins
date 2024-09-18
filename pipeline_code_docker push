pipeline{ 
    agent any  
    stages{ 
        stage('checkout'){ 
            steps{ 
                git credentialsId: 'newPAT', url: 'https://github.com/kanchana08/docker-compose-sample.git'
                } 
            
        } 
        stage('docker build'){
            steps{
                sh 'docker build -t kanchana0812/pro:v1 .'
            
            }
        }
        stage('Login') {
			steps {
				sh 'echo Kanchu@08 | docker login -u kanchana0812 --password-stdin'
				
			
			}
		}
		stage('Push') {
			steps {
				sh 'docker push kanchana0812/pro:v1 '
			}
		}
    
        
        stage('logout') {
            steps {
                sh 'docker logout'
        }
        }
    } 
    
    
} 
