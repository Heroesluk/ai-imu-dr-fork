# pylint: disable=C0103,C0111,C0301

import argparse
import os
from os import path as osp


from src.dataset_chongqing import CustomChongQingDataset
from src.utils_file import pickle_dump

GENERATED_AIIMUDR_DATASET_FOLDER_NAME = 'DATASET_AIIMUDR'

_nano_to_sec = 1e09


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--path', type=str, default=None, help='Path to a dataset folder.')
    parser.add_argument('--list', type=str, default=None, help='Path to a list file.')
    parser.add_argument('--skip_front', type=int, default=200, help='Number of discarded records at beginning.')
    parser.add_argument('--skip_end', type=int, default=200, help='Numbef of discarded records at end')
    parser.add_argument('--output_samplerate', type=int, default=200, help='Output sample rate. Default is 200Hz')
    parser.add_argument('--recompute', action='store_true',
                        help='When set, the previously computed results will be over-written.')
    parser.add_argument('--no_trajectory', action='store_true',
                        help='When set, no ply files will be written.')
    parser.add_argument('--no_remove_duplicate', action='store_true')
    parser.add_argument('--clear_result', action='store_true')
    parser.add_argument('--fast_mode', action='store_true')

    args = parser.parse_args()

    dataset_list = []
    root_dir = ''
    if args.path:
        dataset_list.append(args.path)
    elif args.list:
        root_dir = osp.dirname(args.list) + '/'
        with open(args.list) as f:
            for s in f.readlines():
                if s[0] != '#':
                    dataset_list.append(s.strip('\n'))
    else:
        raise ValueError('No data specified')

    print(dataset_list)

    total_length = 0.0
    length_dict = {}

    for dataset in dataset_list:
        if len(dataset.strip()) == 0:
            continue
        if dataset[0] == '#':
            continue

        generated_folder_path = osp.join(dataset, GENERATED_AIIMUDR_DATASET_FOLDER_NAME)
        if not osp.isdir(generated_folder_path):
            os.makedirs(generated_folder_path)

        aiimudr_data = CustomChongQingDataset.parse_aiimudr_dataset(dataset)

        pickle_dump(aiimudr_data, generated_folder_path, aiimudr_data['name'])
