# How I made my website
I have a peculiar website design (backend-wise). Installing it took some figuring out, so I wrote this post to help me remember, and maybe to help some other people out.

Everything will be running on one CentOS 7 server. I won't describe how to install CentOS. Just google how to install the minimal CentOS installation.

## Website setup
I'll have a front-end with an index.html page in which I have the menu and some javascript functions to fetch the current page.

All the content of the website will be written in markdown, and served by [Markserv](https://github.com/markserv/markserv). This means that Markserv gets the markdown file and translates it to html. My front-end will then insert that html to the main page.

## Installing Markserv
- [
