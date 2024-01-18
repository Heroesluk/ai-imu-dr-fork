import csv
import os

keys = ["lat", "long", "alt""roll", "pitch", "yaw", "vn", "ve", "vf", "vl", "vu", "ax", "ay", "az", "af", "al",
        "au", "wx", "wy", "wz", "wf", "wl", "wu", "pos_accuracy", "vel_accuracy", "navstat", "numstat",
        "posmode", "velmode", "orimode"]
path = "../dataraw/2011_09_30_drive_0034_extract/2011_09_30/2011_09_30_drive_0034_extract/oxts/data/"

data = open('../dupa.csv', 'w')
writer = csv.writer(data)
writer.writerow(keys)

count = 0
for f in os.listdir(path):
    if count > 1000:
        break
    else:
        count += 1

    with open(path + f) as file:
        d = file.readline().split(' ')
        d = [i.rstrip() for i in d]
        writer.writerow(d)

data.close()
