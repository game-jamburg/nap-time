#!/usr/bin/env python

import bs4, re

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
paths = []
for path in group:
    if type(path) is bs4.element.Tag:
        paths.append(path["d"])

for path in paths:
    ops = re.split("[ ,]", path)
    points = []
    x = 0
    relative = False
    while x < len(ops):
        if not is_number(ops[x]):
            if ops[x].lower() == 'z':
                points.append(points[0])
            else:
                relative = ops[x][0] < 'A'
            x += 1
        else:
            p = (float(ops[x]), float(ops[x+1]))
            q = points[-1] if relative and points else (0, 0)
            points.append((p[0] + q[0], p[1] + q[1]))
            x += 2

for point in points:
    print(point[0], "\t", point[1])