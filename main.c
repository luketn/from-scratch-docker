#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>

static const int PORT = 9191;

int main(int argc, char *argv[]) {
    printf("Hello FROM scratch docker!\n");

    // Creating socket file descriptor
    int socket_file_descriptor;
    if ((socket_file_descriptor = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Failed creating the socket file descriptor.");
        exit(EXIT_FAILURE);
    }

    //Bind to 0.0.0.0:9191
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    if (bind(socket_file_descriptor, (struct sockaddr *) &address, sizeof(address)) < 0) {
        perror("Failed to bind socket to listening address 0.0.0.0:9191");
        exit(EXIT_FAILURE);
    }

    if (listen(socket_file_descriptor, 3) < 0)
    {
        perror("Failed to listen on port 9191");
        exit(EXIT_FAILURE);
    }
    printf("Waiting for connections on port 9191...\n");
    fflush(stdout);

    int new_socket;
    if ((new_socket = accept(socket_file_descriptor, (struct sockaddr *)&address,(socklen_t*)&addrlen))<0)
    {
        perror("Failed to accept new socket!");
        exit(EXIT_FAILURE);
    }

    printf("Accepted a socket!");
}