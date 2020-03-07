node {
    def app
    def port = "9442"
    def local = "127.0.0.1"
    def current 
    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */


        app = docker.build("jungee/go:v"+"$BUILD_NUMBER")

    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */
        app.withRun("-p ${port}:8800"){c -> 
	   value = sh(returnStdout: true, script:"""curl -i http://${local}:${port}/""").trim()
           if (value == "<h1>This is the siknucha in dev branch. Try /hello and /hello/Sammy</h1>"){
		current = "PASS"
            }else{
              current = "FAILURE"
            }
           echo "$value"
        }
        echo "$c"
        echo "$currentBuild.result"	
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */

        docker.withRegistry('https://registry.hub.docker.com', 'docker') {

            app.push("v${env.BUILD_NUMBER}")
            app.push("v${env.BUILD_NUMBER}")
        }
    }
}
