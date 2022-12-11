import os
import pickle

PICKLE_EXTENSION = '.p'


def pickle_dump(data, *_file_name):
    file_name = os.path.join(*_file_name)
    if not file_name.endswith(PICKLE_EXTENSION):
        file_name += PICKLE_EXTENSION
    with open(file_name, "wb") as file:
        pickle.dump(data, file)
