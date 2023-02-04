import logging

from utils_time import custom_log_timestamp


def log_info(tag, log_str):
    logging.info('%s %s: %s', custom_log_timestamp(), tag, log_str)
