# Chat application

A Flutter chat app project inspired by WhatsApp with `realtime typing notifications` and `online user activity`.

## What's the tech stack?

This project is made with `Dart` and `RethinkDB` executed on a `Docker` container for the backend part and `Flutter` for the application and the user interfaces.

## How to launch?
### 1. Execute the database on Docker
You will need to have Docker installed on your computer. For help on how to install Docker check the [official documentation](https://docs.docker.com/). Then pull the image and launch the container instance by doing the following:
```
docker pull rethinkdb
docker run -d -p 8080:8080 --name containerName rethinkdb
docker container start containerName
```

### 2. Build the app

1. Clone the repository
2. Download project dependencies executing `flutter pub get` and then launch the app on your editor (personally using VS Code)


## More info about Flutter?
For help getting started with Flutter, view the official
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
