CLIENT_OBJ=pel.c aes.c sha1.c client.c
SERVER_OBJ=pel.c aes.c sha1.c shell.c

shell:
	gcc -O -W -Wall -o shell $(SERVER_OBJ) -lutil -DLINUX
	strip shell

client:
	gcc -O -W -Wall -o client  $(CLIENT_OBJ)
	strip client

clean:
	rm -f client shell
