pipeline {
  agent any
  stages {
    stage('install') {
      steps {
        sh 'bundle install'
      }
    }
    stage('compile') {
      steps {
        sh 'rake compile'
      }
    }
    stage('test') {
      steps {
        sh 'bundle exec rspec'
      }
    }
  }
  environment {
    CI = 'true'
  }
}
