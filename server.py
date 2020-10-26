import mcServer
options1 = mcServer.serverConfig(directory='/home/vejlens/')
mcserv = mcServer.mcServer('server-test',options1)
mcserv.serverStart()

mcserv.serverStop()
