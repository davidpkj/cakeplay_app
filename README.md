# Cakeplay

A ~~way too buggy~~ simple music player. I'm not sure where this is going to be honest. I just wanted a normal working music player.

# Downloading

Coming to a Google Play Store near you somewhere in the next 6 months!

If you are really impacient or want the latest and greates features, you can compile and install from source of course:

1. Make sure you have the latest version of `flutter` and `git`.

2. Clone and enter this repo:
    ```bash
    git clone https://github.com/davidpkj/cakeplay_app && cd cakeplay_app
    ```

3. Build the application:
    ```bash
    flutter build apk --release
    ```

4. Prepare your actual phone for the installation:
    - Connect it to your Machine with a cable
    - Turn on USB-Debuging
    - Allow your machine access to your phone

5. Install the application:
    ```bash
    flutter install
    ```

To update the app, enter the directory (`cakeplay_app`) and run:
```bash
git fetch && git pull
```
Afterwards just repeat steps 3-5.