# Example Config for sshing into your school server with vivado
# Remember to change the file name to local.mk in your clone!
REMOTE_USER = your_username
REMOTE_HOST = your_linux_or_windows_server_with_vivado.edu
REMOTE_DIR  = ~/directory/to/test/project

REMOTE = $(REMOTE_USER)@$(REMOTE_HOST)