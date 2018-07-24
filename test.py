#!/usr/bin/python
# encoding: utf-8
"""

"""

import time
import sys
import os

in_string = """#111
 1 2
    3 4
5.0 6.0
#22
7.7 8.8
0.9 1.0
#333
77 88
0.99 1.10
77 88
0.99 1.10
77 88
0.99 1.10
77 88
0.99 1.10
"""

maxpoints = 2
        
class Program:
    def __init__(self):
        self.number = ''
        self.pt = []
        
class Point:
    def __init__(self, arr):
        self.x = arr[0]
        self.y = arr[1]
    #def __getitem__(self):
        #return self

token = '#'

Progs = []
chunks = in_string.split('#')
prog_index = -1
for chunk in chunks[1:]:
    prog_index += 1
    lines = chunk.splitlines()
    Progs.append(Program())
    Progs[prog_index].number = int(lines[0])
    point_index = -1
    for line in lines[1:1 + maxpoints]:
        point_index += 1
        Progs[prog_index].pt.append(Point(map(float, line.split()[:2])))
        print Progs[prog_index].number, Progs[prog_index].pt[point_index].x, Progs[prog_index].pt[point_index].y
print
Progs.sort(key=lambda x: x.number, reverse=True)
for prog in Progs:
    print prog.number

#for line in lines:              #open('sample_csv.csv'):
    #if line.startswith(token) and current_chunk: 
        ## if line starts with token and the current chunk is not empty
        #chunks.append(current_chunk[1:]) #  add not empty chunk to chunks
        #current_chunk = [] #  make current chunk blank
    ## just append a line to the current chunk on each iteration
    #current_chunk.append(line.strip())

#chunks.append(current_chunk[1:maxpoints + 1])  #  append the last chunk outside the loop


#print chunks







#for chunk in in_string.split('#'):
        #progs.append()
        #row = 0
    #for line in chunk.splitlines()
        #if row:
            #progs.
            #progs.name = chunk
    #progs.append(chunk.splitlines())
    #print chunk.splitlines()
    #row += 1

#for chunk in in_string.split('#'):
    #progs.append(chunk.splitlines())
    #print chunk.splitlines()
    
    

#for line in lines:
    #if line[0] == '#':
        #i += 1
        #progs[i] = 
    #out_list[i].
    #print line.strip()
    
    
#for chunk in in_string.split('[]'):
    #out_list.append(chunk.splitlines())
#print out_list