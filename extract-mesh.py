#!/usr/bin/env python

import bs4, re, sys

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

import fileinput

data = ""
for line in fileinput.input():
    data += line + "\n"

soup = bs4.BeautifulSoup(data, 'xml')
group = soup.find(id="mesh")
pathdata = []
for path in group:
    if type(path) is bs4.element.Tag:
        pathdata.append(path["d"])

paths = []
for path in pathdata:
    ops = re.split("[ ,]", path)
    points = []
    x = 0
    relative = False
    moving = True
    lastPoint = (0, 0)
    startPoint = (0, 0)
    while x < len(ops):
        if not is_number(ops[x]):
            letter = ops[x]
            if letter.lower() == 'z':
                points.append(startPoint)
                paths.append(points)
                points = []
                startPoint = (0,0)
            else:
                moving = (letter.lower() == 'm')
            relative = ord(letter) >= ord('a')
            x += 1
        else:
            p = (float(ops[x]), float(ops[x+1]))
            q = lastPoint if relative else (0, 0)
            p = (p[0] + q[0], p[1] + q[1])
            lastPoint = p
            if not points:
                startPoint = p
            points.append(p)
            x += 2
            moving = False
    paths.append(points)

print("{{" + "},{".join([",".join(["{%s,%s}" % point for point in path]) for path in paths]) + "}}")
