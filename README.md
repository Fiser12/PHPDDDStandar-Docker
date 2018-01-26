# PHPDDDStandar use the base of [Lin3s](https://github.com/LIN3S/PhpDDDStandard)

## Description

In this repository I create a Base of the PHPDDDStandar using docker for simplify the development with a Mysql database, nginx, docker and php-ftm.
The idea of this repository is to evolve it to automate deployments using docker. Currently the development environment is built with a makefile.

## Getting Started 
 
These instructions will get you a copy of the project up and running on your local machine. See deployment for notes on how to deploy the project on a live system. 
 
### Prerequisites 
 
* [Docker](https://www.docker.com/) 
* [Docker compose](https://docs.docker.com/compose/) 
 
### How to run 
 
This project is fully Dockerized and orchestrated with Docker Compose. 
 
## How to install

#### Mac OS

* [Download Docker Stable](https://download.docker.com/mac/stable/Docker.dmg)

#### Ubuntu

 Download and install Docker
> wget -qO- https://get.docker.com/ | sh

Prepare permissions for Docker
> sudo usermod -aG docker $(whoami)

Install Docker Compose
> sudo apt-get update
> sudo apt-get -y install python-pip
> sudo pip install docker-compose

## Prepare the environment: 
 
For deploy in dev or prod mode the project have a makefile with the needed commands.

> make deploy ENV=dev

> make deploy ENV=prod

## The objetives of this base project are this:

- [x] Separation between enviroments in Docker and Symfony Application
- [x] Makefile that simplify the operations with Symfony and Docker
- [x] Automatize deploy of dev
- [x] Automatize database preparation with migrations when you deploy
- [X] Production enviroment build
- [ ] Production enviroment deploy
- [ ] Test enviroment with PHPSpec and Docker
- [ ] Test enviroment with Behat and selenium tests
- [ ] Paralelize the tests with docker in multiple instances
- [ ] Microservices separation using Docker, Nginx and Symfony applications

You have more information of this objetives in Projects section of Github Page