#/bin/python3

import sys

from xml.dom import minidom

def PrintData(node):
	check = 0
	for child in node.childNodes:
		if isinstance(child, minidom.Text):
			print(child.data)
			print()
		else:
			check = PrintData(child)

	return check


data = sys.stdin.read()

xml = minidom.parseString(data)

for node in xml.getElementsByTagName("kbd"):
	check = PrintData(node)

if check == 1:
	sys.stderr.write("CHECK\n")
else:
	sys.stderr.write("OK\n")

sys.stderr.flush()