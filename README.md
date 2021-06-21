# Cakeplay

A ~~way too buggy~~ simple music player. I'm not sure where this is going to be honest. I just wanted a normal working music player.

# Downloading

Coming to a Google Play Store near you somewhere in the next 6 months!

If you are really impacient or want the latest and greates features, you can compile and install from source of course:

1. Make sure you have the latest version of `flutter`, `git` and `keytool`.

2. Clone and enter this repo:
    ```bash
    git clone https://github.com/davidpkj/cakeplay_app && cd cakeplay_app
    ```

3. Create a signing configuration:
    ```properties
    # cakeplay_app/android/key.properties

    storePassword=YOUR_PASSWORD
    keyPassword=YOUR_PASSWORD
    keyAlias=upload
    storeFile=PATH_TO_JKS
    ```
    and create the Keystore using the following command if you're on Mac/Linux:
    ```bash
    keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    ```

    or this one if you're on Windows:
    ```cmd
    keytool -genkey -v -keystore c:\Users\USER_NAME\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    ```

    NOTE: If you are on Windows, remember to replace `USER_NAME` with your actual system user name!

    NOTE: Remember to replace the `storePassword`, `keyPassword` and `storeFile` in the config file with the data from the last command!

4. Build the application:
    ```bash
    flutter build apk --release
    ```

5. Prepare your actual phone for the installation:
    - Connect it to your Machine with a cable
    - Turn on USB-Debuging
    - Allow your machine access to your phone

6. Install the application:
    ```bash
    flutter install
    ```

To update the app, enter the directory (`cakeplay_app`) and run:
```bash
git fetch && git pull
```
Afterwards just repeat steps 4-6.