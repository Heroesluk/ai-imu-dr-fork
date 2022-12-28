import numpy as np

_semimajor_axis = 6378137.


def project_geodetic_coordinate(coordinates):
    coordinates_length = coordinates.shape[0]
    reference_coordinate = coordinates[0, :]
    reference_latitude = reference_coordinate[1]
    scale = np.cos(np.deg2rad(reference_latitude))

    project_x = scale * _semimajor_axis * np.deg2rad(coordinates[:, 0])
    project_y = scale * _semimajor_axis * np.log(np.tan((90. + coordinates[:, 1]) * np.pi / 360.))
    project_z = coordinates[:, 2]

    reshaped_project_x = project_x.reshape(coordinates_length, 1)
    reshaped_project_y = project_y.reshape(coordinates_length, 1)
    reshaped_project_z = project_z.reshape(coordinates_length, 1)
    projected_coordinate = np.concatenate((reshaped_project_x, reshaped_project_y, reshaped_project_z), axis=1)

    return projected_coordinate
