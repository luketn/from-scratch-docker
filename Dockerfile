FROM alpine as build
WORKDIR /app
RUN apk add --no-cache gcc clang g++ binutils
ADD main.c .
RUN clang -static main.c -o main
RUN echo "done!"

FROM scratch
WORKDIR /app
COPY --from=build /app/main ./
ENTRYPOINT ["/app/main"]