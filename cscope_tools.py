import os, json, sys
import tkinter
import tkinter.filedialog
import tkinter.simpledialog

# detect and mkdir C:\cscope_db\ if not exist
if not os.path.exists("C:\cscope_db"):
    os.makedirs("C:\cscope_db")

# read the content of cs.conf
conf_file_path = "C:\cscope_db\cs.conf"
if not os.path.isfile(conf_file_path):
    default_conf = {'root':'NULL', 'files':[".c", ".cpp", ".h", ".hpp", ".hlsl"]}
    json.dump(default_conf, open(conf_file_path, "w"), indent=4)
cs_conf_file = open(conf_file_path, "r")
cs_conf = json.load(cs_conf_file)

def CsUpdate():
    global cs_conf
    # open C:\cscope_db\cscope.files
    cscope_files = open("C:\cscope_db\cscope.files", "w")
    # foreach files in the directory, get the absolute path
    for root, dirs, files in os.walk(cs_conf["root"]):
        for name in files:
            # only handle .c, .cpp, .h, .hpp, .java, .py
            if name.endswith(tuple(cs_conf['files'])):
                # write the absolute path to cscope.files
                cscope_files.write("\"" + os.path.join(root, name) + "\"\n")
    
    # close cscope.files
    cscope_files.close()
    
    # generate cscope.out to C:\cscope_db\
    os.remove("C:\cscope_db\cscope.out")
    os.system("cscope -bqk -i C:\cscope_db\cscope.files -f C:\cscope_db\cscope.out")

def CsMkRoot():
    #print current dir
    cs_conf["root"] = os.getcwd()
    # write to cs.conf
    json.dump(cs_conf, open("C:\cscope_db\cs.conf", "w"), indent=4)

def CsChRoot():
    # open a dialog to select the root directory
    root = tkinter.Tk()
    root.withdraw()
    cs_conf["root"] = tkinter.filedialog.askdirectory()
    # write to cs.conf
    json.dump(cs_conf, open(conf_file_path, "w"), indent=4)

def CsChFiles():
    # open a dialog to select the root directory
    root = tkinter.Tk()
    root.withdraw()
    s:str = tkinter.simpledialog.askstring('cscope file types', '.hlsl, .c, .cpp, .hpp')
    s = s.replace(' ', '')
    s = s.split(',')
    cs_conf["files"] = s
    # write to cs.conf
    json.dump(cs_conf, open(conf_file_path, "w"), indent=4)

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
    elif sys.argv[1] == '-chroot':
        CsChRoot()
    elif sys.argv[1] == '-files':
        CsChFiles()

