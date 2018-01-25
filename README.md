# PHPDDDStandar use the base of [Lin3s](https://github.com/LIN3S/PhpDDDStandard)

## Description

In this repository I create a Base of the PHPDDDStandar using docker for simplify the development with a Mysql database, nginx, docker and php-ftm.
The idea of this repository is to evolve it to automate deployments using docker. Currently the development environment is built with a makefile.

## The objetives of this base project are this:

- [x] Separation between enviroments in Docker and Symfony Application
- [x] Makefile that simplify the operations with Symfony and Docker
- [x] Automatize deploy of dev
- [x] Automatize database preparation with migrations when you deploy
- [ ] Production enviroment build
- [ ] Production enviroment deploy
- [ ] Test enviroment with PHPSpec and Docker
- [ ] Test enviroment with Behat and selenium tests
- [ ] Paralelize the tests with docker in multiple instances
- [ ] Microservices separation using Docker, Nginx and Symfony applications

You have more information of this objetives in Projects section of Github Page