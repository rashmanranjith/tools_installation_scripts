##Install in Amazon Ubuntu
sudo usermod -aG docker $USER
docker pull docker.bintray.io/jfrog/artifactory-oss:latest
sudo mkdir -p /jfrog/artifactory
sudo chown -R 1030 /jfrog/
docker run --name artifactory -d -p 8081:8081 -p 8082:8082 -v /jfrog/artifactory:/var/opt/jfrog/artifactory docker.bintray.io/jfrog/artifactory-oss:latest

New steps:
docker pull releases-docker.jfrog.io/jfrog/artifactory-oss:latest
docker run -d \
  --name artifactory \
  -p 8081:8081 \
  -p 8082:8082 \
  releases-docker.jfrog.io/jfrog/artifactory-oss:latest



New steps by using docker compose:

Perform System update:
sudo apt update

Install Docker-Compose:
sudo apt install docker-compose -y

Create docker-compose.yml:
this yml has all the configuration for installing Artifactory on Ubuntu EC2.
sudo vi docker-compose.yml 

(Copy the below code )
version: "3.3"
services:
  artifactory-service:
    image: docker.bintray.io/jfrog/artifactory-oss:7.49.6
    container_name: artifactory
    restart: always
    networks:
      - ci_net
    ports:
      - 8081:8081
      - 8082:8082
    volumes:
      - artifactory:/var/opt/jfrog/artifactory

volumes:
  artifactory:
networks:
  ci_net:

Save the file by entering :wq!

Now execute the compose file using Docker compose command to start Artifactory Container:
sudo docker-compose up -d 

Make sure Artifactory is up and running:
sudo docker-compose logs --follow

Check Artifactory is up and running by typing below command:
curl localhost:8081

Now access Artifactory UI by going to browser and enter public dns name with port 8081
http://change to_artifactory_publicdns_name:8081

To Push the Jar file to Jfrog Artifactory:
curl -X PUT -u admin \
  -T kubernetes-configmap-reload-0.0.1-SNAPSHOT.jar \
  http://<EC2IP>:8082/artifactory/example-repo-local/

