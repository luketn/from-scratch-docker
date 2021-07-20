FROM alpine as build
WORKDIR /app
RUN apk add --no-cache gcc clang g++ binutils
ADD main.c .
RUN clang main.c -o main
RUN mkdir libs
RUN ldd main | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' libs/
RUN echo "done!"

FROM alpine
# tried to get scratch working, error is:
# standard_init_linux.go:228: exec user process caused: no such file or directory
WORKDIR /app
COPY --from=build /app/main ./
COPY --from=build /app/libs/ /libs/
ENV PATH="/app/libs:${PATH}"
ENTRYPOINT ["/app/main"]