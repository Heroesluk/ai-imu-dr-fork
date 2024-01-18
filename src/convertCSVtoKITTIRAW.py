file_path = "../przejazd_01Sheet1.csv"

import csv

# lat,long,altroll,pitch,yaw,vn,ve,vf,vl,vu,ax,ay,az,af,al,au,wx,wy,wz,wf,wl,wu,pos_accuracy,vel_accuracy,navstat,numstat,posmode,velmode,orimode
indexes = [13, 14, 15, 16, 17, 18]
indexes_push = [7, 8, 9, 17, 18, 19]

timestamp_index = 6

row = [1 for i in range(31)]
print(row)
data = []
with open("/home/heroesluk/PycharmProjects/ai-imu-dr-china/przejazd_01Sheet1.csv", mode='r') as file:
    dt = file.readlines()[1:]
    for lines in dt:
        for i, v in enumerate(lines.split(",")):
            if i > 19:
                break

            if i in indexes_push:
                row[i] = float(v)
            else:
                row[i] = 1

            data.append(row)

path = "../customData/2024_01_12_drive_0001_extract/2024_01_12/2024_01_12_drive_0001_extract/velodyne_points/data/"
index = 1
for line in data:
    with open(path + str(index) + ".txt", mode='w') as file:
        file.write(str(line)[1:-1])

    index += 1
