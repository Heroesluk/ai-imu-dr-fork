# pylint: disable=C0103,C0111,C0301
import os
import pickle

import numpy as np
import pandas as pd


if __name__ == '__main__':
    pickle_file_folder_path = "/home/heroesluk/PycharmProjects/ai-imu-dr-china/dataraw/2011_09_30_drive_0034_extract/"
    converted_file_name = "2011_09_30_drive_0034_extract"

    PICLE_FILE_EXTENSION = ".p"
    CSV_FILE_EXTENSION = ".csv"

    converted_pickle_file_name = converted_file_name + PICLE_FILE_EXTENSION
    converted_csv_file_name = converted_file_name + CSV_FILE_EXTENSION

    converted_pickle_file_path = os.path.join(pickle_file_folder_path, converted_pickle_file_name)
    converted_csv_file_path = os.path.join(pickle_file_folder_path, converted_csv_file_name)

    converted_pickle_file = open(converted_pickle_file_path, "rb")
    converted_pickle_dict = pickle.load(converted_pickle_file)

    converted_pickle_dict_t = converted_pickle_dict['t']
    converted_pickle_dict_ang_gt = converted_pickle_dict['ang_gt']
    converted_pickle_dict_p_gt = converted_pickle_dict['p_gt']
    converted_pickle_dict_v_gt = converted_pickle_dict['v_gt']
    converted_pickle_dict_u = converted_pickle_dict['u']

    converted_numpy_t = converted_pickle_dict_t.cpu().double().numpy()
    converted_numpy_t = converted_numpy_t.reshape((converted_numpy_t.shape[0], 1))
    converted_numpy_ang_gt = converted_pickle_dict_ang_gt.cpu().double().numpy()
    converted_numpy_p_gt = converted_pickle_dict_p_gt.cpu().double().numpy()
    converted_numpy_v_gt = converted_pickle_dict_v_gt.cpu().double().numpy()
    converted_numpy_u = converted_pickle_dict_u.cpu().double().numpy()

    # 1T,
    # 6U,
    # 3GT,
    # 3GT,
    # 3GT
    # dont delete:
    # t, wx,wy,wz,af,al,au, roll_gt, pitch_gt, yaw_gt, px_gt, py_gt, pz_gt, vx_gt, vy_gt, vz_gt
    # tabs

    converted_numpy = np.hstack((converted_numpy_t, converted_numpy_u, converted_pickle_dict_ang_gt, converted_pickle_dict_p_gt, converted_pickle_dict_v_gt))
    np.savetxt(converted_csv_file_path, converted_numpy, fmt='%.9f', delimiter=", ")
