import os, json, sys

# detect and mkdir C:\cscope_db\ if not exist
if not os.path.exists("C:\cscope_db"):
    os.makedirs("C:\cscope_db")

# read the content of cs.conf
cs_conf_file = open("C:\cscope_db\cs.conf", "r")
cs_conf = json.load(cs_conf_file)

def CsUpdate():
    global cs_conf
    # open C:\cscope_db\cscope.files
    cscope_files = open("C:\cscope_db\cscope.files", "w")
    # foreach files in the directory, get the absolute path
    for root, dirs, files in os.walk(cs_conf["root"]):
        for name in files:
            # only handle .c, .cpp, .h, .hpp, .java, .py
            if name.endswith((".c", ".cpp", ".h", ".hpp", ".hlsl")):
                # write the absolute path to cscope.files
                cscope_files.write("\"" + os.path.join(root, name) + "\"\n")
    
    # close cscope.files
    cscope_files.close()
    
    # generate cscope.out to C:\cscope_db\
    os.system("cscope -bqk -i C:\cscope_db\cscope.files -f C:\cscope_db\cscope.out")

def CsMkRoot():
    #print current dir
    cs_conf["root"] = os.getcwd()
    # write to cs.conf
    json.dump(cs_conf, open("C:\cscope_db\cs.conf", "w"), indent=4)

# check arguments
if not len(sys.argv) == 2:
    print("Please set the command, e.g. \"python cscope_tools.py -update\"")
    print("Curren support commands: -update, -mkroot")
    sys.exit(0)

if len(sys.argv) == 2:
    if sys.argv[1] == '-update':
        CsUpdate()
    elif sys.argv[1] == '-mkroot':
        CsMkRoot()

