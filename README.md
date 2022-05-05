# WebFTP

### What is WebFTP?

WebFTP is a "lightweight", simple and fast solution for hosting a file-sharing service via the browser.
Simply put, if you ever wanted to transfer something between a PC and another, and you couldn't bother with a USB, you can just simply start up WebFTP and get those files moved in no time!

### Installing

This application uses Elixir 1.13.4 (Erlang OTP 24) to run. So if you want to run this project, you will have to install Elixir.

Link to the lates version: https://elixir-lang.org/install.html

After you have installed Elixir, simply download the source code!

### Running
Using a shell, navigate to the root folder of the source cod, and then to start the application run:
```bash
mix web_ftp.run "<path to server folder>"
```

After that, everything inside the provided path will be available online for download and for upload.

If you are using linux, or git bash for Windows, you can use the `webftp_sample` shell script to start this program from wherever you want, without having to navigate to the project directory. 

### Security Concerns

Kindly, never let this application run on the open internet, don't open any ports for this application. There is no security checks in place, no verifications, meaning that if you do open it up to the world wide web **anyone** can upload and download. **ANYONE**. 

If you do decide that you want to transfer something from a you to a friend not on your network, then supervise this application, do all the transfers, and the closes the port / stop the application. Don't leave it up. Okay?