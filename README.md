# React, Nginx and Self Signed TLS Certificate

### Running the project
1. Run `git clone https://github.com/SamWanekeya/dockerizing-react-js-with-nginx-and-self-signed-ssl-certificate.git .`
2. Be sure to replace `samwanekeya.com` domain with your own domain
4. Run `sh frontend_deploy.sh` from the project root folder to build the images and run the containers
5. Run `sh frontend_destroy.sh` from the project root folder to destroy the running containers
6. Test it out at [https://localhost](https://localhost). No mounted folders. To apply changes, the image must be re-built.


### Contributing

1. Fork this repo and make changes in your own fork.
2. Commit your changes and push to your fork `git push origin master`
3. Create a new pull request and submit it back to the project.


### Bugs & Issues

To report bugs (or any other issues), use the [issues page](https://github.com/Wanekeya/safe-secure-password-generator/issues).
