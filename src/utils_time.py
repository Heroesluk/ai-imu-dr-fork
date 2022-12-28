import pandas as pd
import scipy

_nano_to_sec = 1e09


def custom_timestamp_nano_parser(custom_timestamp):
    # https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior
    timestamp = pd.to_datetime(custom_timestamp, format='%Y/%m/%d %H:%M:%S.%f', errors='ignore')
    datetime64 = timestamp.to_datetime64()
    return datetime64.astype('float64')


def custom_timestamp_sec_parser(custom_timestamp):
    # https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior
    timestamp = pd.to_datetime(custom_timestamp, format='%Y/%m/%d %H:%M:%S.%f', errors='ignore')
    datetime64 = timestamp.to_datetime64()
    return datetime64.astype('float64') / _nano_to_sec


def convert_numpy_datetime64_to_datetime_datetime(numpy_datetime64):
    # https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior
    timestamp = pd.to_datetime(custom_timestamp, format='%Y/%m/%d %H:%M:%S.%f', errors='ignore')
    datetime64 = timestamp.to_datetime64()
    return datetime64.astype('float64') / _nano_to_sec


def interpolate_vector_linear(input_vector, input_timestamp, output_timestamp):
    """
    This function interpolate n-d vectors (despite the '3d' in the function name) into the output time stamps.

    Args:
        input_vector: Nxd array containing N d-dimensional vectors.
        input_timestamp: N-sized array containing time stamps for each of the input quaternion.
        output_timestamp: M-sized array containing output time stamps.
    Return:
        quat_inter: Mxd array containing M vectors.
    """
    assert input_vector.shape[0] == input_timestamp.shape[0]
    func = scipy.interpolate.interp1d(input_timestamp, input_vector, axis=0)
    interpolated = func(output_timestamp)
    return interpolated
