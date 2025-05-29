# GCP-Project



gcloud compute ssh shaimaa-private-vm --zone=europe-west6-a --project=level-agent-460100-t6 --tunnel-through-iap


### add current user to docker  
sudo usermod -aG docker $USER


### How to install cloud Component
- curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-460.0.0-linux-x86_64.tar.gz

- tar -xf google-cloud-sdk-460.0.0-linux-x86_64.tar.gz
- ./google-cloud-sdk/install.sh
- source ~/.bashrc
-  gcloud components install gke-gcloud-auth-plugin



### connect to cluster 

STeps 
1- go to your cluster on console
2- click on connect 
3- copy the url (Command-line access) and paste it in instance terminal 




gcloud container clusters get-credentials shaimaa-private-gke-cluster --zone europe-west6-a --project level-agent-460100-t6



