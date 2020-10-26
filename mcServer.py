import pexpect
import sys

class serverConfig:
    # serverConfig - Object with all options to start a server

    def __init__(self, timeout=60, memory='1G', jarfile='server.jar',
                 directory='/var/minecraft-server/'):
        self.timeout = timeout
        self.memory = memory
        self.jarfile = jarfile
        self.directory = directory

#    def readFromFile(self, filename):
        # readFromFile() - Sets the serverConfig object based on a file
        #
        # Input: filename: String, file to open
        
#    def writeToFile(self, filename):
        # writetoFile() - Sets the serverConfig object based on a file
        #
        # Input: filename: String, file to open

class mcServer:
    #TODO: Implement a log
    #TODO: Load settings (from file?)
    #TODO: Identify server directory

    def __init__(self, name, server_config):
        # __init__() - Initialize the server object
        #
        # Input:
        #   name: String, name of server
        #   server_config: serverConfig, options for server

        #TODO: Logfile
        self.name = name
        self.options = server_config


    def isRunning(self):
        # isRunning() - Checks if the server process has exited
        #
        # Assumes a Popen object to poll, else server is shutdown
        # Return: boolean

        try:
            return self.serverp.isalive()
        except:
            return False


    def sendCommand(self, command_str):
        # sendCommand() - Sends command to server
        #
        # Input: command_str: String, command to send
        assert self.isRunning()

        self.serverp.sendline(command_str)


    def serverStart(self):
        # serverStart() - Starts the server object
        #
        launch_options = ['-jar', '-Xmx'+self.options.memory,
                          '-Xms'+self.options.memory, self.options.jarfile, 'nogui']
        
        self.serverp = pexpect.spawn('java', launch_options,
                                     cwd=self.options.directory + self.name,
                                     timeout=self.options.timeout)

        #TODO: temporarily sets output to terminal, should be log
        self.serverp.logfile = sys.stdout.buffer
        
        #This throws an exeption if the server dows not start
        #TODO: Catch exeption, do process cleanup ant throw exception upstream
        self.serverp.expect('.* \[Server thread/INFO\]: Done .*')

    def serverStop(self):
        # serverStop() - Stops the main process
        # 
        assert self.isRunning()

        try:
            self.serverp.sendline('stop')
            self.serverp.expect(pexpect.EOF)
            if not self.isRunning():
                print('Server shut down cleanly')
        except:
            print("Server seems frozen in shutdown, killing it")
            self.serverp.terminate(force=True)

        #TODO: Process cleanup
