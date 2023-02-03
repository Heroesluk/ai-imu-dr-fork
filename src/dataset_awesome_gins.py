from datetime import datetime, timedelta

import pandas as pd
import numpy as np

from os import path as osp

import torch
from matplotlib import pyplot as plt

from src import utils_coordinate
from src.utils_time import interpolate_vector_linear


class AwesomeGinsDataset:
    _DATA_TIMESTAMP = 'DATA_TIMESTAMP'
    _ACCELEROMETER_X = 'ACCELEROMETER_X'
    _ACCELEROMETER_Y = 'ACCELEROMETER_Y'
    _ACCELEROMETER_Z = 'ACCELEROMETER_Z'
    _GYROSCOPE_X = 'GYROSCOPE_X'
    _GYROSCOPE_Y = 'GYROSCOPE_Y'
    _GYROSCOPE_Z = 'GYROSCOPE_Z'

    _GNSS_WEEK = 'GNSS_WEEK'
    _GNSS_SECONDS = 'GNSS_SECONDS'
    _LONGITUDE = 'LONGITUDE'
    _LATITUDE = 'LATITUDE'
    _HEIGHT = 'HEIGHT'
    _VELOCITY_NORTH = 'VELOCITY_NORTH'
    _VELOCITY_EAST = 'VELOCITY_EAST'
    _VELOCITY_DOWN = 'VELOCITY_DOWN'
    _ATTITUDE_ROLL = 'ATTITUDE_ROLL'
    _ATTITUDE_PITCH = 'ATTITUDE_PITCH'
    _ATTITUDE_YAW = 'ATTITUDE_YAW'

    _IMU_FILE_DATA_NAMES_LIST = [
        _DATA_TIMESTAMP,
        _ACCELEROMETER_X,
        _ACCELEROMETER_Y,
        _ACCELEROMETER_Z,
        _GYROSCOPE_X,
        _GYROSCOPE_Y,
        _GYROSCOPE_Z
    ]

    _GROUND_TRUTH_FILE_DATA_NAMES_LIST = [
        _GNSS_WEEK,
        _GNSS_SECONDS,
        _LATITUDE,
        _LONGITUDE,
        _HEIGHT,
        _VELOCITY_NORTH,
        _VELOCITY_EAST,
        _VELOCITY_DOWN,
        _ATTITUDE_ROLL,
        _ATTITUDE_PITCH,
        _ATTITUDE_YAW
    ]

    @staticmethod
    def parse_aiimudr_dataset(folder):
        split_path = osp.split(folder)
        folder_name = split_path[1]
        imu_file_name = folder_name + '.txt'
        imu_file_path = osp.join(folder, imu_file_name)
        ground_truth_file_path = osp.join(folder, 'truth.nav')

        imu_raw_data = pd.read_csv(
            imu_file_path,
            sep='\s+',
            header=0,
            names=AwesomeGinsDataset._IMU_FILE_DATA_NAMES_LIST
        )

        ground_truth_raw_data = pd.read_csv(
            ground_truth_file_path,
            sep='\s+',
            header=0,
            names=AwesomeGinsDataset._GROUND_TRUTH_FILE_DATA_NAMES_LIST
        )

        imu_raw_timestamp = imu_raw_data[AwesomeGinsDataset._DATA_TIMESTAMP].to_numpy()
        imu_raw_timestamp_diff = imu_raw_timestamp[1:] - imu_raw_timestamp[:-1]
        imu_raw_timestamp_diff_max = max(imu_raw_timestamp_diff)
        imu_raw_timestamp_diff_min = min(imu_raw_timestamp_diff)
        if imu_raw_timestamp_diff_max >= 0.006 or imu_raw_timestamp_diff_min < 0.004:
            raise ValueError('Illegal IMU sample rate.')

        ground_truth_raw_timestamp = ground_truth_raw_data[AwesomeGinsDataset._GNSS_SECONDS].to_numpy()

        ground_truth_raw_ang = ground_truth_raw_data.loc[
                               :,
                               [AwesomeGinsDataset._ATTITUDE_ROLL,
                                AwesomeGinsDataset._ATTITUDE_PITCH,
                                AwesomeGinsDataset._ATTITUDE_YAW
                                ]].to_numpy()
        aiimudr_dataset_ground_truth_ang = interpolate_vector_linear(
            ground_truth_raw_ang,
            ground_truth_raw_timestamp,
            imu_raw_timestamp
        )

        ground_truth_raw_v = ground_truth_raw_data.loc[
                             :,
                             [AwesomeGinsDataset._VELOCITY_NORTH,
                              AwesomeGinsDataset._VELOCITY_EAST,
                              AwesomeGinsDataset._VELOCITY_DOWN
                              ]].to_numpy()
        aiimudr_dataset_ground_truth_v = interpolate_vector_linear(
            ground_truth_raw_v,
            ground_truth_raw_timestamp,
            imu_raw_timestamp
        )

        ground_truth_geodetic_coordinate = ground_truth_raw_data.loc[
                                           :,
                                           [AwesomeGinsDataset._LONGITUDE,
                                            AwesomeGinsDataset._LATITUDE,
                                            AwesomeGinsDataset._HEIGHT
                                            ]].to_numpy()

        ground_truth_projected_coordinate = utils_coordinate.project_geodetic_coordinate(
            ground_truth_geodetic_coordinate
        )

        ground_truth_projected_coordinate_interpolated = interpolate_vector_linear(
            ground_truth_projected_coordinate,
            ground_truth_raw_timestamp,
            imu_raw_timestamp
        )

        aiimudr_dataset_ground_truth_p = ground_truth_projected_coordinate_interpolated - ground_truth_projected_coordinate_interpolated[0, :]

        # test plot
        fig, ax = plt.subplots()
        fig.set_dpi(300.)
        ax.plot(aiimudr_dataset_ground_truth_p[:, 0], aiimudr_dataset_ground_truth_p[:, 1])
        quiver_x = aiimudr_dataset_ground_truth_p[0, 0]
        quiver_y = aiimudr_dataset_ground_truth_p[0, 1]
        quiver_u = aiimudr_dataset_ground_truth_p[-1, 0] - aiimudr_dataset_ground_truth_p[0, 0]
        quiver_v = aiimudr_dataset_ground_truth_p[-1, 1] - aiimudr_dataset_ground_truth_p[0, 1]
        ax.quiver(quiver_x, quiver_y, quiver_u, quiver_v, units='xy')
        ax.axis('equal')
        plt.show()

        aiimudr_dataset_u = imu_raw_data.loc[
                            :,
                            [AwesomeGinsDataset._GYROSCOPE_X,
                             AwesomeGinsDataset._GYROSCOPE_Y,
                             AwesomeGinsDataset._GYROSCOPE_Z,
                             AwesomeGinsDataset._ACCELEROMETER_X,
                             AwesomeGinsDataset._ACCELEROMETER_Y,
                             AwesomeGinsDataset._ACCELEROMETER_Z
                             ]].to_numpy()

        imu_raw_reference_timestamp = imu_raw_timestamp[0]
        aiimudr_dataset_timestamp = imu_raw_timestamp - imu_raw_reference_timestamp

        aiimudr_dataset_u_length = aiimudr_dataset_u.shape[0]
        aiimudr_dataset_timestamp_reshaped = aiimudr_dataset_timestamp.reshape(aiimudr_dataset_u_length, 1)
        aiimudr_dataset_u_simulation = np.zeros_like(aiimudr_dataset_u)
        for i in range(0, aiimudr_dataset_u_length):
            clip_head = i - 1
            clip_tail = i + 2
            t_solved = 1
            if i == 0:
                t_solved = 0
                clip_head = 0
                clip_tail = 3
            elif i == aiimudr_dataset_u_length - 1:
                t_solved = 2
                clip_head = i - 2
                clip_tail = i + 1

            t = aiimudr_dataset_timestamp_reshaped[clip_head:clip_tail, 0]
            a = np.ones((3, 3))
            a[:, 1] = t
            a[:, 2] = t**2

            for j in range(0, 6):
                b = aiimudr_dataset_u[clip_head:clip_tail, j]
                # x = np.linalg.solve(a, b)
                simulation_y1 = (b[1] - b[0]) / (t[1] - t[0])
                simulation_x1 = (t[0] + t[1]) / 2.
                simulation_y2 = (b[2] - b[1]) / (t[2] - t[1])
                simulation_x2 = (t[1] + t[2]) / 2.
                simulation_k = (simulation_y2 - simulation_y1) / (simulation_x2 - simulation_x1)
                aiimudr_dataset_u_simulation[i, j] = simulation_k * (t[t_solved] - simulation_x1) + simulation_y1

        aiimudr_dataset_u_simulation[:, 5] = aiimudr_dataset_u_simulation[:, 5] + 9.8

        fig_u, ax_u = plt.subplots(2, 1, sharex=True)
        ax_u[0].plot(aiimudr_dataset_timestamp, aiimudr_dataset_u_simulation[:, :3])
        ax_u[1].plot(aiimudr_dataset_timestamp, aiimudr_dataset_u_simulation[:, 3:6])
        plt.show()

        t = torch.from_numpy(aiimudr_dataset_timestamp)
        ang_gt = torch.from_numpy(aiimudr_dataset_ground_truth_ang)
        v_gt = torch.from_numpy(aiimudr_dataset_ground_truth_v)
        p_gt = torch.from_numpy(aiimudr_dataset_ground_truth_p)
        u = torch.from_numpy(aiimudr_dataset_u_simulation)

        # https://github.com/purpleskyfall/gnsscal/blob/master/gnsscal.py
        gnss_week = ground_truth_raw_data.loc[0, AwesomeGinsDataset._GNSS_WEEK]
        gnss_start = datetime(year=1980, month=1, day=6)
        gnss_duration = timedelta(seconds=gnss_week * 7 * 24 * 3600 + imu_raw_reference_timestamp)
        gnss_datetime = gnss_start + gnss_duration
        gnss_datetime64 = np.datetime64(gnss_datetime)
        aiimudr_dataset_reference_timestamp = gnss_datetime64.astype('float64') / 1e09
        aiimudr_dataset_file_name = "{}_drive_{:0>4}_extract".format(gnss_datetime.strftime("%Y_%m_%d"), 1)

        aiimudr_data = {
            't': t,
            'ang_gt': ang_gt,
            'v_gt': v_gt,
            'p_gt': p_gt,
            'u': u,
            'name': aiimudr_dataset_file_name,
            't0': aiimudr_dataset_reference_timestamp
        }

        return aiimudr_data
