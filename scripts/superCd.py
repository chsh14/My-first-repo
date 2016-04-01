#!/cad/mentor/Python/A_2.7/bin/python

import os, sys
import argparse
from os.path import isdir,join
from subprocess import call

""" Find similarity between strings """
def levenshtein(s, t):
        ''' From Wikipedia article; Iterative with two matrix rows. '''
        if s == t: return 0
        elif len(s) == 0: return len(t)
        elif len(t) == 0: return len(s)
        v0 = [None] * (len(t) + 1)
        v1 = [None] * (len(t) + 1)
        for i in range(len(v0)):
            v0[i] = i
        for i in range(len(s)):
            v1[0] = i + 1
            for j in range(len(t)):
                cost = 0 if s[i] == t[j] else 1
                v1[j + 1] = min(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost)
            for j in range(len(v0)):
                v0[j] = v1[j]
                
        return v1[len(t)]

def main():
    parser = argparse.ArgumentParser(description='Workspace navigation for the lazy')
    parser.add_argument('ip',  metavar='ip', help='IP name')
    parser.add_argument('dir', metavar="dir", nargs='?', help='Subdirectory [s]im or [r]tl')

    args = parser.parse_args()

    try:
        IP_DIR = join(os.environ['VC_WORKSPACE'],"ip")
    except KeyError:
        sys.exit("** VC_WORKSPACE is not set")
        
    IPs = [ip for ip in os.listdir(IP_DIR) if isdir(join(IP_DIR,ip)) and ip[0] != "."]
    candidates = [ip for ip in IPs if args.ip.lower() in ip.lower()]
    if(len(candidates) == 1):
        selectedIp = candidates[0]
    else:
        selectedIp = list(sorted(
            [(ip,levenshtein(args.ip.lower(),ip.lower())) for ip in IPs],
            key=lambda x:x[1]))[0][0]

    if(args.dir is not None):
            if(args.dir[0].lower() == 'r'):
                    subdir = "rtl"
            elif(args.dir[0].lower() == 's'):
                    subdir = "sim/run/rtl/";
    else:
            subdir = ""
        
    print(join(os.environ['VC_WORKSPACE'],'ip',selectedIp,subdir))

if __name__ == "__main__": main()

    
