Welcome to the Sign app developers team!
This guide will assist you in setting up your development environment.

## Requirements Flutter and Python
Here are all the items that must be present on your local machine to get started.
Of course, if you only want to work on one part, not all items are necessary.
For example, if you only want to work on the app, you only need to have Flutter installed.

We're assuming that you've got Git and an IDE all set up.
If you're not sure which IDE to use, no worries! We recommend [PyCharm](https://www.jetbrains.com/pycharm/) for Python and [Android Studio](https://developer.android.com/studio) for Flutter.

0. Install the Flutter SDK from the official [Flutter website](https://flutter.dev/docs/get-started/install).
   Choose the link for your operating system and follow the instructions.
   Or use Android studio to install Flutter.

0. Make sure you have [Python installed](https://www.python.org/downloads/). 
   Check your Python version with the following command
   ``` {.bash .copy}
   python --version 
   ```
   Version 3.8, 3.9, 3.10 and 3.11 are acceptable as these versions are compatible with Django 4.1

0. Check if pip is installed with the following command:
   ``` {.bash .copy}
   pip --version
   ```
   If pip is not installed look at the [official pip website](https://pip.pypa.io/en/stable/installation/) for an installation guide for you operating system.

0. Optional but recommended is installing a virtual environment for python like **virtualenv**.

## Setting up the Project

0. Clone or download the project source code from the project's [GitHub repository](https://github.com/Signbank/sign-app).
   For example:
   ```{.bash .copy}
   git clone git@github.com:Signbank/sign-app.git
   ```

### Flutter
0. Set up the Flutter app by opening the project folder in a code editor and running flutter pub get in the terminal to install any required packages.

0. In the Flutter app code, update the **url_config** file to switch between localhost and the server. For example:
   ```{.dart}
   bool _signAppLocalhost = true
   ```
   This will make sure the app uses the local Django server.

0. Run the Flutter app on an emulator or physical device by running flutter run in the terminal or through Android studio. The app should be able to communicate with the local Django server and fetch data from the API endpoints.

### Django

0. Create a virtual environment
   ```{.bash .copy}
   virtualenv env 
   ```

0. Activate the virtual environment
   ```{.bash .copy}
   source env/bin/activate
   ```

0. Set up the Django backend by navigating to the backend folder (called django) in the terminal and running python manage.py migrate to create the database tables. Optionally, you can create a superuser account by running python manage.py createsuperuser.

0. Install the required packages by running the following command:
   ```{.bash .copy}
   pip -r install requirements.txt
   ```

0. Set up Django secrete key by creating a **.env** file in the **signapp** directory.
   You can create this file with the following command on unix systems:
   ```{.bash .copy}
   touch signapp/.env
   ```
   NOTE: It is a hidden file so enable hidden files in your file explorer or use **ls -a** command to see it. 

0. Add the following line to the **.env** file:
   ```{.bash .copy}
   SECRET_KEY = 'django-insecure-super-ultra-secret-key'
   ```
   For local development the key can be any string.

0. Run the Django server by running python manage.py runserver in the terminal. The server will start at http://localhost:8000/.

### Documentation

0. Install MkDocs Material with the following command:
   ```{.bash .copy}
   pip install mkdocs-material
   ```

0. Run the server:
   ```{.bash .copy}
   mkdocs serve
   ```
   
0. Edit and save the documentation markdown files and see you changes at http://localhost:8000/.


### Server

0. Follow [these](https://ponyland.science.ru.nl/ponyland/websites/containers/) steps to setup apache on the LXD container. On step 7 add the folliwing line instead of the one in the guide:

```
ProxyPass /api http:localhost:8000/
```

This redirects all api traffic to Django localhost.

0. Build a Flutter web app with the following command:
```
flutter build web
```

0. Place the contents of the flutter web build on the server in the */var/www/html* directory and remove the default index.html.

