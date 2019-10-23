@Library("workflowlibs") _

pipeline { 
  agent { label env.sf_node }
  stages {
    stage('Checkout Global Library') {
      steps {
        script {
          globalBootstrap {
            libraryName = 'Ether.Salesforce'
            libraryBranch = 'latest'
            entrypointParams = [:]
          }
        }
      }
    }
  }
}
