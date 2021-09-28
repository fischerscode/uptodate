FROM dart:stable as build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart pub get --offline
RUN dart compile exe bin/uptodate.dart -o bin/uptodate

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/uptodate /app/bin/

ENTRYPOINT [ "/app/bin/uptodate github -f $INPUT_CONFIG -r $INPUT_REPOSITORY -t $INPUT_TOKEN" ]